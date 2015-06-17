--------------------------------------------------------------------------------  
 
FASTAptamer v1.0.7

If you use, adapt, or modify FASTAptamer please cite:
Khalid K. Alam, Jonathan L. Chang & Donald H. Burke
"FASTAptamer: A Bioinformatic Toolkit for High-Throughput Sequence Analysis of 
Combinatorial Selections" Molecular Therapy - Nucleic Acids. 2015. 
DOI: 10.1038/mtna.2015.4


(C) 2014.

Web: http://burkelab.missouri.edu/
Email: burkelab@missouri.edu
Twitter: @BurkeLabRNA

--------------------------------------------------------------------------------

I. Introduction
II. Installation
III. FASTAptamer-Count
IV. FASTAptamer-Compare
V. FASTAptamer-Cluster
VI. FASTAptamer-Enrich
VII. FASTAptamer-Search
VIII. Version history
IX. License
X. Miscellaneous 

--------------------------------------------------------------------------------

I. Introduction

FASTAptamer was developed to address the analysis needs of high throughput sequ-
encing data from combinatorial selections. The FASTAptamer toolkit rapidly conv-
erts large FASTQ files into manageable FASTA files, ranks, sorts, and normalizes
read counts for each unique sequence, compares two populations for sequence dis-
tribution, calculates enrichment fold across two or three populations, clusters 
sequences according to a user-defined Levenshtein edit distance and searches for
degenerate sequence motifs.  While originally developed for aptamer and ribozyme
discovery, FASTAptamer provides insight into phage display, in vivo mutagenesis 
selection and other DNA-encoded libraries. The FASTAptamer toolkit currently in-
cludes five tools, FAST-Aptamer-Count, FASTAptamer-Compare, FASTAptamer-Cluster,
FASTAptamer-Enrich, and FASTAptamer-Search.

** For detailed instructions on installation and use of the FASTAptamer toolkit, 
including sample sequence data and screenshots, please see the PDF user's guide 
included with the download. **

--------------------------------------------------------------------------------

II. Installation

The FASTAptamer toolkit is written in Perl 5 and has no external dependencies.  
It should operate on any modern Unix-like system (including Linux and Mac OS X)
and has been tested using CentOS Linux 5.4, Mac OS X 10.5+, and Debian GNU/Linu-
x 7.0. FASTAptamer should also be able to run on a Microsoft Windows platform p-
rovided that a Perl interpreter has been installed, such as ActiveState Perl or 
Strawberry Perl.  

FASTAptamer can be used by installing or by saving the files to an accessible d-
irectory and executing the Perl interpreter on each script as needed.

Installation and use of the FASTAptamer toolkit assumes a basic working knowled-
ge of command line operation.  FASTAptamer is currently provided as a collection
of scripts, after downloading the scripts there is one main task to complete the
"installation" process -- saving the scripts in an executable directory.

The scripts should be saved in a directory where executable programs are found 
(known as the "path variable" and typically /bin, /usr/bin, or /usr/local/bin).

To find these directories, enter the following on the command line on your shell
prompt.

    echo $PATH

This should list the directories (separated by colons) your system uses to sear-
ch for executable programs.  You may not have permission to modify some of these
folders, but you should be able to move the FASTAptamer files from their current 
location into one of these directories using the move (mv) or copy (cp) command. 

Once the scripts are in an executable directory and have the appropriate permis-
sion to execute, the FASTAptamer toolkit should be ready for use.

Alternately, if you're having trouble accessing your PATH directories, you can 
use FASTAptamer without installation.  For details on this process, refer to the
PDF user's guide included with the download.

--------------------------------------------------------------------------------

III. FASTAptamer-Count

