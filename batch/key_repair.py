import re
from tkinter import filedialog, Tk

srcfile = None
tgtfile = None
newfile = None

# check if proper insert statement
def sqlInsertCheck(line):
    if re.match(r"INSERT\s+INTO\s+\w+\s*\(.*\)\s+VALUES\s*\(.*\);", line, re.IGNORECASE) != None:
        return True
    else:
        return False

# closes opened files if they are set and not closed already
def closeFiles():
    if srcfile != None and not srcfile.closed: srcfile.close()
    if tgtfile != None and not tgtfile.closed: tgtfile.close()
    if newfile != None and not newfile.closed: newfile.close()

# finds columns
def findColumns(f):
    for line in f:
        try:
            return getColumns(line)
        except:
            continue
    
    raise ValueError("File doesn't contain insert statements'")
        

# gets columns from first possible insert (hopefully number of columns doesn't change depending on insert statement ...)
def getColumns(statement):
    if sqlInsertCheck(statement):    
        col_start = statement.find("(") + 1;
        col_end = statement.find(")");
        return "".join(statement[col_start:col_end].split()).split(",")
    else:  
        raise ValueError("No proper SQL Insert methods found in the entire file (no proper brackets found)")

# gets values from a line
def getValues(statement):
    if sqlInsertCheck(statement):
        col_start = line.rfind("(") + 1;
        col_end = line.rfind(")");
        return "".join(line[col_start:col_end].split()).split(","), line[0:col_start], line[col_end:]
    else:
        raise ValueError("The line doesn't contain proper SQL Insert statement (no proper brackets found)")

# ask user 
def userInput(msg, options, default):
    result = input(msg)

# EXEC #

# hide main Tk window
root = Tk()
root.withdraw()

input("Choose the file to repair keys:\nPress enter to continue ...")

srcfile_path = filedialog.askopenfilename()
srcfile_name = "".join(srcfile_path).rsplit("/")[-1]

try:
    srcfile = open(srcfile_path,"r")
except:
    print("No file/Wrong file; terminating")
    exit()

# get columns in src file
try:
    srcfile_columns = findColumns(srcfile)
except ValueError as err:
    print(err.args[0])
    closeFiles()
    exit()

# select primary_key column
print("Select which column is PrimaryKey:")

for idx, column in enumerate(srcfile_columns):
    print(idx, ":", column)

result = input("(default: " + srcfile_columns[0] + ") >")

if result == "":
    srcpk_column = 0
elif result.isdigit() and int(result) > 0 and int(result) < len(srcfile_columns):
    srcpk_column = int(result)
else:
    print("Passed number is not correct; terminating")
    closeFiles()
    exit()

print("Primary key column is:", srcfile_columns[srcpk_column])

# ask if there're foreign keys
result = input("Are there any Foreign Keys?\n(Y/n) >")

if result == "" or result == "Y" or result == "y":
    tgtfile_read = True
else:
    tgtfile_read = False

if tgtfile_read:

    # ask for foreign key column
    srcfk_column = 0
    print("Select which column is ForeignKey:")

    for idx, column in enumerate(srcfile_columns):
        print(idx, ":", column)

    result = input("(default: " + srcfile_columns[srcfk_column] + ") >")

    if result == "":
        srcfk_column = 0
    elif result.isdigit() and int(result) > 0 and int(result) < len(srcfile_columns):
        srcfk_column = int(result)
    else:
        print("Passed number is not correct; terminating")
        closeFiles()
        exit()

    input("Choose the supplier file of primary keys:\nPress enter to continue ...")

    # tgt file
    tgtfile_path = filedialog.askopenfilename()
    tgtfile = open(tgtfile_path,"r")

    # get columns in tgt file
    try:
        tgtfile_columns = findColumns(tgtfile)
    except ValueError as err:
        print(err.args[0])
        closeFiles()
        exit()

    tgtpk_column = 0
    # ask for primary key paired to foreign key
    for idx, column in enumerate(tgtfile_columns):
        if column == srcfile_columns[srcfk_column]:
            tgtpk_column = idx

    print("Select which column foreign_key is bound to:")
    result = input("(default: " + tgtfile_columns[tgtpk_column] + ") >")

    if result == "":
        tgtpk_column = 0
    elif result.isdigit() and int(result) > 0 and int(result) < len(srcfile_columns):
        tgtpk_column = int(result)
    else:
        print("Passed number is not correct; terminating")
        closeFiles()
        exit()

    # build tuple of possible primary keys

# ask for generation of new primary keys
result = input("Generate new Primary Keys for the table?\n (Y/n) >")

if result == "" or result == "Y" or result == "y":
    srcfile_generateid = True
else:
    srcfile_generateid = False

# ask for the new filename
result = input("Filename to export modified insert statements:\n (default: _new_" + srcfile_name + ") >")

if result == "":
    newfile_path = "".join(srcfile_path).rsplit("/", 1)[0] + "/_new_" + srcfile_name
else:
    newfile_path = "".join(srcfile_path).rsplit("/", 1)[0] + "/" + result

# try to open new file for writing
print("Saving file to " + newfile_path)

try:
    newfile = open(newfile_path, "w")
except Exception as err:
    print(err.args[0])
    closeFiles()
    exit()

# save the new filename


# cleanup and terminate
closeFiles()
exit()