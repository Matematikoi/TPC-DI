import os
import pandas as pd

folder_path = '/usr/config/data/gendata/Batch1'
output_file = 'output_audit.csv'

files = [file for file in os.listdir(folder_path) if "audit" in file]

combined_data = pd.DataFrame()

for file in files:
    file_path = os.path.join(folder_path, file)
    
    data = pd.read_csv(file_path, skiprows=1, header=None, names=['DataSet', 'BatchID', 'Date', 'Attribute', 'Value', 'DValue'])
    combined_data = combined_data.append(data, ignore_index=True)

combined_data.to_csv(output_file, index=False)