FASTAptamer-Count serves as the gateway to the FASTAptamer suite of bioinformat-
ics tools.  FASTAptamer-Count will accept a FASTQ input file (the de facto NGS/
HTS file format).  Ideally, the data should be trimmed to remove any constant r-
egions and filtered to include only the high-quality reads. FASTAptamer-Count n-
on-destructively outputs a sorted and non-redundant FASTA formatted file in whi-
ch each unique sequence generates a FASTA entry with the following information 
in the description line of each sequence entry:

	>RANK-READS-RPM

Where RANK is the relative abundance of the sequence within the population. In 
cases where two or more sequences are sampled with equal abundance, FASTAptamer-
Count follows standard competition ranking (e.g., "1-2-2-4" where two sequences 
are tied for second).  READS is the raw number of times a sequence was counted. 
RPM is "Reads per million," which is a normalized value that allows for compari-
son across populations of varying read depth. RPM is calculated as: 

	RPM = (READS/(population size)) x 10^6.

In addition to generating a FASTA output file, FASTAptamer-Count will display a 
summary report on the screen (STDOUT) that includes the number of total reads f-
ound in the input file, the number of unique sequences, the file input/output n-
ames and the program execution time. The  summary report can be suppressed by i-
ncluding the optional flag [-q] on the command line.  

Usage: fastaptamer_count [-h] [-q] [-v] [-i INFILE] [-o OUTFILE] 
    [-h]            = Help screen.
    [-q]            = Suppress STDOUT of run report.
    [-v]            = Display version.
    [-i INFILE]     = FASTQ input file. REQUIRED.
    [-o OUTFILE]    = FASTA output file. REQUIRED.
    
--------------------------------------------------------------------------------

IV. FASTAptamer-Compare

FASTAptamer-Compare facilitates statistical analysis of two populations by rapi-
dly generating a tab-delimited output file that lists each unique sequence along
with RPM (reads per million) in each population file (if available) and log(2) 
of the ratio of their RPM values in each population. 

RPM data for both populations can be utilized to generate an XY-scatter plot of 
sequence distribution across two populations.  FASTAptamer-Compare also facilit-
ates the generation of a histogram of the sequence distribution by creating 102 
bins for the log(2) values.  This histogram can provide a quick visual comparis-
on of the two populations: distributions centered around 0 indicate similar pop-
ulations, while distributions shifted to the left or right indicate overall enr-
ichment or depletion.

Input for FASTAptamer-Compare MUST come from FASTAptamer-Count output files.

Usage: fastaptamer_compare [-h] [-x INFILE] [-y INFILE] [-o OUTFILE] [-q] [-a]
                           [-v]
    [-h]            = Help screen.
    [-x INFILE]     = Input file (from FASTAptamer-Count). REQUIRED.
    [-y INFILE]     = Input file (from FASTAptamer-Count). REQUIRED.
    [-o OUTFILE]    = Plain text output file with tab separated values. REQUIRED
    [-q]            = Quiet mode.  Suppresses standard output of file I/O 
                      and execution time.
    [-a]            = Output all sequences, including those present in only
                      one input file.  Default behavior suppresses output 
                      of sequences without a match.
    [-v]            = Display version.
                      
--------------------------------------------------------------------------------

V. FASTAptamer-Cluster 

FASTAptamer-Cluster uses the Levenshtein algorithm to cluster together sequences
based on a user-defined edit distance.  The most abundant and unclustered seque-
nce is used as the "seed sequence" for which edit distance is calculated from.  
Output is FASTA with the following information on the identifier line of each 
sequence entry:

    >Rank-Reads-RPM-Cluster#-RankWithinCluster-EditDistanceFromSeed
    SEQUENCE

To prevent clustering of sequences not highly sampled (and improve execution ti-
me), invoke the read filter [-f] and enter a number.  Only sequences with total 
reads greater than the number entered will be clustered. 

To limit the number of clusters to the most you would be interested in (and imp-
rove execution time), use the maximum clusters option [-c].

Input for FASTAptamer-Cluster MUST come from FASTAptamer-Count output files. 

