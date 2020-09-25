#!/bin/dash

# This is a small test for Subset 3. This
# will test for echo -n in its variiant forms
# with different quotation marks.

# Compile shell
echo -e "#!/bin/dash\n" > test03_temp.sh
echo "echo -n yay" >> test03_temp.sh
echo "echo -n \"yay\"" >> test03_temp.sh
echo "echo -n '\"yay\"'" >> test03_temp.sh
echo "echo -n \"'yay'\"" >> test03_temp.sh
sh test03_temp.sh > test03_temp_output_sh.txt

# Compile shell using perl
./sheeple.pl test03_temp.sh > test03_temp.pl
perl test03_temp.pl > test03_temp_output_pl.txt

# Compare output
if (cmp test03_temp_output_sh.txt test03_temp_output_pl.txt > /dev/null)
then
    echo "Passed test03"
else
    echo -e "Failed test03\n"
    # Show output and programs
    echo "Shell Output ="
    cat test03_temp_output_sh.txt
    echo -e "\nPerl Output="
    cat test03_temp_output_pl.txt
    echo -e "\nShell Program ="
    cat test03_temp.sh
    echo -e "\nPerl Program ="
    cat test03_temp.pl
fi

# Remove temp files
rm test03_temp*
