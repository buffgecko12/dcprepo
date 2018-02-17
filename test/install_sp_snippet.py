'''
# Build SP/function install file
sp_install_file = ""

# Loop through SP/function src directory
for(dir, subdir_names, file_names) in os.walk(JoinPath(TGT_DIR, "sps")):
    for myfile in file_names:
        sp_install_file += "\i " + JoinPath(dir, myfile).replace("\\","/") + "\n" # Convert all slashes to Unix-style for PG

# Write install file with sp file list
FileWrite(JoinPath(TGT_DIR, "create_sps.sql"), sp_install_file)
'''