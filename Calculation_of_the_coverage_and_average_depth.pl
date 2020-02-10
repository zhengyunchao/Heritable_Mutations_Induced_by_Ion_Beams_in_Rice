use strict;
use warnings;
use Getopt::Long; 

sub prtHelp {
        print "\n$0 options:\n\n";
        print "--------------------------------- Path To SAMtools ---------------------------------\n";
        print "  -s | -pathToSamtools <Path To SAMtools>\n";
        print "----------------------------------- Input Options ----------------------------------\n";
        print "  -i | -inputFile <Input file>\n";
        print "    Sorted BAM file as input file\n";
        print "  -g | -genomeSize <Genome size>\n";
        print "---------------------------------- Output Options ----------------------------------\n";
        print "  -o | -outputFolder <Output folder name/path>\n";
        print "    Output folder should be created if not existing before processing\n";
        print "  -p | -prefixOfOutputFile <Prefix of output file name>\n";
        print "----------------------------------- Other Options ----------------------------------\n";
        print "  -h | -help\n";
        print "    Prints this help\n";
        print "\n";
}

sub prtUsage {
        print "\nUsage: perl $0 <options>\n";
        prtHelp();
}

my $samtools_path = "";
my $inputFileName = "";
my $genome_size = 0;
my $outFolder = "";
my $prefix = "";
my $helpAsked;

GetOptions(
                        "s|pathToSamtools=s" => \$samtools_path,
                        "i|inputFile=s" => \$inputFileName,
                        "g|genomeSize=i" => \$genome_size,
                        "o|outputFolder=s" => \$outFolder,
                        "p|prefixOfOutputFile=s" => \$prefix,
                        "h|help" => \$helpAsked,
                  ) or die $!;

if ($samtools_path && $inputFileName && $genome_size && $outFolder && $prefix){
        print "Options received\n";
} else {
        prtHelp();
        exit;
}

if($helpAsked) {
        prtUsage();
        exit;
}

my $average_depth = 0;
my $coverage = 0;

my $depth_file = $prefix.'.depth';
system(qq($samtools_path depth $inputFileName > $outFolder/$depth_file));

my $average_depth_file = $prefix.'.average_depth';

open IN, "$outFolder/$depth_file";
open OUT, ">$outFolder/$average_depth_file";
my $lines = 0;
my $bases = 0;
while(<IN>){
  chomp;
  $lines++;
  if(/(.+)\t(.+)/){
  $bases += $2;
  }
}
$average_depth = $bases/$genome_size;
$coverage = $lines/$genome_size;
print OUT "$inputFileName\tCoverage: $coverage\n";
print OUT "$inputFileName\tAverage depth: $average_depth\n";
