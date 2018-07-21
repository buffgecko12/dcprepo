# Import modules
from FileDirectoryTools import *
from FileReadWrite import *
from DatabaseTools import *
from MiscTools import *
import os

# Read in parameters from config file
params = config("database.ini","postgresql")

SRC_DIR = params["src_dir"]
TGT_DIR = params["tgt_dir"]

SERVER_NAME = params["server_name"]
CHAR_SET = params["char_set"]

DB_ADMIN_USER = params["db_admin_user"]
DB_ADMIN_PASSWORD = params["db_admin_password"]
DB_ADMIN_DATABASE = params["db_admin_database"]

DB_APP_USER = params["db_app_user"]
DB_APP_PASSWORD = str(params["db_app_password"])
DB_APP_DATABASE = str(params["db_app_database"])
DB_APP_SCHEMA = str(params["db_app_schema"])

DB_CHECK_VALUE = params["db_check_value"]

DJANGO_BASEDIR = str(params.get('django_basedir'))
DJANGO_LIB = DJANGO_BASEDIR + "\lib"

# Heroku Only: Use DB Admin user as the App user
DB_APP_USER = DB_ADMIN_USER
DB_APP_PASSWORD = DB_ADMIN_PASSWORD
DB_APP_DATABASE = DB_ADMIN_DATABASE

print("")

# Check if src directory exists and has files
if(os.listdir(SRC_DIR)):
    
    # Cleanup and prepare for install
    if(FileExists(TGT_DIR)):
        print("### Cleaning up old install files")
        DeleteDirectoryContents(TGT_DIR)
        print("")
    
    # Create new target directory
    print("### Creating new install files")
    CreateDirectory(TGT_DIR)
    CreateDirectory(JoinPath(TGT_DIR,"logs"))
    
    # Create placeholder/build value dictionary
    replace_dict = {
#         "$DB_NAME$" : DB_APP_DATABASE,
        "$DB_NAME$" : DB_APP_SCHEMA, # Replace this with "SCHEMA_NAME" parameter
        "$DB_APP_USER$" : DB_APP_USER,
        "$DB_APP_PASSWORD$" : DB_APP_PASSWORD,
        "$DB_APP_DATABASE$" : DB_APP_DATABASE,
        "$DB_CHECK_VALUE$" : DB_CHECK_VALUE
    }

    # Prepare and copy install files
    # Loop through each source sub-directory
    for (src_dir_path, src_dir_names, src_file_names) in os.walk(SRC_DIR):

        # Cut out top-level directory (SRC_DIR)
        new_tgt_dir_path = JoinPath(TGT_DIR, src_dir_path[len(SRC_DIR):])

        # Create sub-directories in current directory
        for sub_dir in src_dir_names:       
            CreateDirectory(JoinPath(new_tgt_dir_path, sub_dir))

        # Loop through all files in current sub-directory
        for src_file in src_file_names:
                        
            # Get source file info
            src_file_path = JoinPath(src_dir_path, src_file)
            src_file_fh = FileOpenForRead(src_file_path)
            
            # Set target file info
            tgt_file_path = JoinPath(new_tgt_dir_path, src_file)
            tgt_file = ""

            print("Copying file: \"" + tgt_file_path + "\" ...", end="")
            
            # Loop through source file
            while(src_file_fh):
                # Read in next line
                my_line = FileReadOneLine(src_file_fh)
    
                # End once no more lines
                if(not my_line):
                    break
    
                # Substitute placeholders with build parameter values            
                for (replace_value, with_value) in replace_dict.items():
                    my_line = my_line.replace(replace_value, with_value)
                
                # Append current line to working target file
                tgt_file += my_line
    
            # Close source file
            FileClose(src_file_fh)
    
            # Write new file to target directory
            FileWrite(tgt_file_path, tgt_file)
            
            print("SUCCESS")
    print("")
else:
    print("No source files found or no access to source directory.")

# Create list of DB install files
install_files = [
#   (file_name, comment, db_user, db_password, db_logon_database),
    ("cleanup.sql", "Cleaning up old DB objects", DB_ADMIN_USER, DB_ADMIN_PASSWORD, DB_ADMIN_DATABASE),
    ("create_users.sql", "Creating new users", DB_ADMIN_USER, DB_ADMIN_PASSWORD, DB_ADMIN_DATABASE),
    ("create_databases.sql", "Creating new DBs and schemas", DB_APP_USER, DB_APP_PASSWORD, DB_ADMIN_DATABASE),
    ("create_tables.sql", "Creating tables", DB_APP_USER, DB_APP_PASSWORD, DB_APP_DATABASE),
    ("create_views.sql", "Creating views", DB_APP_USER, DB_APP_PASSWORD, DB_APP_DATABASE),
    ("create_sps.sql", "Creating SPs", DB_APP_USER, DB_APP_PASSWORD, DB_APP_DATABASE),
#    ("create_triggers.sql", "Creating Triggers", DB_APP_USER, DB_APP_PASSWORD, DB_APP_DATABASE),
#    ("create_indexes.sql", "Creating Indexes", DB_APP_USER, DB_APP_PASSWORD, DB_APP_DATABASE),
    ("load_initial_data.sql", "Loading initial data", DB_APP_USER, DB_APP_PASSWORD, DB_APP_DATABASE),
#     ("load_sample_data.sql", "Creating some sample data", DB_APP_USER, DB_APP_PASSWORD, DB_APP_DATABASE),
    ("run_tests.sql", "Running tests", DB_APP_USER, DB_APP_PASSWORD, DB_APP_DATABASE),
]

# Loop through and execute install files
for install_file in install_files:
    myfile = install_file[0]
    mycomment = install_file[1]
    myuser = install_file[2]
    mypass = install_file[3]
    mydb = install_file[4]

    # Run install file    
    RunSQLFile(SERVER_NAME, myuser, mypass, mydb, CHAR_SET, JoinPath(TGT_DIR, myfile), JoinPath(TGT_DIR, 'logs/' + myfile + '.log'), '### ' + mycomment, True)

# Run django config
if(DJANGO_BASEDIR and FileExists(DJANGO_BASEDIR)):
    print("### Configuring Django")
    env_dict = dict(os.environ)
    env_dict["PYTHONPATH"] = DJANGO_LIB

    ExecuteProcess('python "' + JoinPath(DJANGO_BASEDIR,'manage.py"') + ' migrate', 'Y', my_env = env_dict)
    ExecuteProcess('python "' + JoinPath(DJANGO_BASEDIR,'manage.py"') + ' shell -c "' + \
            'from django.contrib.auth import get_user_model; ' + \
            'from test import load_initial_data; ' + \
            'load_initial_data.load_all(); ' + \
            '"'
         , 'Y', my_env = env_dict)
    print("")

# Verify install completed successfully
print("Verifying install ...", end="")

# Open cursor and query sample table
conn = OpenDBConnection(database=DB_APP_DATABASE, user=DB_APP_USER, password=DB_APP_PASSWORD, server=SERVER_NAME, sslmode='require')
cursor = conn.cursor()
cursor.execute("SELECT * FROM " + DB_APP_SCHEMA + "Views.t1") # To-Do: Fix this
 
mydata = cursor.fetchone() # returns next row in resultset
cursor.close()

# Verify sample value was INSERTed
if(mydata[0].strip() == DB_CHECK_VALUE.strip()):
    print("SUCCESS. " + mydata[0])
else:
    print("FAIL")