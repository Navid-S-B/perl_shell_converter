#!/usr/bin/perl -w

# Navid Bhuiyan
# sheeple.pl is a POSIX shell compiler i.e. it translates 
# shell scrips outlined in the assignment spec to perl.
# Currently the program implements subsets 0, 1, 2, and 3 for translation.

# SUB-ROUTINES
# ----------------------------------------------------------------

# Handles compliation of perl instructions laid out in subset 0.
# Subset 3 partially addressed here with sorting nested variables.
sub subset_0_3 {

    foreach my $line (@lines) {
        
        #Measure whitespace
        my $measure_whitespace = $line;
        $measure_whitespace =~ /^(\t*)/;
        my $whitespace_count = length($1);
        my $type_space = 0;

        if ($whitespace_count eq '0') {
            $measure_whitespace =~ /^( *)/;
            $whitespace_count = length($1);
            $type_space = 1;
        }

        # Change first line
        if ($line =~ /bin/) {
            $line = "#!/usr/bin/perl -w";
        
        # Edit variable assignment
        } elsif ($line =~ /[^ ]=[^ ]/) {
            $line =~ s/^\t.*?|^ *?//;
            $line = "\$".$line;
            $line =~ s/=/ = /;

            # Add whitespace to variable
            my $add_whitepace;
            if ($type_space eq '0') {
                $add_whitepace = "\t" x $whitespace_count;
            } else {
                $add_whitepace = " " x $whitespace_count;
            }
            $line = $add_whitepace.$line;

            # Quote variables attached to strings
            if ($line =~ /= [^0-9"'\$]*$/) {
                $line =~ s/= /= '/;
                $line = $line."\'";
            }
            
            if ($line !~ /`/) {
                $line =~ s/\\/\\\\/g;
            }
            $line = $line.";";

        # Modify echo to perl equivalent
        # in terms of subset 0.
        # Ignore complex echo statements until
        # subset 3.
        } elsif ($line =~ /echo [^"'-]/) {

            $line =~ s/echo/print/;
            $line =~ s/print /print "/;
            $line =~ s/\\//g;
            $line = $line."\\n\";"

        # Skip comments
        } elsif ($line =~ /^ *#/) {
            next;
        # Assuming no variable with an equal sign is a sys call
        } elsif ($line =~ /^pwd|^ls|^id|^date/) {
            $line = "system "."\"".$line."\";"
        # Skip empty lines
        } else {
            next;
        }

    }

}

# Handles compliation of perl instructions laid out in subset 1.
# TO NOTE:
# It handles simple for loop nested statements by accident, 
# so subset 3 is partially addressed here due to regex anchor
# points modifying the string in place i.e. allowing for 
# nesting to be unmodified.
sub subset_1 {

    # Creating new array as for subset 1 
    # when translating shell read, it becomes
    # two instructions.
    my @new_array = ();

    foreach my $line (@lines) {
        
        # Skip comments
        if ($line =~ /^ *#/) {
            push @new_array, $line;
            next;
        }
    
        # cd command conversion
        if ($line =~ /cd/) {
            $line =~ s/cd/chdir/;
            
            if ($line !~ /'/) {            
                $line =~ s/ / '/;
                $line = $line."\'"
            }

            $line =~ s/$/;/;

        # for loop conversion
        } elsif ($line =~ /for/) {

            $line =~ s/for/foreach/;
            $line =~ s/foreach /foreach \$/;
            
            # Extracting glob array
            if ($line =~ /\*|\?|\[/) {
                $line =~ s/in /(glob('/;
                $line =~ s/$/')) {/;            
            # Extracting array
            } else {
                my $array = $line;
                $array =~ s/^.*in //;
                $array =~ s/ /', '/g;
                $array =~ s/^/('/;
                $array =~ s/$/')/; 
                $line =~ s/in.*$//;
                $line = $line."$array {";        
            }


        } elsif ($line =~ /done/) {

            $line =~ s/done/}/;
        
        # Assumed basic read functionality with no options enabled.
        } elsif ($line =~ /read/) {

            # Create chomp line.
            my $chomp_line = $line;
            $chomp_line =~ s/read /chomp \$/;
            $chomp_line =~ s/$/;/;
            # Create read from STDIN.
            $line =~ s/read /\$/;
            $line = $line." = <STDIN>;";
            push @new_array, $line;
            push @new_array, $chomp_line;
            # Skip to next instruction to convert in array.
            next;

        # Skip do
        } elsif ($line =~ /do/) {
            next;
        }

        push @new_array, $line;

    }

    return @new_array;

}

sub subset_2_args {

    my $temp_line = $_[0];
    my @temp_array = split ' ',  $temp_line;

    # Go though args of line to find shell args
    foreach my $arg (@temp_array) {

        # Modify each shell arg
        if ($arg =~ /\$[1-9]+/) {

            $arg =~ s/[^1-9]//g;
            $arg = $arg - 1;
            $arg =~ s/^/\$ARGV[/;
            $arg =~ s/$/]/;
            # Replace first instance on $temp_line;
            $temp_line =~ s/\$[0-9]+/$arg/;

        }

    }

    return $temp_line;

}

# Alter test statements for if, else, for, while loop statements.
sub subset_2_test {

    my $temp_line = $_[0];

    # Measure whitespace (tabs or spaces)
    my $measure_whitespace = $temp_line;
    $measure_whitespace =~ /^(\t*)/;
    my $whitespace_count = length($1);
    my $type_space = 0;

    if ($whitespace_count eq '0') {
        $measure_whitespace =~ /^( *)/;
        $whitespace_count = length($1);
        $type_space = 1;
    }

    # Anchor points for braces syntax
    $temp_line =~ s/elif/} elsif/;
    $temp_line =~ s/test /(/;
    $temp_line =~ s/ *$/) {/;

    my $new_line;
    my @temp_array = split ' ',  $temp_line;

    # Go though args of line to find shell args
    foreach my $arg (@temp_array) {

        # Check for $ variables to not
        # add '' marks
        if ($arg =~ /\([^\$-]/) {

            $arg =~ s/\(/\('/;
            $arg =~ s/$/'/;
        }
    
        # Add '' marks at end of comparison variable    
        if ($arg =~ /[^\$].+\)/) {

            $arg =~ s/^/'/;
            $arg =~ s/\)/'\)/;

            # Temporary fix for no quotation marks
            # for $[0-9] variables.
            if ($arg =~ /\$/) {
                $arg =~ s/'//g;
            }

        }

        # Change -options to perl equivalents
        if ($arg =~ /!=/) {
            $arg = 'ne'
        } elsif ($arg =~ /=/) {
            $arg = 'eq'
        # Add or and and statements
        } elsif ($arg =~ /\-[a-z]+/) {
            
            if ($arg =~ /\-a/) {
                $arg = 'and'
            } elsif ($arg =~ /\-o/) {
                $arg = 'or'
            } elsif ($arg !~ /-d|-r/) {
                $arg =~ s/\-//;
            }
            
        }

        $new_line =  $new_line."$arg ";

    }

    # Add whitespace if statements were indented
    my $add_whitepace;
    if ($type_space eq '0') {
        $add_whitepace = "\t" x $whitespace_count;
    } else {
        $add_whitepace = " " x $whitespace_count;
    }
    $new_line = $add_whitepace.$new_line;

    chomp $new_line;
    return $new_line;

}

# Modifies echo to subset 2 and 3 standards
sub subset_echo_2_3 {

    my $temp_line = $_[0];

    my $echo_n = $temp_line;

    if ($temp_line =~ /'".*"'/) {
        
        $temp_line =~ s/echo/print/;
        $temp_line =~ s/"/\\"/g;
        $temp_line =~ s/'/"/g;
        $temp_line = $temp_line.", \"\\n\";";


    } elsif ($temp_line =~ /"/) {

        $temp_line =~ s/echo/print/;
        $temp_line = $temp_line.", \"\\n\";";

    # '' Prints everything literally
    # So if there are any backslashes,
    # disable them.
    } elsif ($temp_line =~ /'/) {
        
        $temp_line =~ s/'//g;
        $temp_line =~ s/echo /print "/;
        $temp_line =~ s/\\/\\\\\\/g;
        $temp_line = $temp_line."\\n\";"

    # No quotation marks
    } else {
        
        $temp_line =~ s/echo/print/;
        $temp_line =~ s/print /print "/;
        $temp_line =~ s/$/\\n";/;

    }

    # If echo -n is enabled
    if ($echo_n =~ /-n/) {
        
        $temp_line =~ s/-n *//;
        $temp_line =~ s/\\n//;

        # If , "\n" semantic was used
        if ($temp_line =~ /,/) {
            $temp_line =~ s/,.*$/;/;
        }
    }

    return $temp_line;

}

# Converts subset 3 syntax into test form and expr form
# for subset_2_3 to convert.
sub subset_3 {

    my @new_array = ();

    foreach my $line (@lines) {

        if ($line =~ /\[/) {

            $line =~ s/\[/test/;
            $line =~ s/ *\]//;

        } elsif ($line =~ /\$\(\(/) {

            $line =~ s/\$\(\(/`expr /;
            $line =~ s/\)\)/`/;

        } elsif ($line =~ /\$\(/) {

            $line =~ s/\$\(/`/;
            $line =~ s/\)/`/;

        }

        # Convert argument variables to perl equivalent
        $line =~ s/\$#/\$#ARGV + 1/;
        $line =~ s/\$\*/"\@ARGV"/;
        $line =~ s/\$\@/\@ARGV/;
        $line =~ s/"\@ARGV"/\@ARGV/;
        $line =~ s/'\@ARGV'/\@ARGV/;


        push @new_array, $line;

    }

    return @new_array

}

# Incorporates subset 2 but deals with nesting for if/else statements.
sub subset_2_3 {

    # Creating new array as for subset 2
    # as lines need to be removed for if/else if/else 
    # statements.
    my @new_array = ();

    foreach my $line (@lines) {

        # Handling shell arguments ($0 .. $n) 
        if ($line =~ /[^\\]\$[1-9]+/) {
            $line = subset_2_args($line);
        }
        
        # Handles expressions if they exist in any line
        # Assumes expr is used in isolation.
        if ($line =~ /expr/) {
            # Remove \ for perl equivalent operations.
            $line =~ s/\\//;
            $line =~ s/expr//;
            $line =~ s/`//;
            $line =~ s/`/;/;
            # Extra ; appears when translating $(()) to expr
            $line =~ s/;{2,}/;/;
        }

        if ($line =~ /(echo.*"|echo.*'|echo -n)/) {
            $line = subset_echo_2_3($line);

        # Deals with if/elif/for and while test statements
        } elsif ($line =~ /if test|elif test|while test/) {
            $line = subset_2_test($line);
        }

        # Use these statements as anchor points for syntax
        if ($line =~ /else/) {
            $line =~ s/else/} else {/; 
        } elsif ($line =~ /[^a-zA-Z]*fi$/) {
            $line =~ s/fi/}/;
        # remove then
        } elsif ($line =~ /then/) {
            next;
        }
        
        push @new_array, $line;

    }

    return @new_array;

}

# MAIN FUNCTION
# ----------------------------------------------------------------

# Error handling if no argument is supplied
if ($#ARGV + 1 ne 1) {
    print "usage: $0 <file>\n";
    exit 1;
} else {
    $file = $ARGV[0];
}

# Open file and story lines in array
open $fh, '<', "$file" or die "File does not exist\n";
while (my $line = <$fh>) {
    chomp $line;
    push @lines, $line;
}
close $fh;

# Conversion per subset.
# TO NOTE: Subset 3 is integrated with functions
# mentioning _3 in their subroutine name.
subset_0_3();
@lines = subset_1();
@lines = subset_3();
@lines = subset_2_3();

# Print out compiled shell script
foreach my $line (@lines) {
    print "$line\n";
}
