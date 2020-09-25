#!/bin/dash

# Testing subset three in terms of translating special
# syntax/variables ($@, $#, $(()), $()) inside
# a for loop with indexing.

# TO NOTE: Demo works, its just that perl added one extra line since
# printig the output of pwd, it has an extra line, and perl translated
# the print state to add one more line.

# Create demo shell script.
echo -e "#!/bin/dash\n" > demo03_temp.sh
# Loop and say hello five times.
echo "for i in \"\$@\"" >> demo03_temp.sh
echo "do" >> demo03_temp.sh
echo -e "\techo \"\$i\"" >> demo03_temp.sh
echo "done" >> demo03_temp.sh
echo "num=\$((\$# + 2))" >> demo03_temp.sh
echo "echo \$num" >> demo03_temp.sh
echo "dir=\$(pwd)" >> demo03_temp.sh
echo "echo \$dir" >> demo03_temp.sh

# Capture output of shell script
sh demo03_temp.sh first_arg second_arg > demo03_temp_output_sh.txt

# Compile shell using perl and capture output
./sheeple.pl demo03_temp.sh > demo03_temp.pl
perl demo03_temp.pl first_arg second_arg > demo03_temp_output_pl.txt

# Compare Output
if (cmp demo03_temp_output_sh.txt demo03_temp_output_pl.txt 2> /dev/null)
then
    echo -e "Passed demo03\n"
else
    echo -e "Failed demo03\n"
fi

# Show output and programs
echo "Shell Output ="
cat demo03_temp_output_sh.txt
echo -e "\nPerl Output="
cat demo03_temp_output_pl.txt
echo -e "\nShell Program ="
cat demo03_temp.sh
echo -e "\nPerl Program ="
cat demo03_temp.pl

# Remove temp files
rm demo03_temp*