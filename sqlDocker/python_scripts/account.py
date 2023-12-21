from bs4 import BeautifulSoup
import pandas as pd
import numpy as np

def make_account_dim(accountInfo:pd.DataFrame):
    '''populates df for sql insertion'''
    accountDim = pd.DataFrame({'SK_AccountID':[]})
    accountDim['AccountID'] = accountInfo.CA_ID
    accountDim['BrokerID'] = accountInfo.Account_CA_B_ID
    accountDim['SK_BrokerID'] = np.nan
    accountDim['CustomerID'] = accountInfo.C_ID
    accountDim['SK_CustomerID'] = np.nan
    accountDim['Status'] = accountInfo.status
    accountDim['AccountDesc'] = accountInfo.Account_CA_NAME
    accountDim['TaxStatus'] = accountInfo.CA_TAX_ST
    accountDim['IsCurrent'] = accountInfo.current.apply(int)
    accountDim['BatchID'] = 1
    accountDim['EffectiveDate'] = accountInfo.start
    accountDim['EndDate'] = accountInfo.end
    accountDim['ActionType'] = accountInfo.ActionType
    return accountDim

def get_accounts(df:pd.DataFrame):
    '''applies 3 of 5 logics for accounts'''
    accountssUpdated = {}
    accountArray = []
    for index, row in df.iterrows():
        if row.ActionType in ('NEW', 'ADDACCT'):
            new_row = {**row.to_dict(), **{'status':'active','current':True,'start':row.ActionTS}}
            accountssUpdated[row.CA_ID] = new_row
        elif row.ActionType == 'UPDACCT':
            old_row = {**accountssUpdated[row.CA_ID], **{'current':False, 'CA_ID':row.C_ID,'end':row.ActionTS}}
            new_row = {**accountssUpdated[row.CA_ID], **{k: v for k, v in row.dropna().to_dict().items() if v}, **{'start':row.ActionTS}}
            accountssUpdated[row.CA_ID] = new_row
            accountArray.append(old_row)
        elif row.ActionType == 'CLOSEACCT':
            old_row = {**accountssUpdated[row.CA_ID], **{'current':False, 'CA_ID':row.CA_ID, 'end':row.ActionTS}}
            new_row = {**accountssUpdated[row.CA_ID], **{'status':'inactive','start':row.ActionTS}}
            accountssUpdated[row.CA_ID] = new_row
    accountArray += [{**accountssUpdated[i], **{'CA_ID':i, 'end':'9999-12-31T00:00:00'}} for i in accountssUpdated]
    accountInfo = pd.DataFrame.from_records(accountArray, index='CA_ID').reset_index()
    return make_account_dim(accountInfo)

with open('/usr/config/data/gendata/Batch1/CustomerMgmt.xml', 'r') as f:
    file = f.read() 
soup = BeautifulSoup(file, 'xml')

name = {
    'C_L_NAME':{'end':True},
    'C_F_NAME':{'end':True},
    'C_M_NAME':{'end':True}
}

address= {
    'C_ADLINE1':{'end':True},
    'C_ADLINE2':{'end':True},
    'C_ZIPCODE':{'end':True},
    'C_CITY':{'end':True},
    'C_STATE_PROV':{'end':True},
    'C_CTRY':{'end':True}
}

phone={
    'C_CTRY_CODE':{'end':True},
    'C_AREA_CODE':{'end':True},
    'C_LOCAL':{'end':True},
    'C_EXT':{'end':True}
}

contactInfo ={
    'C_PRIM_EMAIL':{'end':True},
    'C_ALT_EMAIL':{'end':True},
    'C_PHONE_1':phone,
    'C_PHONE_2':phone,
    'C_PHONE_3':phone
}

tax ={
    'C_LCL_TX_ID':{'end':True},
    'C_NAT_TX_ID':{'end':True}
}

account = {
    'attrs':True,
    'CA_B_ID':{'end':True},
    'CA_NAME':{'end':True}
}

Customer = {
    'attrs':True,
    'Name':name,
    'Address':address,
    'ContactInfo':contactInfo,
    'TaxInfo':tax,
    'Account': account
}

def get_attributes(tag, explain_dict, prefix = ''):
    '''Parses a tag into a dictionary according to the explain dict'''
    if 'end' in explain_dict:
        return {prefix :tag.text}
    
    result = {}
    for child_tag in explain_dict:
        if child_tag == 'attrs':
            result = {**result, **tag.attrs}
        else:
            ct = tag.find(child_tag)
            if ct == None:
                continue
            result = { **get_attributes(
                ct, 
                explain_dict[child_tag],
                prefix+'_'+child_tag if len(prefix)>0 else child_tag
            ), **result}
    return result

result = []
for i in soup.find_all('TPCDI:Action'):
    result.append({**i.attrs,**get_attributes(i.find('Customer'), Customer)})
df = pd.DataFrame(result)
accountsdf = get_accounts(df)
accountsdf.to_csv('/usr/config/data/gendata/Batch1/AccountDim.csv', index=False)
