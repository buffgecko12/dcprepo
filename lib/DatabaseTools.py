import psycopg2
import subprocess
import os

def OpenDBConnection(user, password, database, server = "localhost"):
    conn = psycopg2.connect(host=server, dbname=database, user=user, password=password)
    return conn

def RunSQLFile(server, user, password, database, encoding, source_file, output_file, display_msg, wait_flag):

    # Copy default environment variable
    my_env = os.environ

    # Set password environment variable (if provided)
    if(password):
        my_env["PGPASSWORD"] = password

    # Set client encoding (if provided)
    if(encoding):
        my_env["PGCLIENTENCODING"] = encoding

    # Print message to screen (if provided)
    if(display_msg):
        print (display_msg)

    # Execute file
    process = ExecuteProcess('psql -L ' + output_file + ' -f ' + source_file + ' ' + database + ' ' + user, wait_flag, my_env)

    print("")
    return process

def ExecuteProcess(cmd, wait_flag, my_env = None, my_cwd = None):
    # Open new process
    process = subprocess.Popen(cmd, env=my_env, cwd=my_cwd)
    
    # Wait for process to complete (if specified)
    if(wait_flag):
        process.wait()

    return process

def RunSQLFileWithConnection(conn, source_file, output_file):
#    conn.set_isolation_level(psycopg2.extensions.ISOLATION_LEVEL_AUTOCOMMIT)
    cursor = conn.cursor()

    sqlfile = open(source_file, 'r')
    cursor.execute(sqlfile.read())

    cursor.close()