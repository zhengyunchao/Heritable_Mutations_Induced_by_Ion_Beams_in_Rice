use strict;
use warnings;
use Getopt::Long; 

sub prtHelp {
        print "\n$0 options:\n\n";
        print "  -i | -inputFile <Input file>\n";
        print "    File format is GATK VCF\n";
        print "  -p | -prefixOfOutputFile <Prefix of output file>\n";
        print "  -o | -outputFolder <Output folder name/path>\n";
        print "    Output folder should be created if not existing before processing\n";
        print "  -h | -help\n";
        print "    Prints this help\n";
        print "\n";
}

sub prtUsage {
        print "\nUsage: perl $0 <options>\n";
        prtHelp();
}

my $inputFileName = "";
my $prefix= "";
my $outFolder = "";
my $helpAsked;

GetOptions(
                        "i|inputFile=s" => \$inputFileName,
                        "p|prefixOfOutputFile=s" => \$prefix,
                        "o|outputFolder=s" => \$outFolder,
                        "h|help" => \$helpAsked,
                  ) or die $!;

if ($inputFileName && $prefix && $outFolder){
        print "Options received\n";
} else {
        prtHelp();
        exit;
}

if($helpAsked) {
        prtUsage();
        exit;
}

my $outputFileName=$prefix."_filtered.vcf";
open(IN,"$inputFileName");
open(OUT,">$outFolder/$outputFileName");
while(<IN>)
{       if($_=~/#/){print OUT $_;next;}
        chomp;
        my $info=(split("\t",$_))[9];
        my $allele=(split(":",$info))[1];
        my @allele_depth=split(",",$allele);
        my $total_depth=0;
        my $num=0;
        foreach $num (@allele_depth)
          {
          	$total_depth=$total_depth+$num;
          	}
        
        my $allele_freq=int($total_depth-$allele_depth[0])/int($total_depth);

        if($total_depth>=10 && $total_depth<=100 && $allele_freq>=0.25)
          {
             print OUT $_,"\n"; 
           }
      }
