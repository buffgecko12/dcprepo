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
DB_ADMIN_USER = params["db_admin_user"]
DB_ADMIN_DATABASE = params["db_admin_database"]

DB_NAME = str(params["db_name"])
DB_USER = params["db_user"]
DB_PASS = str(params["db_pass"])
DB_CHECK_VALUE = params["db_check_value"]

DJANGO_BASEDIR = str(params.get('django_basedir'))
DJANGO_LIB = DJANGO_BASEDIR + "\lib"

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
        "$DB_NAME$" : DB_NAME,
        "$DB_USER$" : DB_USER,
        "$DB_PASS$" : DB_PASS,
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
    ("cleanup.sql", "Cleaning up old DB objects", DB_ADMIN_USER, None, DB_ADMIN_DATABASE),
    ("create_users.sql", "Creating new users", DB_ADMIN_USER, None, DB_ADMIN_DATABASE),
    ("create_databases.sql", "Creating new DBs and schemas", DB_USER, DB_PASS, DB_ADMIN_DATABASE),
    ("create_tables.sql", "Creating tables", DB_USER, DB_PASS, DB_NAME),
    ("create_views.sql", "Creating views", DB_USER, DB_PASS, DB_NAME),
    ("create_sps.sql", "Creating SPs", DB_USER, DB_PASS, DB_NAME),
#    ("create_triggers.sql", "Creating Triggers", DB_USER, DB_PASS, DB_NAME),
#    ("create_indexes.sql", "Creating Indexes", DB_USER, DB_PASS, DB_NAME),
    ("sample_data.sql", "Creating some sample data", DB_USER, DB_PASS, DB_NAME),
]

# Loop through and execute install files
for install_file in install_files:
    myfile = install_file[0]
    mycomment = install_file[1]
    myuser = install_file[2]
    mypass = install_file[3]
    mydb = install_file[4]

    # Do some steps before creating sample data
    if(mycomment == "Creating some sample data"):
        if(DJANGO_BASEDIR and FileExists(DJANGO_BASEDIR)):
            print("### Configuring Django")
            env_dict = dict(os.environ)
            env_dict["PYTHONPATH"] = DJANGO_LIB
        
            ExecuteProcess('python "' + JoinPath(DJANGO_BASEDIR,'manage.py"') + ' migrate', 'Y', my_env = env_dict)
            ExecuteProcess('python "' + JoinPath(DJANGO_BASEDIR,'manage.py"') + ' shell -c "' + \
                                             'from django.contrib.auth import get_user_model; ' + \
                                             'get_user_model().objects.create_user(\'adminadmin\',\'S\',\'Chris\',\'Khosravi\',\'123 123 1234\',\'joe@smith.com\'); ' + \
                                             'get_user_model().objects.create_user(\'adminadmin\',\'A\',\'Mark\',\'David\',\'56 9 3130 1966\',\'mark@david.com\'); ' + \
                                             'get_user_model().objects.create_user(\'adminadmin\',\'U\',\'Joe\',\'Smith\',\'+56 9 3120 3495\',\'thereal@joesmith.com\'); ' + \
                                             
                                             'get_user_model().objects.create_user(\'adminadmin\',\'U\',\'Cristiano\',\'Ronaldo\',\'+56 9 619 2843\',\'elmejor@delmundo.com\'); ' + \
                                             'get_user_model().objects.create_user(\'adminadmin\',\'U\',\'Beauden\',\'Barrett\',\'+23 643 2345 44\',\'therugbyking@allblacks.com\'); ' + \
                                             'get_user_model().objects.create_user(\'adminadmin\',\'U\',\'Nelson\',\'Mandela\',\'+56 9 2342 6434\',\'madiba@springboks.com\'); ' + \
                                             '"'
                                             , 'Y', my_env = env_dict)
            print("")

    # Run install file    
    RunSQLFile(SERVER_NAME, myuser, mypass, mydb, JoinPath(TGT_DIR, myfile), JoinPath(TGT_DIR, 'logs/' + myfile + '.log'), '### ' + mycomment, True)

# Verify install completed successfully
print("Verifying install ...", end="")

# Open cursor and query sample table
conn = OpenDBConnection(database=DB_NAME, user=DB_USER, password=DB_PASS)
cursor = conn.cursor()
cursor.execute("SELECT * FROM " + DB_NAME + "views.t1")
 
mydata = cursor.fetchone() # returns next row in resultset
cursor.close()

# Verify sample value was INSERTed
if(mydata[0].strip() == DB_CHECK_VALUE.strip()):
    print("SUCCESS. " + mydata[0])
else:
    print("FAIL")