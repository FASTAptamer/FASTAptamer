use 5.008;    # Require at least Perl version 5.8
use strict;   # Must declare all variables before using them
use warnings; # Emit helpful warnings
use autodie;  # Fatal exceptions for common unrecoverable errors (e.g. w/open)

# Testing-related modules
use Test::More;                  # provide testing functions (e.g. is, like)
use Test::LongString;            # Compare strings byte by byte
use Data::Section -setup;        # Set up labeled DATA sections
use Path::Tiny;

{
    my $input_filename  = filename_for('input');
    my $output_filename = Path::Tiny->tempfile();
    system("./fastaptamer_cluster -d 2 -c 2 -i $input_filename -o $output_filename");
    my $result   = path($output_filename)->slurp;
    my $expected = string_from('expected');
    is( $result, $expected, 'successfully created single cluster' );
}

done_testing();

sub sref_from {
    my $section = shift;

    #Scalar reference to the section text
    return __PACKAGE__->section_data($section);
}

sub string_from {
    my $section = shift;

    #Get the scalar reference
    my $sref = sref_from($section);

    #Return a string containing the entire section
    return ${$sref};
}

sub fh_from {
    my $section = shift;
    my $sref    = sref_from($section);

    #Create filehandle to the referenced scalar
    open( my $fh, '<', $sref );
    return $fh;
}

sub assign_filename_for {
    my $filename = shift;
    my $section  = shift;

    # Don't overwrite existing file
    die "'$filename' already exists." if -e $filename;

    my $string   = string_from($section);
    path($filename)->spew($string);

    return;
}

sub filename_for {
    my $section           = shift;
    my $string   = string_from($section);

    my $tempfile = Path::Tiny->tempfile();
    $tempfile->spew($string); 

    return $tempfile;
}

sub delete_temp_file {
    my $filename  = shift;
    my $delete_ok = unlink $filename;
    ok($delete_ok, "deleted temp file '$filename'");
}

#------------------------------------------------------------------------
# IMPORTANT!
#
# Each line from each section automatically ends with a newline character
#------------------------------------------------------------------------

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
