#!/bin/dash

# This is a small test for Subset 0. It tests
# printing a variable assigned to a string.

# Compile shell
echo -e "#!/bin/dash\n" > test00_temp.sh
echo "word='I am happy bro'" > test00_temp.sh
echo "echo \$word" >> test00_temp.sh
sh test00_temp.sh > test00_temp_output_sh.txt

# Compile shell using perl
./sheeple.pl test00_temp.sh > test00_temp.pl
perl test00_temp.pl > test00_temp_output_pl.txt

# Compare output
if (cmp test00_temp_output_sh.txt test00_temp_output_pl.txt > /dev/null)
then
    echo "Passed Test00"
else
    echo -e "Failed Test00\n"
    # Show output and programs
    echo "Shell Output ="
    cat test00_temp_output_sh.txt
    echo -e "\nPerl Output="
    cat test00_temp_output_pl.txt
    echo -e "\nShell Program ="
    cat test00_temp.sh
    echo -e "\nPerl Program ="
    cat test00_temp.pl
fi

# Remove temp files
rm test00_temp*