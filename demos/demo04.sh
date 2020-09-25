#!/bin/dash

# Demoing subset zero to three. Combining everything together.

# TO NOTE: Demo works, its just that perl added one extra line since
# printig the output of pwd, it has an extra line, and perl translated
# the print state to add one more line.

# Make files to test existence
mkdir demo04
touch demo04_temp_test.pl

# Create demo shell script.
echo -e "#!/bin/dash\n" > demo04_temp.sh
echo "if [ -d demo04 ] " >> demo04_temp.sh
echo "then" >> demo04_temp.sh
echo -e "\tif [ -r demo04.pl ]" >> demo04_temp.sh
echo -e "\tthen" >> demo04_temp.sh
echo -e "\t\techo yay" >> demo04_temp.sh
echo -e "\tfi" >> demo04_temp.sh
echo -e "fi" >> demo04_temp.sh
echo "for i in \"\$@\"" >> demo04_temp.sh
echo "do" >> demo04_temp.sh
echo -e "\tif test code = great" >> demo04_temp.sh
echo -e "\tthen" >> demo04_temp.sh
echo -e "\t\techo -n oh no" >> demo04_temp.sh
echo -e "\tfi" >> demo04_temp.sh
echo -e "\techo \$*" >> demo04_temp.sh
echo "done" >> demo04_temp.sh
echo "num=\$((1+1))" >> demo04_temp.sh
echo "word=\$num" >> demo04_temp.sh
echo "echo -n \$word" >> demo04_temp.sh

# Capture output of shell script
sh demo04_temp.sh first_arg second_arg > demo04_temp_output_sh.txt

# Compile shell using perl and capture output
./sheeple.pl demo04_temp.sh > demo04_temp.pl
perl demo04_temp.pl first_arg second_arg > demo04_temp_output_pl.txt

# Compare Output
if (cmp demo04_temp_output_sh.txt demo04_temp_output_pl.txt 2> /dev/null)
then
    echo -e "Passed demo04\n"
else
    echo -e "Failed demo04\n"
fi

# Show output and programs
echo "Shell Output ="
cat demo04_temp_output_sh.txt
echo -e "\nPerl Output="
cat demo04_temp_output_pl.txt
echo -e "\nShell Program ="
cat demo04_temp.sh
echo -e "\nPerl Program ="
cat demo04_temp.pl

# Remove temp files
rm demo04_temp*
rm -R demo04
