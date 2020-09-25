##!/bin/dash

# Testing subset two broadly i.e. coverting shell argument 
# variables, echo with quotation marks, test, expr and while 
# loop.

# Create demo shell script.
echo -e "#!/bin/dash\n" > demo02_temp.sh
echo "num1=0" >> demo02_temp.sh
# Loop and say hello five times.
echo "while test \$num1 -lt 5" >> demo02_temp.sh
echo "do" >> demo02_temp.sh
echo -e "\techo \"Hello\"" >> demo02_temp.sh
echo -e "\tnum1=\`expr \$num1 + 1\`" >> demo02_temp.sh
echo "done" >> demo02_temp.sh
# Prints first arg.
echo "echo \"Loop finished \$1\"" >> demo02_temp.sh

# Capture output of shell script
sh demo02_temp.sh first_arg > demo02_temp_output_sh.txt

# Compile shell using perl and capture output
./sheeple.pl demo02_temp.sh > demo02_temp.pl
perl demo02_temp.pl first_arg > demo02_temp_output_pl.txt

# Compare Output
if (cmp demo02_temp_output_sh.txt demo02_temp_output_pl.txt > /dev/null)
then
    echo -e "Passed demo02\n"
else
    echo -e "Failed demo02\n"
fi

# Show output and programs
echo "Shell Output ="
cat demo02_temp_output_sh.txt
echo -e "\nPerl Output="
cat demo02_temp_output_pl.txt
echo -e "\nShell Program ="
cat demo02_temp.sh
echo -e "\nPerl Program ="
cat demo02_temp.pl

# Remove temp files
rm demo02_temp*
