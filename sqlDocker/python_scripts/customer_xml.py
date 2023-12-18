from bs4 import BeautifulSoup
import pandas as pd
import numpy as np

def make_customer_dim(customerInfo:pd.DataFrame):
    customerDim = pd.DataFrame({'SK_CustomerID':[]})
    customerDim['CustomerID'] = customerInfo.C_ID
    customerDim['TaxId'] = customerInfo.C_TAX_ID
    customerDim['Status'] = customerInfo.status
    customerDim['LastName'] = customerInfo.Name_C_L_NAME
    customerDim['FirstName'] = customerInfo.Name_C_F_NAME
    customerDim['MiddleInitial'] = customerInfo.Name_C_M_NAME
    customerDim['Gender'] = customerInfo.C_GNDR
    customerDim['Tier'] = customerInfo.C_TIER
    customerDim['DOB'] = customerInfo.C_DOB
    customerDim['AddressLine1'] = customerInfo.Address_C_ADLINE1
    customerDim['AddressLine2'] = customerInfo.Address_C_ADLINE2
    customerDim['PostalCode'] = customerInfo.Address_C_ZIPCODE
    customerDim['City'] = customerInfo.Address_C_CITY
    customerDim['StateProv'] = customerInfo.Address_C_STATE_PROV
    customerDim['Country'] = customerInfo.Address_C_CTRY
    customerDim['Phone1'] = \
        customerInfo.ContactInfo_C_PHONE_1_C_CTRY_CODE + \
        customerInfo.ContactInfo_C_PHONE_1_C_AREA_CODE + \
        customerInfo.ContactInfo_C_PHONE_1_C_LOCAL + \
        customerInfo.ContactInfo_C_PHONE_1_C_EXT
    customerDim['Phone2'] = \
        customerInfo.ContactInfo_C_PHONE_2_C_CTRY_CODE + \
        customerInfo.ContactInfo_C_PHONE_2_C_AREA_CODE + \
        customerInfo.ContactInfo_C_PHONE_2_C_LOCAL + \
        customerInfo.ContactInfo_C_PHONE_2_C_EXT
    customerDim['Phone3'] = \
        customerInfo.ContactInfo_C_PHONE_3_C_CTRY_CODE + \
        customerInfo.ContactInfo_C_PHONE_3_C_AREA_CODE + \
        customerInfo.ContactInfo_C_PHONE_3_C_LOCAL + \
        customerInfo.ContactInfo_C_PHONE_3_C_EXT
    customerDim['Email1'] = customerInfo.ContactInfo_C_PRIM_EMAIL
    customerDim['Email2'] = customerInfo.ContactInfo_C_ALT_EMAIL
    customerDim['NationalTaxRateDesc'] = np.nan
    customerDim['NationalTaxRate'] = np.nan
    customerDim['LocalTaxRateDesc'] = np.nan
    customerDim['LocalTaxRate'] = np.nan
    customerDim['AgencyID'] = np.nan
    customerDim['CreditRating'] = np.nan
    customerDim['NetWorth'] = np.nan
    customerDim['MarketingNameplate'] = np.nan
    customerDim['IsCurrent'] = customerInfo.current.apply(int)
    customerDim['BatchID'] = 1
    customerDim['EffectiveDate'] = customerInfo.start
    customerDim['EndDate'] = customerInfo.end
    customerDim['nationalTaxId'] = customerInfo.TaxInfo_C_NAT_TX_ID
    customerDim['localTaxId'] = customerInfo.TaxInfo_C_LCL_TX_ID

    return customerDim

def get_customers(df:pd.DataFrame):
    customersUpdated = {}
    customerArray = []
    for index, row in df.iterrows():
        if row.ActionType == 'NEW':
            new_row = {**row.to_dict(), **{'status':'active','current':True,'start':row.ActionTS}}
            customersUpdated[row.C_ID] = new_row
        elif row.ActionType == 'UPDCUST':
            old_row = {**customersUpdated[row.C_ID], **{'current':False, 'C_ID':row.C_ID,'end':row.ActionTS}}
            new_row = {**customersUpdated[row.C_ID], **{k: v for k, v in row.dropna().to_dict().items() if v}, **{'start':row.ActionTS}}
            customersUpdated[row.C_ID] = new_row
            customerArray.append(old_row)
        elif row.ActionType == 'INACT':
            old_row = {**customersUpdated[row.C_ID], **{'current':False, 'C_ID':row.C_ID, 'end':row.ActionTS}}
            new_row = {**customersUpdated[row.C_ID], **{'status':'inactive','start':row.ActionTS}}
            customersUpdated[row.C_ID] = new_row
    customerArray += [{**customersUpdated[i], **{'C_ID':i, 'end':'9999-12-31T00:00:00'}} for i in customersUpdated]
    customerInfo= pd.DataFrame.from_records(customerArray, index='C_ID').reset_index()
    return make_customer_dim(customerInfo)


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
customersdf = get_customers(df)

df.to_csv('/usr/config/data/gendata/Batch1/CustomerMgmtParsed.csv', index=False)
customersdf.to_csv('/usr/config/data/gendata/Batch1/CustomerDim.csv', index=False)