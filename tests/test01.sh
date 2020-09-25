#!/bin/dash

# This is a small test for Subset 1. This
# tests if glob translation is enabled when\
# shell script is exploring the directory.

# Prepare directory and test files
mkdir test01
cd test01
touch a.c b.c c.c d.c
cd ..

# Compile shell
# Modified code from examples/1/for_gcc.sh from assignment examples
echo -e "#!/bin/dash\n" > test01_temp.sh
echo "for c_file in test01/*.c" >> test01_temp.sh
echo "do" >> test01_temp.sh
echo -e "\techo gcc -c \$c_file" >> test01_temp.sh
echo "done" >> test01_temp.sh
sh test01_temp.sh > test01_temp_output_sh.txt

# Compile shell using perl
./sheeple.pl test01_temp.sh > test01_temp.pl
perl test01_temp.pl > test01_temp_output_pl.txt

# Compare output
if (cmp test01_temp_output_sh.txt test01_temp_output_pl.txt > /dev/null)
then
    echo "Passed test01"
else
    echo -e "Failed test01\n"
    # Show output and programs
    echo "Shell Output ="
    cat test01_temp_output_sh.txt
    echo -e "\nPerl Output="
    cat test01_temp_output_pl.txt
    echo -e "\nShell Program ="
    cat test01_temp.sh
    echo -e "\nPerl Program ="
    cat test01_temp.pl
fi

# Remove temp files
rm test01_temp*
rm -R test01
