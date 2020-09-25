#!/bin/dash

# Testing subset zero with random variable assignments and echo statements.
# It also adds a \n in a echo statement, which
# altered in the perl script and print n instead of \n, 
# It also includes a system call.

# TO NOTE: Output for this test differs by a space in a wacky case
# i.e. 'echo $arg $arg ...'' vs 'echo "$arg $arg ..."'.'

# Create demo shell script
echo -e "#!/bin/dash\n" > demo01_temp.sh
echo "# This is the demo for Subset 0" >> demo01_temp.sh
echo "word=\"I am happy bro\"" >> demo01_temp.sh
echo "word2='<3'" >> demo01_temp.sh
echo "word3=hehe" >> demo01_temp.sh
echo "word4=5" >> demo01_temp.sh
echo "echo \$word \n \$word2 \$word3 \$word4" >> demo01_temp.sh
echo "pwd" >> demo01_temp.sh

# Capture output of shell script
sh demo01_temp.sh > demo01_temp_output_sh.txt

# Compile shell using perl and capture output
./sheeple.pl demo01_temp.sh > demo01_temp.pl
perl demo01_temp.pl > demo01_temp_output_pl.txt

# Compare Output
if (cmp demo01_temp_output_sh.txt demo01_temp_output_pl.txt > /dev/null)
then
    echo -e "Passed demo01\n"
else
    echo -e "Failed demo01\n"
fi

# Show output and programs
echo "Shell Output ="
cat demo01_temp_output_sh.txt
echo -e "\nPerl Output="
cat demo01_temp_output_pl.txt
echo -e "\nShell Program ="
cat demo01_temp.sh
echo -e "\nPerl Program ="
cat demo01_temp.pl

# Remove temp files
rm demo01_temp*
