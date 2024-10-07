#!/bin/env perl
package test;
use 5.008;    # Require at least Perl version 5.8
use strict;   # Must declare all variables before using them
use warnings; # Emit helpful warnings
use autodie;  # Fatal exceptions for common unrecoverable errors (e.g. w/open)

# Testing-related modules
use Test::More;                  # provide testing functions (e.g. is, like)
use File::Temp qw(tempfile);

{
    my $input_filename  = filename_for('input');
    my $output_filename = temp_filename();
    my $csv_out_filename = temp_filename();

    system("./fastaptamer_count -i $input_filename -o $output_filename -c $csv_out_filename");

    my $result   = slurp($output_filename);
    my $expected = string_from('expected');
    is($result, $expected, 'successfully created count file' );

    my $result_csv   = slurp($csv_out_filename);
    my $expected_csv = string_from('expected_csv');
    is($result_csv, $expected_csv, 'successfully created CSV count output' );
}

{
    my $input_filename  = filename_for('input_fasta');
    my $output_filename = temp_filename();
    system("./fastaptamer_count -f -i $input_filename -o $output_filename");
    my $result   = slurp($output_filename);
    my $expected = string_from('expected');
    is($result, $expected, 'successfully created count file from FASTA input' );
}

{
    my $input_filename  = gzipped_filename();
    my $output_filename = temp_filename();
    system("./fastaptamer_count -i $input_filename -o $output_filename");
    my $result   = slurp($output_filename);
    my $expected = string_from('expected');
    is( $result, $expected, 'FASTA file automatically detected' );
}

{
    my $input_filename  = filename_for('input_unique_IDs');
    my $output_filename = temp_filename();
    system("./fastaptamer_count -u -i $input_filename -o $output_filename");
    my $result   = slurp($output_filename);
    my $expected_A = string_from('expected_unique_IDs_A');
    my $expected_B = string_from('expected_unique_IDs_B');

    # Two possible results since the order of the result is hash-based and there are two possibilities
    ok( ($result eq $expected_A) || ($result eq $expected_B) , 'successfully created count file with unique sequence IDs' );
}

done_testing();

sub string_from {
    my $section = shift;
    my %text_for = (
        input => '@
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
',
        input_fasta => ">A
AAAAAAAAAAAAAAAAAA
>B
AAAAAAAAAAAAAAAAAA
>C
GAAAAAAAAAAAAAAAAA
>D
GAAAAAAAAAAAAAAAAA
>E
CCCCCCCCCAAAAAAAAA
>F
AAAAAAAAAAAAAAAAAA
",
        expected => ">1-3-500000.00
AAAAAAAAAAAAAAAAAA
>2-2-333333.33
GAAAAAAAAAAAAAAAAA
>3-1-166666.67
CCCCCCCCCAAAAAAAAA
",
        input_unique_IDs => '@
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
@G
AAAAAAAAAGGGGGGGGG
+
HHHHHHHHHHHHHHHHHH
@
AAAAAAAAAAAAAAAAAA
+
@HHHH@HHHHHHHH@HHH
@
AAAAAAAAAAAAAAAAAA
+
@HHHH@HHHHHHHH@HHH
@
AAAAAAAAAAAAAAAAAA
+
@HHHH@HHHHHHHH@HHH
',
        expected_csv => 'rank,sequence,count,cpm,percent
1,AAAAAAAAAAAAAAAAAA,3,500000,50
2,GAAAAAAAAAAAAAAAAA,2,333333.333333333,33.3333333333333
3,CCCCCCCCCAAAAAAAAA,1,166666.666666667,16.6666666666667
',
        expected_unique_IDs_A => ">1-6-600000.00
AAAAAAAAAAAAAAAAAA
>2-2-200000.00
GAAAAAAAAAAAAAAAAA
>3-1-100000.00
CCCCCCCCCAAAAAAAAA
>3(2)-1-100000.00
AAAAAAAAAGGGGGGGGG
",
        expected_unique_IDs_B => ">1-6-600000.00
AAAAAAAAAAAAAAAAAA
>2-2-200000.00
GAAAAAAAAAAAAAAAAA
>3-1-100000.00
AAAAAAAAAGGGGGGGGG
>3(2)-1-100000.00
CCCCCCCCCAAAAAAAAA
",
);

    #Return a string containing the entire section
    return $text_for{$section};
}

sub filename_for {
    my $section           = shift;
    my ( $fh, $filename ) = tempfile();
    my $string            = string_from($section);
    print {$fh} $string;
    close $fh;
    return $filename;
}

sub gzipped_filename {
    return 't/example.fq.gz';
}

sub slurp {
    my $file = shift;
    open(my $fh, '<', $file) or die;
    local $/ = undef;
    my $text = readline $fh;
    close $fh;
    return $text;
}

sub temp_filename {
    my ($fh, $filename) = tempfile();
    close $fh;
    return $filename;
}
