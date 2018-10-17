# cs236_testbench
This is a script that will help test CS projects with multiple files. Kinda similar to passing off with a TA
To use the script, download and extract the zip file into your folder containging your executable (usually where your code is)

run the command, and replace lab2 with what ever your executalbe is named.

./testbench ./lab2


## Options:
| Flag | Extended Flag  | Explanation                        | Requirements |
|------|-------------------|------------------------------------|--------------------------------------------------------------------------------|
| -c   | --compile         |  Compile before you run test cases |   Your *.ccp files are in your current dir                                     |
| -m   | --memcheck        |  Test for memory leaks/errors      |   You have valgrind installed                                                  |
| -x   | --test-complexity |  Test program complexity.          |   You have pmccabe installed. (Uses the Modified McCabe Cyclomatic Complexity) |


Example with options:

`./testbench.sh ./lab2 -c -m -x`

(compile program, test complexity, test for memory leaks, and the usual test files)
