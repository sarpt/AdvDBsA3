import re
import tkFileDialog
import Tkinter

srcfile = None
tgtfile = None
newfile = None

# closes opened files if they are set and not closed already
def closeFiles():
    if srcfile != None and not srcfile.closed: srcfile.close()
    if tgtfile != None and not tgtfile.closed: tgtfile.close()
    if newfile != None and not newfile.closed: newfile.close()

# gets columns from first possible insert (hopefully number of columns doesn't change depending on insert statement ...)
def getColumns(f):
    for line in f:
        col_start = line.find("(") + 1;
        col_end = line.find(")");
        if (col_start != -1 and col_end != -1):
            return "".join(line[col_start:col_end].split()).split(",")
    
    return ""

# gets values from a line
def getValues(line):
    col_start = line.rfind("(") + 1;
    col_end = line.rfind(")");
    if (col_start != -1 and col_end != -1):
        return "".join(line[col_start:col_end].split()).split(","), line[0:col_start], line[col_end:]
    else:
        return ""

# hide main Tk window
root = Tkinter.Tk()
root.withdraw()

print "Choose the file to repair keys:"
raw_input("Press enter to continue ...")

srcfile_path = tkFileDialog.askopenfilename()
try:
    srcfile = open(srcfile_path,"r")
except:
    print "No file/Wrong file; terminating"
    exit()

# get columns in src file
srcfile_columns = getColumns(srcfile)

if len(srcfile_columns) == 0:
    print "The file doesn't contain proper SQL Insert methods (no proper brackets found); terminating"
    closeFiles()
    exit()

# select primary_key column
print "Select which column is PrimaryKey:"

for idx, column in enumerate(srcfile_columns):
    print idx, ":", column

result = raw_input("(default: " + srcfile_columns[0] + ") >")

if result == "":
    primarykey_column = 0
elif result.isdigit() and int(result) > 0 and int(result) < len(srcfile_columns):
    primarykey_column = int(result)
else:
    print "Passed number is not correct; terminating"
    closeFiles()
    exit()

print "Primary key column is:", srcfile_columns[primarykey_column]

# ask if there're foreign keys
result = raw_input("Are there any Foreign Keys?\n(Y/n) >")

if result == "" or result == "Y" or result == "y":
    tgtfile_read = True
else:
    tgtfile_read = False

if tgtfile_read:
    print "Choose the supplier of primary keys:"
    raw_input("Press enter to continue ...")

    # tgt file
    tgtfile_path = tkFileDialog.askopenfilename()
    tgtfile = open(tgtfile_path,"r")

    # get columns in tgt file
    tgtfile_columns = getColumns(tgtfile)

    if len(tgtfile_columns) == 0:
        print "The file doesn't contain proper SQL Insert methods (no proper brackets found); terminating"
        closeFiles()
        exit()

    # ask for primary key paired to foreign key

# ask for generation of new primary keys
result = raw_input("Generate new Primary Keys for the table?\n (Y/n) >")

# ask for the new filename
result = raw_input("Filename to export modified insert statements:\n (default: _new_) >")

# save the new filename

closeFiles()