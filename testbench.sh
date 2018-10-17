#!/usr/bin/env bash

# Copyright 2018 Benjamin Brenkman
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


# "Black        0;30     Dark Gray     1;30
# Red          0;31     Light Red     1;31
# Green        0;32     Light Green   1;32
# Brown/Orange 0;33     Yellow        1;33
# Blue         0;34     Light Blue    1;34
# Purple       0;35     Light Purple  1;35
# Cyan         0;36     Light Cyan    1;36
# Light Gray   0;37     White         1;37"

RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

inputName=$1

compile=false
memCheck=false
complexityTest=false

while [ $# -gt 0 ];
do
key="$1"

case ${key} in
    -c|--compile)
    compile=true
    shift
    ;;
    -m|--memcheck)
    memCheck=true
    shift
    ;;
    -x|--test-complexity)
    complexityTest=true
    shift
    ;;
    *)
    shift
    ;;
esac
done


echo

# just another way to print a bunch of the same character with printf
# printf '*%.s' {1..85}
# printf '\n'

echo "*************************************************************************************"
echo "*************************************************************************************"
echo
echo "  Disclaimer: This is not an indication if you will pass the passoff with the TA's"
echo "     This script is designed to help minimize testing with multiple test cases"
echo
echo "*************************************************************************************"
echo "*************************************************************************************"

# compile the program using the first argument as the output filename if the compile flag was set
if [ ${compile} = true ]; then
  echo -e "\n  Compiling..."
  rm "$inputName"
  compilation_output=$(g++ -g -Wall -Werror -std=c++17 *.cpp -o "$inputName")

  if [[ $? != 0 ]]; then
    echo -e "  ${RED}COMPILATION ERRORS. Exiting...${NC}";
    exit
  fi

  echo -e "  ${GREEN}Compilation complete.${NC}\n"
fi

# run the complexiy test if the complexity flag was set
if [ ${complexityTest} = true ]; then
  echo -e "  Testing complexity..."
  complexity_output=$(pmccabe *.h *.cpp)

  if [ $? != 0 ]; then
    echo -e "  ${RED}ERROR: could not complete complexity test. Exiting...${NC}";
    echo "${complexity_output}"
    exit
  fi

  errors=$(awk '($1>8)' <<< ${complexity_output})

  if [ -n "${errors}" ]; then
    echo -e "  ${RED}Failed complexity test for the following functions:${NC}";
    echo "${errors}"
    exit
  else
    echo -e "  ${GREEN}Passed complexity test.${NC}"
  fi
fi

echo
echo Starting Testbench on $1

echo

#just some basic setting up if they just copied over th input file
if [ ! -d "diffs" ]; then
  echo Making diffs folder
  mkdir "diffs"
fi
if [ ! -d "input" ]; then
  echo Making input folder
  mkdir "input"
fi
if [ ! -d "output" ]; then
  echo Making output folder
  mkdir "output"
fi


#  also check if their input executable is correct
if [ -f ${inputName%"./"} ]; then
  # Check if there are text cases in the input file
  if [ "$(ls input/)" ]; then

    # Start going through the input files and checking the difference
    failed=false
    for filename in input/*.txt; do

      # check for memory leaks
      if [ ${memCheck} = true ]; then
        valgrindOuput="$(valgrind --leak-check=yes --log-fd=1 --error-exitcode=1 ${inputName} ${filename}) ";
        if [ $? = 1 ]; then
          echo -e "${RED}  ERROR: valgrind detected a memory error. Exiting...\n${NC}"
          echo -e "$valgrindOuput"
          exit
        fi
      fi

      # First check to see if there is a matching output file
      result=$(${inputName} ${filename})

      extra=${filename:8}
      printf "TESTING in"${extra%.txt}": "
      outFile="out"${filename:8}

      if [ ! -f "output/"$outFile ]; then
        echo -e ${YELLOW}"\tneeds input file in output/$outFile"${NC}
      else
        # echo $outFile;
        if [ -f "temp.txt" ]; then
          rm "temp.txt"
        fi
        echo -e "$result" > "temp.txt"
        if diffResults=$(diff --ignore-all-space "temp.txt" "output/"${outFile}); then # added option --ignore-all-space (same as -w)
          if [ "$diffResults" == "" ];then
            echo -e ${GREEN}"\tPASSED"${NC}
          else
            echo -e ${RED}"\tFAILED!"${NC}
            echo "$diffResults"
            rm "results.txt"
            echo -e "$diffResults" > "results.txt"
            failed=true
          fi
        else
          echo -e ${RED}"\tFAILED!"${NC}
          failed=true
          if [ -f "${extra%.txt}""-diff.txt" ]; then
            rm "${extra%.txt}""-diff.txt"
          fi
          echo -e "$diffResults" > "diffs/${extra%.txt}""-diff.txt"
        fi
      fi
    done

    # remove that temp.txt file
    echo
    if [ -f "temp.txt" ]; then
      rm "temp.txt"
    fi

    if [[ "$failed" == "true" ]]; then
      echo "Looks like you had some errors :( Check the diffs/ folder for the results of the diff."
      echo
    else
      echo "Everything looks good :)"
      echo
    fi

  # if there arent input files throw and error
  else
    echo -e ${RED}ERROR: ${NC} "There are no test cases in the input/ folder"
  fi

#  also check if there input executable is correct
else
  echo -e ${BLUE}$1${NC} "does not exist. Make sure this script is in the same folder as your executable"
  echo
fi
