import os

# Check if a file or directory exists
def FileExists(file_path):
    exists = os.path.exists(file_path)
    return exists

# Read in a complete file from path and return output as string
def FileRead(file_path):
    if not FileExists(file_path):
        print ("The file '" + file_path + "' does not exist -- can't read.")
        return ""
    
    fileHandle = open(file_path,'r')
    myfile = file.read(fileHandle)
    fileHandle.close()
    return myfile

# Write text to a file
def FileWrite(file_path, outputText):
    fileHandle = open(file_path,'w')
    fileHandle.write(outputText)
    fileHandle.close()

# Open a file to write
def FileOpenForWrite(file_path):
    file_handle = open(file_path,'w')
    return file_handle

# Open a file to read
def FileOpenForRead(file_path):
    if(not FileExists(file_path)):
        print("File " + file_path + " does not exist or can't be accessed.")
        return ""
    
    file_handle = open(file_path,'r')
    return file_handle

# Write one line to a file
def FileWriteOneLine(file_handle, line_to_write):
    file_handle.write(line_to_write + '\n')

# Read one line from a file
def FileReadOneLine(file_handle):
    my_line = file_handle.readline()
    
    # If no more lines, return False (not a string)
    if not my_line: 
        return False
    
    # If line ends with newline character, strip it off
    if my_line.endswith('\n'):
        my_line.rstrip('\n')

    return my_line

# Close a file using file handle
def FileClose(file_handle):
    file_handle.close()

if __name__ == '__main__':
    print(FileRead('src/Test_SP.spl'))