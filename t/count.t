package test;
use 5.008;    # Require at least Perl version 5.8
use strict;   # Must declare all variables before using them
use warnings; # Emit helpful warnings
use autodie;  # Fatal exceptions for common unrecoverable errors (e.g. w/open)

# Testing-related modules
use Test::More;                  # provide testing functions (e.g. is, like)
use Data::Section -setup;        # Set up labeled DATA sections
use Path::Tiny;

{
    my $input_filename  = filename_for('input');
    my $output_filename = Path::Tiny->tempfile();
    system("./fastaptamer_count -i $input_filename -o $output_filename");
    my $result   = path($output_filename)->slurp;
    my $expected = string_from('expected');
    is( $result, $expected, 'successfully created count file' );
}

done_testing();

sub string_from {
    my $section = shift;

    #Get the scalar reference to the section text
    my $sref = test->section_data($section);

    #Return a string containing the entire section
    return ${$sref};
}

sub filename_for {
    my $section           = shift;
    my $string   = string_from($section);

    my $tempfile = Path::Tiny->tempfile();
    $tempfile->spew($string); 

    return $tempfile;
}

__DATA__
__[ input ]__
@
AAAAAAAAAAAAAAAAAA
+
@HHHH@HHHHHHHH@HHH
@B
AAAAAAAAAAAAAAAAAA
+
@HHHHHHHHHHHHHHHHH
@C
GAAAAAAAAAAAAAAAAA
+
HHHHHHHHHHHHHHHHHH
@D
GAAAAAAAAAAAAAAAAA
+
HHHHHHHHHHHHHHHHHH
@E
CCCCCCCCCAAAAAAAAA
+
HHHHHHHHHHHHHHHHHH
@F
AAAAAAAAAAAAAAAAAA
+
HHHHHHHHHHHHHHHHHH
__[ expected ]__
>1-3-500000.00
AAAAAAAAAAAAAAAAAA
>2-2-333333.33
GAAAAAAAAAAAAAAAAA
>3-1-166666.67
CCCCCCCCCAAAAAAAAA
