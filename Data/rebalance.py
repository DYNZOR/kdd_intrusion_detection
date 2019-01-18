import pandas as pd
import numpy as np 

## Column names 
names = ['duration','protocol','service','flag','src_bytes','dst_bytes','land','wrng_frags','urgent','hot','failed_logins','logged_in','num_compromised','root_shell',
         'su_attempt','num_root','file_creations','num_shells','num_access_files','num_out_cmds','is_host_login','is_guest_login','count','srv_count','serror_rate','srv_serror_rate','rerror_rate','srv_rerror_rate','same_srv_rate',
         'diff_srv_rate','srv_diff_host_rate','dst_host_count','dst_host_srv_count','dst_host_same_srv_rate','dst_host_diff_srv_rate','dst_host_same_src_port_rate','dst_host_srv_diff_host_rate','dst_host_serror_rate',
         'dst_host_srv_serror_rate','dst_host_rerror_rate','dst_host_srv_rerror_rate','attack_name']

## Read data from .dat file and insert header row
data = pd.read_table("kddcup_full.data", sep=',', header=None, names=names)
print('KDD Dataset imported...\n')
print('Dataframe header\n')
print(data.head())
print("Dataframe shape: ", data.shape)

## Import 


data = data.loc[data['attack_name'].isin(['buffer_overflow.','ftp_write.','guess_passwd.',
                                        'imap.','loadmodule.','multihop.','nmap.','perl.',
                                        'phf.','rootkit.','spy.','warezclient.','warezmaster.'])]
## EXCLUDE PROBE ATTACKS FOR NOW'ipsweep.','portsweep.','satan.'
print("Dataframe shape after selection: ", data.shape)

## Obtain sample numbers 
##print(data.groupby('attack_name').count())


# Create a Pandas Excel writer using XlsxWriter as the engine.
writer = pd.ExcelWriter('Extra_Samples.xlsx', engine='xlsxwriter')

# Convert the dataframe to an XlsxWriter Excel object.
data.to_excel(writer, sheet_name='Sheet1')

# Close the Pandas Excel writer and output the Excel file.
writer.save()

