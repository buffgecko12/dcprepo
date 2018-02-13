import os

# Delete directory and its contents
def DeleteDirectoryContents(path):
    for root, dirs, files in os.walk(path, topdown=False):
        # Delete files first
        for name in files:
            DeleteFile(os.path.join(root, name))

        # Delete empty sub-directories
        for name in dirs:
            DeleteDirectory(os.path.join(root, name))

    # Delete top-level directory
    DeleteDirectory(path)
        
# Delete a directory
def DeleteDirectory(path):
    print("Deleting directory: \"" + path + "\" ...", end="")
    os.rmdir(path)
    print("SUCCESS")

# Delete a file    
def DeleteFile(path):
    print("Deleting file: \"" + path + "\" ...", end="")
    os.remove(path)
    print("SUCCESS")

# Create a directory
def CreateDirectory(path):
    print("Creating new directory: \"" + path + "\" ...", end="")
    os.mkdir(path)
    print("SUCCESS")

def JoinPath(root, filename):
    return os.path.join(root, filename)
