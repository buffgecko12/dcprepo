'''
Build configurations:
  build.py -t install_logic -o
  build.py -t install_schema -o
  build.py -t clean_logic -o
  build.py -t upgrade -u 2.0.0 -o
   -u
   -u asd
   -u 2.0.2
   -u 2.0.1
  build.py -t create_files -o
  build.py -t clean_full -o
  build.py -t install_full -d
'''

# Import modules
import os, sys, getopt
import versioninfo

from lib.FileDirectoryTools import *
from lib.FileReadWrite import *
from lib.DatabaseTools import *
from lib.MiscTools import *

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

VERSION_HISTORY = versioninfo.VERSION_HISTORY
CODE_VERSION = versioninfo.CODE_VERSION

# Specify installation files
INSTALL_FILES = {
#   (file_name, comment, db_user, db_password, db_logon_database),
    'clean_full': ("clean_full.sql", "Removing all database objects and data", DB_ADMIN_USER, DB_ADMIN_PASSWORD, DB_ADMIN_DATABASE),
    'clean_logic': ("clean_logic.sql", "Removing database ""logic"" objects (views, functions, SPs)", DB_ADMIN_USER, DB_ADMIN_PASSWORD, DB_ADMIN_DATABASE),
    'create_users': ("create_users.sql", "Creating new users", DB_ADMIN_USER, DB_ADMIN_PASSWORD, DB_ADMIN_DATABASE),
    'create_databases': ("create_databases.sql", "Creating new DBs and schemas", DB_APP_USER, DB_APP_PASSWORD, DB_ADMIN_DATABASE),
    'create_tables': ("create_tables.sql", "Creating tables", DB_APP_USER, DB_APP_PASSWORD, DB_APP_DATABASE),
    'create_views': ("create_views.sql", "Creating views", DB_APP_USER, DB_APP_PASSWORD, DB_APP_DATABASE),
    'create_sps': ("create_sps.sql", "Creating SPs", DB_APP_USER, DB_APP_PASSWORD, DB_APP_DATABASE),
    'create_udfs': ("create_udfs.sql", "Creating UDFs", DB_APP_USER, DB_APP_PASSWORD, DB_APP_DATABASE),
#     'create_triggers': ("create_triggers.sql", "Creating Triggers", DB_APP_USER, DB_APP_PASSWORD, DB_APP_DATABASE),
#     'create_indexes': ("create_indexes.sql", "Creating Indexes", DB_APP_USER, DB_APP_PASSWORD, DB_APP_DATABASE),
    'load_initial_data': ("load_initial_data.sql", "Loading initial data", DB_APP_USER, DB_APP_PASSWORD, DB_APP_DATABASE),
#     'load_sample_data': ("load_sample_data.sql", "Creating some sample data", DB_APP_USER, DB_APP_PASSWORD, DB_APP_DATABASE),
    'run_tests': ("run_tests.sql", "Running tests", DB_APP_USER, DB_APP_PASSWORD, DB_APP_DATABASE),
}

