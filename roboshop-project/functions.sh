#!/bin/bash

# a set of data to a name is called as variable
# a set of commands to a name is called as function

## Declare a function
SAMPLE() {

a=20
b=20
echo "WELCOME TO DevOps Ttaining"
echo "WELCOME TO DevOps Ttaining"
return
echo "WELCOME TO DevOps Ttaining"
echo "WELCOME TO DevOps Ttaining"

}


## main progarm
## call the function
a=10
SAMPLE
SAMPLE
b=10

SAMPLE1() {
    echo Firsr Argument in main Function = $1  
}

echo First Argument in main progarm = $1
SAMPLE1

# 1. when you declare a variable in program, then function cannot access it and modify it
# 2. when you declare a variable in function, then you can overwrite it in main program
# 3. function will not access special variable inputs to given to script, only main program can access them, maeaning special varibles for inputs are different for function from main program
# 4. Cases we need to come back immediately from function to main program then in that case we use return command. return command is like exit command, 
#    where exit exists the script where as return with exits the function