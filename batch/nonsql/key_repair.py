import re
import os 
import random
import argparse
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
    f.seek(0)
    for line in f:
        try:
            return getColumns(line)
        except:
            continue
    
    raise ValueError("File doesn't contain insert statements'")
        
# find values in file with statements
# col defines if only specific column of values has to be returned, default -1 meaning all values should be returned
def findValues(f, col=-1):
    allvalues = []
    f.seek(0)
    for line in f:
        try:
            if col != -1:
                allvalues.append(getValues(line)[col])
            else:
                allvalues.append(getValues(line))
        except:
            continue
    
    if len(allvalues) > 0:
        return allvalues
    else:
        raise ValueError("No proper values found in file; File may be wrong")

def getTableName(statement):
    if sqlInsertCheck(statement):
        return re.search("INSERT\s+INTO\s+(\w+)", statement, re.IGNORECASE).group(1)
    else:
        raise ValueError("The line doesn't contain proper SQL Insert statement (no proper brackets found)")

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
        statement_values = re.search(r"(VALUES\s*\(.*\);)", statement, re.IGNORECASE).group(0)
        col_start = statement_values.find("(") + 1;
        col_end = statement_values.rfind(")");
        return "".join(statement_values[col_start:col_end].split()).split(",")
    else:
        raise ValueError("The line doesn't contain proper SQL Insert statement (no proper brackets found)")

# cleans up
def cleanup(msg=""):
    if msg != "":
        print(msg)
    closeFiles()
    exit()

# ask user 
# def userInput(msg, options, default):
#    result = input(msg)

# EXEC #

dir_path = os.path.dirname(os.path.realpath(__file__))

parser = argparse.ArgumentParser()
parser.add_argument("--main_file")
parser.add_argument("--main_file_pk_col", type=str)
parser.add_argument("--main_file_no_fk", action="store_true")
parser.add_argument("--main_file_fk_col", type=str)
parser.add_argument("--main_file_pk_generate", action="store_true")
parser.add_argument("--main_file_pk_ignore", action="store_true")
parser.add_argument("--foreign_file")
parser.add_argument("--foreign_file_pk_col", type=str)
parser.add_argument("--new_file")
parser.add_argument("--new_file_default_name", action="store_true")
arguments = parser.parse_args()

# hide main Tk window
root = Tk()
root.withdraw()

if (arguments.main_file):
    srcfile_path = dir_path + "/" + arguments.main_file
else:
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
    cleanup(err.args[0])

# select primary_key column
if (arguments.main_file_pk_col):
    result = arguments.main_file_pk_col
else:
    print("Select which column is PrimaryKey:")

    for idx, column in enumerate(srcfile_columns):
        print(idx, ":", column)

    result = input("(default: " + srcfile_columns[0] + ") >")

if result == "":
    srcpk_column = 0
elif result.isdigit() and int(result) >= 0 and int(result) < len(srcfile_columns):
    srcpk_column = int(result)
else:
    cleanup("Passed number is not correct; terminating")


print("Primary key column is:", srcfile_columns[srcpk_column])

# ask if there're foreign keys
if (arguments.main_file_fk_col):
    tgtfile_read = True
else:
    if (arguments.main_file_no_fk):
        result = "n"
    else:
        result = input("Are there any Foreign Keys?\n(Y/n) >")

    if result == "" or result == "Y" or result == "y":
        tgtfile_read = True
    else:
        tgtfile_read = False

if tgtfile_read:

    # ask for foreign key column
    srcfk_column = 0

    if (arguments.main_file_fk_col):
        result = arguments.main_file_fk_col
    else:
        print("Select which column is ForeignKey:")

        for idx, column in enumerate(srcfile_columns):
            print(idx, ":", column)

        result = input("(default: " + srcfile_columns[srcfk_column] + ") >")

    if result == "":
        srcfk_column = 0
    elif result.isdigit() and int(result) >= 0 and int(result) < len(srcfile_columns):
        srcfk_column = int(result)
    else:
        cleanup("Passed number is not correct; terminating")


    if (arguments.foreign_file):
        tgtfile_path = dir_path + "/" + arguments.foreign_file
    else:
        input("Choose the supplier file of primary keys:\nPress enter to continue ...")

        # tgt file
        tgtfile_path = filedialog.askopenfilename()

    tgtfile = open(tgtfile_path,"r")

    # get columns in tgt file
    try:
        tgtfile_columns = findColumns(tgtfile)
    except ValueError as err:
        cleanup(err.args[0])

    tgtpk_column = 0
    # ask for primary key paired to foreign key

    if (arguments.foreign_file_pk_col):
        result = arguments.foreign_file_pk_col
    else:
        print("Select which column foreign_key is bound to:")

        for idx, column in enumerate(tgtfile_columns):
            if column == srcfile_columns[srcfk_column]:
                tgtpk_column = idx

        
        result = input("(default: " + tgtfile_columns[tgtpk_column] + ") >")

    if result == "":
        tgtpk_column = 0
    elif result.isdigit() and int(result) >= 0 and int(result) < len(srcfile_columns):
        tgtpk_column = int(result)
    else:
        cleanup("Passed number is not correct; terminating")

    # build tuple of possible primary keys for random function to iterate
    tgtfile_pks = findValues(tgtfile, tgtpk_column)

# ask for generation of new primary keys
if (arguments.main_file_pk_generate):
    result = "y"
elif (arguments.main_file_pk_ignore):
    result = "n"
else:
    result = input("Generate new Primary Keys for the table?\n (Y/n) >")

if result == "" or result == "Y" or result == "y":
    srcfile_generateid = True
else:
    srcfile_generateid = False

# ask for the new filename
if (arguments.new_file):
    result = dir_path + "/" + arguments.new_file
else:
    if (arguments.new_file_default_name):
        result = ""
    else:
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
    cleanup(err.args[0])

# save the new filename

srcfile.seek(0)
offset = 0
for pkvalue, line in enumerate(srcfile):
    if (sqlInsertCheck(line)):
        line_values = getValues(line)
        if srcfile_generateid: line_values[srcpk_column] = pkvalue + 1 - offset
        if tgtfile_read: line_values[srcfk_column] = random.choice(tgtfile_pks)
        newfile.write("INSERT INTO " + getTableName(line) + " (" + ", ".join(list(map(str, srcfile_columns))) +") VALUES (" + ", ".join(list(map(str, line_values))) + ");\n")
    else:
        newfile.write(line)
        offset = offset + 1

# cleanup and terminate
cleanup()