def main(argv):
    
    installoptions = \
        "\n[install_full] - Clean install, wipes out all data previous data" + \
        "\n[install_logic] - Install views, functions and procedures (no data is modified)" + \
        "\n[install_schema] - Install schemas only (no data is modified)" + \
        "\n[clean_full] - Delete all data and drop schemas" + \
        "\n[clean_logic] - Delete views, functions and procedures (no data is modified)" + \
        "\n[upgrade] - Upgrade existing repository (no data is modified)" + \
        "\n[create_files] - Create install files only (no changes made)"
    
    usage = 'Usage: build.py -t [buildtype] -u [currentversion] -d -o\n\n' + \
            '-t [Build type]: \n' + \
            installoptions.replace("\n","\n   ") + \
            '\n\n-u [Current version] (i.e. 2.0.0)' + \
            '\n-d Skip Django configuration (flag only)' + \
            '\n-o Output flag (flag only)'

    # Initialize build parameters
    buildtype = ''
    upgradefromversion = ''
    skipdjangoconfig = False
    outputflag = False

    print("")
    
    # Read input arguments
    try:
        opts, args = getopt.getopt(argv, "ht:u:do", ["help=","buildtype=","upgradefromversion=","skipdjangoconfig","outputflag"])

    except getopt.GetoptError:
        print (usage, '\n')
        sys.exit(2)
    
    # Parse arguments
    for opt, arg in opts:
        
        # Help (-h)
        if opt in('-h', '--help'):
            print (usage, '\n')
            sys.exit()
            
        # Build type (-t)
        elif opt in ("-t", "--buildtype"):
            buildtype = arg
    
        # Build type (-u)
        elif opt in ("-u", "--upgradefromversion"):
            upgradefromversion = arg
    
        # Skip Django config flag (-d)
        elif opt in ("-d", "--skipdjangoconfig"):
            skipdjangoconfig = True
    
        # Detailed output flag (-o)
        elif opt in ("-o", "--outputflag"):
            outputflag = True
    
    # Check build type parameters
    if buildtype == "upgrade":
        if not upgradefromversion:
            print('Please specify source version using "-u" option:\n')
            print_versions()
            sys.exit(2)

        # CHeck upgrade specifications
        upgrade_setup(upgradefromversion, precheck=True, outputflag=outputflag)

    if buildtype not in ['install_full','install_logic','upgrade','install_schema','clean_full','clean_logic','create_files']:
        print(usage, "\n")
        sys.exit(2)

    # Begin install
    print(('Installing DCP {0} ({1}' + (' from {2}' if buildtype == "upgrade" else '') + ')\n').format(CODE_VERSION, buildtype, upgradefromversion))
    
    # BUILD OPTIONS
    # Install (full)
    if buildtype == "install_full":
        setup(outputflag=outputflag)
        clean_full(outputflag=outputflag)
        install_schema(outputflag=outputflag)
        install_tables(outputflag=outputflag)
        install_logic(outputflag=outputflag)
        load_data(outputflag=outputflag)
        run_tests(outputflag=outputflag)
        configure_django(outputflag=outputflag) if not skipdjangoconfig else ()
        verify(outputflag=outputflag)
        
    # Install (logic only)
    elif buildtype == "install_logic":
        setup(outputflag=outputflag)
        clean_logic(outputflag=outputflag)
        install_logic(outputflag=outputflag)
        verify(outputflag=outputflag)
    
    # Upgrade
    elif buildtype == "upgrade":
        setup(outputflag=outputflag)
        clean_logic(outputflag=outputflag)
        upgrade(upgradefromversion, outputflag=outputflag)
        install_logic(outputflag=outputflag)
        configure_django(upgradefromversion=upgradefromversion, outputflag=outputflag) if not skipdjangoconfig else ()
        verify(outputflag=outputflag)
    
    # Install (schema only)
    elif buildtype == "install_schema":
        setup(outputflag=outputflag)
        install_schema(outputflag=outputflag)
    
    # Clean (full)
    elif buildtype == "clean_full":
        setup(outputflag=outputflag)
        clean_full(outputflag=outputflag)
    
    # Clean (logic only)
    elif buildtype == "clean_logic":
        setup(outputflag=outputflag)
        clean_logic(outputflag=outputflag)
    
    # Create setup files
    elif buildtype == "create_files":
        setup(outputflag=outputflag)

    print("") if not outputflag else ()
    
