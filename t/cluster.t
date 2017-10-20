package test;
use 5.008;    # Require at least Perl version 5.8
use strict;   # Must declare all variables before using them
use warnings; # Emit helpful warnings
use autodie;  # Fatal exceptions for common unrecoverable errors (e.g. w/open)

# Testing-related modules
use Test::More;                  # provide testing functions (e.g. is, like)
use Data::Section -setup;        # Set up labeled DATA sections
use Path::Tiny;

for my $cluster_app (qw(fastaptamer_cluster fastaptamer_cluster_xs))
{

    for my $set( '', '_tied_sequence')
    {
        my $input_name = "input$set";
        my $expected_name = "expected$set";
    
        my $input_filename  = filename_for($input_name);
        my $output_filename = Path::Tiny->tempfile();
        system("./$cluster_app -d 2 -c 2 -i $input_filename -o $output_filename");
        my $result   = path($output_filename)->slurp;
        my $expected = string_from($expected_name);
        is( $result, $expected, "$cluster_app successfully created single cluster for $input_name" );
    }
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
>1-250-250000.0
AAAAAAAAAAAAAAAAAA
>2-240-240000.0
CAAAAAAAAAAAAAAAAA
>3-235-235000.0
GAAAAAAAAAAAAAAAAA
>4-200-200000.0
TAAAAAAAAAAAAAAAAA
>5-75-75000.0
CCCCCCCCCAAAAAAAAA
__[ expected ]__
>1-250-250000.0-1-1-0
AAAAAAAAAAAAAAAAAA
>2-240-240000.0-1-2-1
CAAAAAAAAAAAAAAAAA
>3-235-235000.0-1-3-1
GAAAAAAAAAAAAAAAAA
>4-200-200000.0-1-4-1
TAAAAAAAAAAAAAAAAA
>5-75-75000.0-2-1-0
CCCCCCCCCAAAAAAAAA
__[ input_tied_sequence ]__
>1-245-245000.0
AAAAAAAAAAAAAAAAAA
>2-240-240000.0
CAAAAAAAAAAAAAAAAA
>2(2)-240-240000.0
GAAAAAAAAAAAAAAAAA
>3-200-200000.0
TAAAAAAAAAAAAAAAAA
>4-75-75000.0
CCCCCCCCCAAAAAAAAA
__[ expected_tied_sequence ]__
>1-245-245000.0-1-1-0
AAAAAAAAAAAAAAAAAA
>2-240-240000.0-1-2-1
CAAAAAAAAAAAAAAAAA
>2(2)-240-240000.0-1-3-1
GAAAAAAAAAAAAAAAAA
>3-200-200000.0-1-4-1
TAAAAAAAAAAAAAAAAA
>4-75-75000.0-2-1-0
CCCCCCCCCAAAAAAAAA
