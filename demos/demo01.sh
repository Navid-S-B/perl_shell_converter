##!/bin/dash

# Testing subset one and two broadly in this demo:
#   - Different glob types with ?, *, [] and on directories
#   - Testing read functionality
#   - Different array argument types
#   - Handles nesting of echo statements

# TO NOTE: type the same word twice for the read input.

mkdir demo01
cd demo01
touch a.c b.c c.c d.c
touch hello_a.txt hello.txt hello_b.txt
cd ..

# Create demo shell script
# Inspiration taken from 'examples/1' assignment code resources
echo -e "#!/bin/dash\n" > demo01_temp.sh
echo "for no in one two three" >> demo01_temp.sh
echo "do" >> demo01_temp.sh
echo -e "\techo \$no" >> demo01_temp.sh
echo -e "done\n" >> demo01_temp.sh
echo "for c_file in demo01/?.c" >> demo01_temp.sh
echo "do" >> demo01_temp.sh
echo -e "\techo gcc -c \$c_file" >> demo01_temp.sh
echo -e "done\n" >> demo01_temp.sh
echo "for txt_file in demo01/hello_[a-z].txt" >> demo01_temp.sh
echo "do" >> demo01_temp.sh
echo -e "\techo \$txt_file" >> demo01_temp.sh
echo -e "done\n" >> demo01_temp.sh
echo "for arg in Hey" >> demo01_temp.sh
echo "do" >> demo01_temp.sh
echo -e "\techo \"type in Hey\"" >> demo01_temp.sh
echo -e "\tread hey" >> demo01_temp.sh
echo -e "\techo \$hey" >> demo01_temp.sh
echo -e "\techo \$arg" >> demo01_temp.sh
echo -e "done\n" >> demo01_temp.sh

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
rm -R demo01
rm demo01_temp*
