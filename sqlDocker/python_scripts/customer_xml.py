from bs4 import BeautifulSoup
import pandas as pd
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
            result |= tag.attrs
        else:
            ct = tag.find(child_tag)
            if ct == None:
                continue
            result |= get_attributes(
                ct, 
                explain_dict[child_tag],
                prefix+'_'+child_tag if len(prefix)>0 else child_tag
            )
    return result

result = []
for i in soup.find_all('TPCDI:Action'):
    result.append(i.attrs|get_attributes(i.find('Customer'), Customer))
pd.DataFrame(result).to_csv('/usr/config/data/gendata/Batch1/CustomerMgmtParsed.csv', index=False)