use 5.008;  # Require at least Perl version 5.8
use strict;   # Must declare all variables before using them
use warnings; # Emit helpful warnings
use autodie;  # Fatal exceptions for common unrecoverable errors (e.g. w/open)

# Testing-related modules
use Test::More;                  # provide testing functions (e.g. is, like)
use Test::LongString;
use Data::Section -setup;        # Set up labeled DATA sections
use File::Temp  qw( tempfile );  #
use File::Slurp qw( slurp    );  # Read a file into a string


{
    my $input_A  = filename_for('input_A');
    my $input_B  = filename_for('input_B');
    my $output_filename = temp_filename();
    system("perl fastaptamer_compare -x $input_A -y $input_B -o $output_filename");
    my $result   = slurp $output_filename;

    my $expected_A = string_from('expected_header')
                   . string_from('expected_sequence_1')
                   . string_from('expected_sequence_2')
                   . string_from('expected_histogram')
                   ;

    my $expected_B = string_from('expected_header')
                   . string_from('expected_sequence_2')
                   . string_from('expected_sequence_1')
                   . string_from('expected_histogram')
                   ;

    # Result order is dependent on hash, so there are two possibilities
    ok( ($result eq $expected_A) || ($result eq $expected_B), 'successfully did comparison between two count files' );

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

sub filename_for {
    my $section           = shift;
    my ( $fh, $filename ) = tempfile();
    my $string            = string_from($section);
    print {$fh} $string;
    close $fh;
    return $filename;
}

sub temp_filename {
    my ($fh, $filename) = tempfile();
    close $fh;
    return $filename;
}

__DATA__
__[ input_A ]__
>1-40-400000.00
AAAAAAAAAAAAAAAAAA
>1(2)-40-400000.00
GAAAAAAAAAAAAAAAAA
__[ input_B ]__
>1-4-400000.00
GAAAAAAAAAAAAAAAAA
>1(2)-4-400000.00
AAAAAAAAAAAAAAAAAA
__[ expected_header  ]__
Sequence	RPM (x)	RPM (y)	log(base2)(y/x)
__[ expected_sequence_1  ]__
AAAAAAAAAAAAAAAAAA	400000.00	400000.00	0
__[ expected_sequence_2  ]__
GAAAAAAAAAAAAAAAAA	400000.00	400000.00	0
__[ expected_histogram ]__


HISTOGRAM DATA
Bin	Frequency
< -5	0
-4.9	0
-4.8	0
-4.7	0
-4.6	0
-4.5	0
-4.4	0
-4.3	0
-4.2	0
-4.1	0
-4.0	0
-3.9	0
-3.8	0
-3.7	0
-3.6	0
-3.5	0
-3.4	0
-3.3	0
-3.2	0
-3.1	0
-3.0	0
-2.9	0
-2.8	0
-2.7	0
-2.6	0
-2.5	0
-2.4	0
-2.3	0
-2.2	0
-2.1	0
-2.0	0
-1.9	0
-1.8	0
-1.7	0
-1.6	0
-1.5	0
-1.4	0
-1.3	0
-1.2	0
-1.1	0
-1.0	0
-0.9	0
-0.8	0
-0.7	0
-0.6	0
-0.5	0
-0.4	0
-0.3	0
-0.2	0
-0.1	0
0.0	2
0.1	0
0.2	0
0.3	0
0.4	0
0.5	0
0.6	0
0.7	0
0.8	0
0.9	0
1.0	0
1.1	0
1.2	0
1.3	0
1.4	0
1.5	0
1.6	0
1.7	0
1.8	0
1.9	0
2.0	0
2.1	0
2.2	0
2.3	0
2.4	0
2.5	0
2.6	0
2.7	0
2.8	0
2.9	0
3.0	0
3.1	0
3.2	0
3.3	0
3.4	0
3.5	0
3.6	0
3.7	0
3.8	0
3.9	0
4.0	0
4.1	0
4.2	0
4.3	0
4.4	0
4.5	0
4.6	0
4.7	0
4.8	0
4.9	0
5.0	0
> 5	0
