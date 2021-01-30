import os

# Delete directory and its contents
def DeleteDirectoryContents(path, outputflag=False):
    for root, dirs, files in os.walk(path, topdown=False):
        # Delete files first
        for name in files:
            DeleteFile(os.path.join(root, name), outputflag=outputflag)

        # Delete empty sub-directories
        for name in dirs:
            DeleteDirectory(os.path.join(root, name), outputflag=outputflag)

    # Delete top-level directory
    DeleteDirectory(path, outputflag=outputflag)
        
# Delete a directory
def DeleteDirectory(path, outputflag=False):
    print("Deleting directory: \"" + path + "\" ...", end="") if outputflag else ()
    os.rmdir(path)
    print("SUCCESS") if outputflag else ()

# Delete a file    
def DeleteFile(path, outputflag=False):
    print("Deleting file: \"" + path + "\" ...", end="") if outputflag else ()
    os.remove(path)
    print("SUCCESS") if outputflag else ()

# Create a directory
def CreateDirectory(path, outputflag=False):
    print("Creating new directory: \"" + path + "\" ...", end="") if outputflag else ()
    os.mkdir(path)
    print("SUCCESS") if outputflag else ()

def JoinPath(root, filename):
    return os.path.join(root, filename)
