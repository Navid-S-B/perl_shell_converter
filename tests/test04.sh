#!/bin/dash

# This is a small test for Subset 0-3. 
# Tests program with nesting.

# Compile shell
echo -e "#!/bin/dash\n" > test04_temp.sh
echo "if test 5 -gt 4" >> test04_temp.sh
echo "then" >> test04_temp.sh
echo -e "\tif test 6 -lt 7" >> test04_temp.sh
echo -e "\tthen" >> test04_temp.sh
echo -e "\t\techo yay" >> test04_temp.sh
echo -e "\tfi" >> test04_temp.sh
echo -e "fi" >> test04_temp.sh
# Record output
sh test04_temp.sh > test04_temp_output_sh.txt

# Compile shell using perl
./sheeple.pl test04_temp.sh > test04_temp.pl
perl test04_temp.pl > test04_temp_output_pl.txt

# Compare output
if (cmp test04_temp_output_sh.txt test04_temp_output_pl.txt > /dev/null)
then
    echo "Passed test04"
else
    echo -e "Failed test04\n"
    # Show output and programs
    echo "Shell Output ="
    cat test04_temp_output_sh.txt
    echo -e "\nPerl Output="
    cat test04_temp_output_pl.txt
    echo -e "\nShell Program ="
    cat test04_temp.sh
    echo -e "\nPerl Program ="
    cat test04_temp.pl
fi

# Remove temp files
rm test04_temp*