PLEASE NOTE: This is a computationally intense program that can take multiple h-
ours to finish, depending on the size and complexity of your population. 

Usage: fastaptamer_cluster [-h] [-i INFILE] [-o OUTFILE] [-d] [-f] [-q] [-v]
    [-h]            = Help screen.
    [-i INFILE]     = Input file from fastaptamer_count. REQUIRED.
    [-o OUTFILE]    = Output file, FASTA format. REQUIRED.
    [-d]            = Edit distance for clustering sequences. REQUIRED.
    [-f]            = Read filter. Only sequences with total reads greater than
                     the value supplied will be clustered.
    [-c]            = Maximum number of clusters to find.
    [-q]            = Quiet mode.  Suppresses standard output of file I/O, numb-
                      er of clusters, cluster size and execution time.
    [-v]            = Display version.
                      
--------------------------------------------------------------------------------

VI. FASTAptamer-Enrich

FASTAptamer-Enrich rapidly calculates "fold-enrichment" values for each sequence
across two or three input files.  Output is provided as a tab-delimited plain t-
ext file and is formatted to include sequence composition, length, rank, reads, 
reads per million (RPM), and enrichment values for each sequence. If any files 
from FASTAptamer-Cluster are provided, output will include cluster information 
for that population. A threshold filter can be applied to exclude sequences with
total reads per million (across all input populations) less than the number ent-
ered after the [-f] option.  Default behavior is to include all sequences. Enri-
chment is calculated by dividing reads per million of y/x (and z/y and z/x, if a 
third input file is specified).

Input for FASTAptamer-Enrich MUST come from FASTAptamer-Count or FASTAptamer-
Cluster output files.