# Prepare install files
def setup(outputflag=False):

    # Check if src directory exists and has files
    if(os.listdir(SRC_DIR)):
        
        # Cleanup and prepare for install
        if(FileExists(TGT_DIR)):
            print("### Cleaning up old install files")
            DeleteDirectoryContents(TGT_DIR, outputflag=outputflag)
            print("") if outputflag else ()
        
        # Create new target directory
        print("### Creating new install files")
        CreateDirectory(TGT_DIR, outputflag=outputflag)
        CreateDirectory(JoinPath(TGT_DIR,"logs"), outputflag=outputflag)
        
        # Create placeholder/build value dictionary
        replace_dict = {
    #         "$APP_NAME$" : DB_APP_DATABASE,
            "$APP_NAME$" : DB_APP_SCHEMA, # Replace this with "SCHEMA_NAME" parameter
            "$APP_USER$" : DB_APP_USER,
            "$APP_PASSWORD$" : DB_APP_PASSWORD,
            "$APP_DATABASE$" : DB_APP_DATABASE,
            "$DB_CHECK_VALUE$" : DB_CHECK_VALUE
        }
    
        # Prepare and copy install files
        # Loop through each source sub-directory
        for (src_dir_path, src_dir_names, src_file_names) in os.walk(SRC_DIR):
    
            # Cut out top-level directory (SRC_DIR)
            new_tgt_dir_path = JoinPath(TGT_DIR, src_dir_path[len(SRC_DIR):])
    
            # Create sub-directories in current directory
            for sub_dir in src_dir_names:       
                CreateDirectory(JoinPath(new_tgt_dir_path, sub_dir), outputflag=outputflag)
    
            # Loop through all files in current sub-directory
            for src_file in src_file_names:
                            
                # Get source file info
                src_file_path = JoinPath(src_dir_path, src_file)
                src_file_fh = FileOpenForRead(src_file_path)
                
                # Set target file info
                tgt_file_path = JoinPath(new_tgt_dir_path, src_file)
                tgt_file = ""
    
                print("Copying file: \"" + tgt_file_path + "\" ...", end="") if outputflag else ()
                
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
                
                print("SUCCESS") if outputflag else ()
        print("") if outputflag else ()
    else:
        print("No source files found or no access to source directory.")
    
def execute(install_files, outputflag=False):

    # Loop through and execute install files - array of tuples[(file_name, comment, db_user, db_password, db_logon_database)]
    for install_file in install_files:
        myfile = install_file[0]
        mycomment = install_file[1]
        myuser = install_file[2]
        mypass = install_file[3]
        mydb = install_file[4]
    
        # Run install file    
        RunSQLFile(SERVER_NAME, myuser, mypass, mydb, CHAR_SET, JoinPath(TGT_DIR, myfile), JoinPath(TGT_DIR, 'logs/' + os.path.splitext(os.path.split(myfile)[1])[0] + '.log'), '### ' + mycomment, True, outputflag=outputflag)

def clean_full(outputflag=False):
    execute([
        INSTALL_FILES["clean_full"]
    ],
    outputflag=outputflag)

def clean_logic(outputflag=False):
    execute([
        INSTALL_FILES["clean_logic"]
    ],
    outputflag=outputflag)

def install_schema(outputflag=False):
    execute([
        INSTALL_FILES["create_users"],
        INSTALL_FILES["create_databases"]
    ],
    outputflag=outputflag)

def install_tables(outputflag=False):
    execute([
        INSTALL_FILES["create_tables"]
    ],
    outputflag=outputflag)

def install_logic(outputflag=False):
    execute([
        INSTALL_FILES["create_udfs"],
        INSTALL_FILES["create_views"],
        INSTALL_FILES["create_sps"],
#         INSTALL_FILES["create_triggers"],
#         INSTALL_FILES["create_indexes"],
    ],
    outputflag=outputflag)

def upgrade_setup(upgradefromversion, precheck=False, outputflag=False):
    targetversion = VERSION_HISTORY.get(CODE_VERSION)
    sourceversion = VERSION_HISTORY.get(upgradefromversion)

    # Check upgrade options first
    if precheck:
        
        # Check versions are valid
        if not targetversion or not sourceversion:
            print('Invalid', 'source' if not sourceversion else 'target', 'version. Versions:\n')
            print_versions()
            sys.exit(2)
    
        # Verify target version is newer than source version
        if not sourceversion['order'] < targetversion['order']:
            print('Target version ({0}) must be newer than current version ({1}). Versions:\n'.format(targetversion['version'], sourceversion['version']))
            print_versions()
            sys.exit(2)
        
    # Generate list of upgrade versions to run
    upgradeversionslist = []

    for version, versioninfo in VERSION_HISTORY.items():
        if targetversion['order'] >= versioninfo['order'] > sourceversion['order']:
            upgradeversionslist.append(versioninfo)
            
    return {
        'targetversion':targetversion, 
        'sourceversion':sourceversion, 
        'upgradeversionslist':upgradeversionslist
    }

