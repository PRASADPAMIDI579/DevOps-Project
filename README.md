# DevOps-Project

## sed editor
``bash

# sed with -i edit the file
# sed without -i will print the change on output

# -e is for multiple conditions in sed command
# -e cond1 -e cond2


# search and repalce / substitute
sed -i -e 's/root/ROOT/g' 's/admin/ADMIN/g' sample.txt

# Delete lines
sed -i -e '1d' -e '/root/ d' sample.txt

# add Lines
sed -i -e '1 i Hello world' sample.txt
sed -i -e '/root/ i Hello wolrd' sample.txt
sed -i -e '1 a Hello world' sample.txt
sed -i -e '1 c Hello Universe' sample.txt  