Usage: fastaptamer_enrich [-h] [-x INFILE] [-y INFILE] [-z INFILE] [-o OUTFILE] 
                          [-f #] [-q] [-v]
    [-h]            = Help screen.
    [-x INFILE]     = First input file from FASTAptamer-Count or 
                      FASTAptamer-Cluster. REQUIRED.
    [-y INFILE]     = Second input file from FASTAptamer-Count or 
                      FASTAptamer-Cluster. REQUIRED. 
                      *** For two populations only, use -x and -y. ***
    [-z INFILE]     = Optional third input file from FASTAptamer-Count or 
    				  FASTAptamer-Cluster.
    [-o OUTFILE]    = Plain text output file with tab separated values. REQUIRED
    [-f]            = Optional reads per million threshold filter.  
    [-q]            = Quiet mode.  Suppresses standard output of file I/O, 
                      number of matched sequences and execution time.
    [-v]            = Display version.
                      
--------------------------------------------------------------------------------

VII. FASTAptamer-Search

FASTAptamer-Search allows users to search for specific patterns within one or m-
ore sequence files.

To search through more than one input file, simply use the [-i] flag multiple t-
imes. All input files must use FASTA format.

Similarly, to search for multiple patterns simultaneously, use the [-p] flag as 
many times as needed. When searching for multiple patterns, note that partial m-
atches are not returned. For example, entering the following command:

    fastaptamer_search -i FILE1 -i FILE2 -p ATTGCC -p TGGCAT

would search FILE1 and FILE2 for sequences containing both ATTGCC and TGGCAT.

Patterns and input sequence data are case insensitive, and T/U are interchangea-
ble. In addition to single bases, patterns can include any of the degenerate ba-
se symbols from IUPAC-IUBMB nucleic acid notation:

    A/T/G/C/U    single bases

    R    puRines (A/G)
    Y    pYrimidines (C/T)
    W    Weak (A/T)
    S    Strong (G/C)
    M    aMino (A/C)
    K    Keto (G/T)

    B    not A
    D    not C
    H    not G
    V    not T

    N    aNy base (not a gap)

For greater visibility, pattern matches can be highlighted by parentheses in the
output by calling the [-highlight] flag.

A summary report is generated after each file's search results and after search 
completion. To suppress these reports, enable quiet mode using the [-quiet] flag

Usage: fastaptamer_search [-i INFILE] [-o OUTFILE] [-p PATTERN] [-v]
    [-help]            	= Show help screen and exit.
    [-i FILENAME]     	= Input filename; can be used multiple times.
    [-p PATTERN]        = Sequence pattern to search for; can be used
                          multiple times.
    [-o FILENAME]   	= Output file for search results. 
                          If none given, output goes to STDOUT. 
    [-highlight]        = "Highlight" matched portion in parentheses.
    [-quiet]            = Suppress summary report.
    [-v]                = Display version.

--------------------------------------------------------------------------------

VIII. Version History

Version 1.0.8 - Released June 17th, 2015
Optional uniqueness labels now in format like ">1121(36)-Reads-RPM", where "36"
makes it unique. It was previously like ">1121-READS-RPM-36".

Version 1.0.7 - Released June 8th, 2015
Modified fastaptamer_compare to handle optional uniqueness labels in sequence I-
Ds. Added test for fastaptamer_compare.

Version 1.0.6 - Released June 8th, 2015.
Added the option to fastaptamer_count for generating unique IDs.
Modified fastaptamer_cluster to be able to read count files that contain unique
IDs

Version 1.0.5 - Released May 29th, 2015.
Fixed bug in fastapatmer_count that was sensitive to an at-sign (@) in quality 
header or as the last (or only) character of the sequence header.

Version 1.0.4 - Released March 10th, 2015.
fastaptamer_cluster should now be much more memory efficient.

Version 1.0.3 - Released March 3rd, 2015.
Added maximum number of clusters option [-c] to fastaptamer_cluster.

Version 1.0.2 - Released January 21st, 2015. 
Added FASTAptamer citation and license information to all scripts.  Improvements
to readability and consistency of code and STDOUT summary reports.

Version 1.0.1 - Released December 24th, 2014. 
Added version option [-v] to all scripts. Updated help screens. FASTAptamer-Clu-
ster's RPM filter [-f] is now a more intuitive read filter.

Version 1.0 - Released August 31st, 2014. 
Added FASTAptamer-Search.  Updated FASTAptamer-Cluster and FASTAptamer-Enrich to
include RPM filters. Built in cluster auto-detect to FASTAptamer-Enrich and sub-
sequently removed FASTAptamer-Cluster_enrich from toolkit. Included user's guide
as a PDF bundled with the download. Sample data made available.

Version 0.2.2 - Released May 5th, 2014.  Fixed a formatting error in FASTAptamer
-Cluster_enrich in which sequences present only in population x had their infor-
mation split across two lines. 

Version 0.2.1 - Released April 29th, 2014.  
Fixed formatting issue with FASTAptamer-Cluster_enrich where enrichment value of
(y/x) appeared under column for cluster (z) when three populations are used.

Version 0.2 - Released April 27th, 2014.  
Added FASTAptamer-Cluster and FASTAptamer-Cluster_enrich.  README document upda-
ted.  License included.

Version 0.1 - initial "beta."   Released April 11th, 2014.

--------------------------------------------------------------------------------

IX. License

FASTAptamer is distributed under the GNU General Public License version 3.
See file "LICENSE.txt" for more information and complete license.

--------------------------------------------------------------------------------

X. Miscellaneous

For help, comments, criticism, error reporting, etc. please contact 
burkelab@missouri.edu.  If you're on Twitter, reach out to us @BurkeLabRNA or c-
ontact the primary author of the toolkit, Khalid K. Alam @BiochemPhD.

"Fork" development of FASTAptamer on GitHub.
http://github.com/FASTAptamer/FASTAptamer

Funding for this work was provided by NSF [CHE-1057506] (Chemistry of Life Proc-
esses) & NASA [NAG5-12360] (NASA Exobiology Program).
