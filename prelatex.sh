#!/bin/sh
#this is the gnu/linux version, there is a mac version with few changes
#preformating a csv file to use it in LaTeX later.
#it will significantly improve compiling speed, up to x100 where I used it


#mac, gnu/linux, and windows 'new line' are not the same
echo "deleting nonsense x0D..."
#
cat tabname.csv | sed 's/\x0D/\x0A/g' > tabname.csv.tmp

#adding commas for nonempty values in columns 2 to 5
#use gsed (gnu-sed) on linux and sed on gnu/linux
echo "seding..."
#
cat tabname.csv.temp | sed "2,\$s/^\([^,]*\),\([^,]\+\),,,\([^,]\+\),/\1,\\\"\2,\\\",,,\3,/" | sed "2,\$s/^\([^,]*\),\([^,\\\"]*\|\\\"[^,\\\"]*,\\\"\),\([^,]\+\),,\([^,]\+\),/\1,\2,\\\"\3,\\\",,\4,/" | sed "2,\$s/^\([^,]*\),\([^,\\\"]*\|\\\"[^,\\\"]*,\\\"\),\([^,\\\"]*\|\\\"[^,\\\"]*,\\\"\),\([^,]\+\),\([^,]\+\),/\1,\2,\3,\\\"\4,\\\",\5,/" | sed "2,\$s/^\([^,]*\),\([^,\\\"]\+\|\\\"[^,\\\"]\+,\\\"\),,\([^,\\\"]\+\|\\\"[^,\\\"]\+,\\\"\),/\1,\\\"\2,\\\",,\3,/" | sed "2,\$s/^\([^,]*\),\([^,\\\"]*\|\\\"[^,\\\"]*,\\\"\),\([^,\\\"]\+\|\\\"[^,\\\"]\+,\\\"\),\([^,\\\"]\+\|\\\"[^,\\\"]\+,\\\"\),/\1,\2,\\\"\3,\\\",\4,/" | sed "2,\$s/^\([^,]*\),\([^,\\\"]\+\|\\\"[^,\\\"]\+,\\\"\),\([^,\\\"]\+\|\\\"[^,\\\"]\+,\\\"\),/\1,\\\"\2,\\\",\3,/" > tabname.csv.temp

#latex DTLloaddb runs faster on small data bases
#makes a separate file for each subregion and put them in $(pwd)/temp
echo "splitting..."
#
echo "" > tablist.txt
var0=$(grep -m1 "" tabname.csv.temp)
for var1 in $(cat tabname.csv.temp | sed  "s/^\([^,]*,\|\\\"[^,\\\"]*,\\\",\)\{10\}//" | sed "s/\([^,]\+\),.*/\1/" | grep -v "^Subregion$" | sort | uniq);do
	echo "\t>>extracting subregion $var1..."
	echo "\\DTLloaddb{tabname$var1}{temp/tabname$var1.csv}" >> tablist.txt
	echo $var0 > temp/tabname$var1.csv
	cat tabname.csv | grep  "^\([^,]*,\|\\\"[^,\\\"]*,\\\",\)\{10\}$var1," >> temp/tabname$var1.csv
done

echo "done !"

#vim macro for .tex edit
#khf]bbyekdkhwpkrdebiwinn
#runs ^l"+y$ on it, then, on .tex file search lines with 'foreach' and run ggn999@+ 

