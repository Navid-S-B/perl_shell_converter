#!/bin/dash

# This is a small test for Subset 2. This
# test my program where it can convert a while
# loop with a test statement and a convert an echo
# statement with ""|'' characters.

# Compile shell
echo -e "#!/bin/dash\n" > test02_temp.sh
echo "num1=4" >> test02_temp.sh
echo "num2=5" >> test02_temp.sh
# Shouldn't activate in final output
echo "while test \$num1 -gt \$num2" >> test02_temp.sh
echo "do" >> test02_temp.sh
echo -e "\techo nothing" >> test02_temp.sh
echo "done" >> test02_temp.sh
echo "echo \"I am the king\"" >> test02_temp.sh
sh test02_temp.sh > test02_temp_output_sh.txt

# Compile shell using perl
./sheeple.pl test02_temp.sh > test02_temp.pl
perl test02_temp.pl > test02_temp_output_pl.txt

# Compare output
if (cmp test02_temp_output_sh.txt test02_temp_output_pl.txt > /dev/null)
then
    echo "Passed test02"
else
    echo -e "Failed test02\n"
    # Show output and programs
    echo "Shell Output ="
    cat test02_temp_output_sh.txt
    echo -e "\nPerl Output="
    cat test02_temp_output_pl.txt
    echo -e "\nShell Program ="
    cat test02_temp.sh
    echo -e "\nPerl Program ="
    cat test02_temp.pl
fi

# Remove temp files
rm test02_temp*