#!/bin/bash

path=$1
program=$2
cd $1
if [ -f "Makefile" ]; then
 make &> output.txt 
 comp=$?

 if [ $comp -eq 0 ]; then
  com="pass"
  valgrind --leak-check=full --error-exitcode=1 ./$2 &> mem.txt
  valout=$?
  valgrind --tool=helgrind --error-exitcode=1 ./$2 &> mem.txt
  helout=$?

   if [ $valout -eq 0 ]; then
    val="pass"
   else val="fail"
   fi

   if [ $helout -eq 0 ]; then
    hel="pass"
   else hel="fail"
   fi

  sum=$((4*$comp+2*$valout+1*$helout))
  echo "BasicCheck.sh <$path> <$program> 
         compilation   Memory leaks   thread race 
            $com            $val          $hel"
  exit $sum

 else echo "The compilation failed"
  com="fail"
  echo "Basiccheck.sh <$path> <$program> 
         compilation   Memory leaks   thread race 
            $com            $val          $hel"

  exit 7
 fi

else echo "There is no Makefile"
fi
