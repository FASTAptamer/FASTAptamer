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
    system("./fastaptamer_cluster -d 2 -c 1 -i $input_filename -o $output_filename");
    my $result   = slurp($output_filename);
    my $expected = string_from('expected');
    is( $result, $expected, 'successfully created single cluster' );
}

done_testing();

sub string_from {
    my $section = shift;

    my %text_for = (
        input => ">1-250-250000.0
AAAAAAAAAAAAAAAAAA
>2-240-240000.0
CAAAAAAAAAAAAAAAAA
>3-235-235000.0
GAAAAAAAAAAAAAAAAA
>4-200-200000.0
TAAAAAAAAAAAAAAAAA
>5-75-75000.0
CCCCCCCCCAAAAAAAAA
",
        expected => ">1-250-250000.0-1-1-0
AAAAAAAAAAAAAAAAAA
>2-240-240000.0-1-2-1
CAAAAAAAAAAAAAAAAA
>3-235-235000.0-1-3-1
GAAAAAAAAAAAAAAAAA
>4-200-200000.0-1-4-1
TAAAAAAAAAAAAAAAAA
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

sub temp_filename {
    my ($fh, $filename) = tempfile();
    close $fh;
    return $filename;
}

sub slurp {
    my $file = shift;
    open(my $fh, '<', $file) or die;
    local $/ = undef;
    my $text = readline $fh;
    close $fh;
    return $text;
}