def upgrade(upgradefromversion, precheck=False, outputflag=False):
    upgradeinfo = upgrade_setup(upgradefromversion=upgradefromversion)

    # Generate list of files to run
    filelist = []

    # Generate file list
    for upgradeversion in upgradeinfo.get('upgradeversionslist'):
        filelist.append((
            upgradeversion.get('repoupgradefile'), 
            "Applying v{0} changes".format(upgradeversion.get('version')), 
            DB_APP_USER, 
            DB_APP_PASSWORD, 
            DB_APP_DATABASE
        ))

    execute(filelist, outputflag=outputflag)

def load_data(outputflag=False):
    execute([
        INSTALL_FILES['load_initial_data'],
#         INSTALL_FILES['load_sample_data'],
    ],
    outputflag=outputflag)

def run_tests(outputflag=False):
    execute([
        INSTALL_FILES['run_tests'],
    ],
    outputflag=outputflag)

def configure_django(upgradefromversion=None, outputflag=False):
    
    upgradeinfo = None
    
    # Get version info (upgrade only)
    if upgradefromversion:
        upgradeinfo = upgrade_setup(upgradefromversion=upgradefromversion, outputflag=outputflag)

    # Run django config
    if(DJANGO_BASEDIR and FileExists(DJANGO_BASEDIR)):
        env_dict = dict(os.environ)
        env_dict["PYTHONPATH"] = DJANGO_LIB

        # Ignore for upgrade
        if not upgradefromversion:
            print("### Configuring Django")
            ExecuteProcess('python "' + JoinPath(DJANGO_BASEDIR,'manage.py"') + ' migrate', 'Y', my_env = env_dict, outputflag=outputflag)
    
        print("\n" if outputflag else "", "### Configuring web app", sep="")
        ExecuteProcess('python "' + JoinPath(DJANGO_BASEDIR,'manage.py"') + ' shell -c "' + \
                'import os; ' + \
                'import ' + ('setup;' if not upgradefromversion else 'upgrade;') + \
                'os.chdir(r' + '""' + DJANGO_BASEDIR + '""' + '); ' + \
                ('setup.setup_all(); ' if not upgradefromversion else ' upgrade.upgrade({0});'.format(upgradeinfo)) + \
                '"'
             , 'Y', my_env=env_dict,
             outputflag=outputflag)

def verify(outputflag=False):
    
    # Verify install completed successfully
    print("\nVerifying install ...", end="", sep="")
    
    # Pass correct setting (depends on "ENV" variable)
    if(os.environ.get('ENV') != 'development'):
        sslmode = "require"
    else:
        sslmode = None
     
    # Open cursor and query sample table
    conn = OpenDBConnection(database=DB_APP_DATABASE, user=DB_APP_USER, password=DB_APP_PASSWORD, server=SERVER_NAME, sslmode=sslmode)
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM " + DB_APP_SCHEMA + "Views.t1") # To-Do: Fix this
       
    mydata = cursor.fetchone() # returns next row in resultset
    cursor.close()
      
    # Verify sample value was INSERTed
    if(mydata[0].strip() == DB_CHECK_VALUE.strip()):
        print("SUCCESS. " + mydata[0])
    else:
        print("FAIL")
        
    print("") if outputflag else ()

def print_versions():
    for key, versioninfo in VERSION_HISTORY.items():
        print(versioninfo['version'])

    print()

if __name__ == "__main__":
    main(sys.argv[1:])