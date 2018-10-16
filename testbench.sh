RED='\033[0;31m'
"Black        0;30     Dark Gray     1;30
Red          0;31     Light Red     1;31
Green        0;32     Light Green   1;32
Brown/Orange 0;33     Yellow        1;33
Blue         0;34     Light Blue    1;34
Purple       0;35     Light Purple  1;35
Cyan         0;36     Light Cyan    1;36
Light Gray   0;37     White         1;37"
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color


echo
echo Running tests

echo
echo in0.txt
INPUT00=$(./lab2 in0.txt)
echo -e ${GREEN}$INPUT00${NC}

echo
INPUT01=$(./lab2 in1.txt)
echo in1.txt
echo -e ${GREEN}$INPUT01${NC}

echo
INPUT21=$(./lab2 in21.txt)
echo in21.txt
echo -e ${GREEN}$INPUT21${NC}

echo
INPUT22=$(./lab2 in22.txt)
echo in22.txt
echo -e ${GREEN}$INPUT22${NC}

echo
INPUT23=$(./lab2 in23.txt)
echo in23.txt
echo -e ${GREEN}$INPUT23${NC}

echo
INPUT24=$(./lab2 in24.txt)
echo in24.txt
echo -e ${GREEN}$INPUT24${NC}

echo
INPUT25=$(./lab2 in25.txt)
echo in25.txt
echo -e ${GREEN}$INPUT25${NC}

echo
INPUT26=$(./lab2 in26.txt)
echo in26.txt
echo -e ${GREEN}$INPUT26${NC}

echo
INPUT27=$(./lab2 in27.txt)
echo in27.txt
echo -e ${GREEN}$INPUT27${NC}

echo
INPUT28=$(./lab2 in28.txt)
echo in28.txt
echo -e ${GREEN}$INPUT28${NC}

echo
INPUT29=$(./lab2 in29.txt)
echo in29.txt
echo -e ${GREEN}$INPUT29${NC}

echo
INPUT61=$(./lab2 in61.txt)
echo in61.txt
echo -e ${GREEN}$INPUT61${NC}

echo
INPUT62=$(./lab2 in62.txt)
echo in62.txt
echo -e ${GREEN}$INPUT62${NC}
