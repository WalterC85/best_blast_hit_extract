#!/Users/walter/miniconda2/bin/perl

## Reading INPUT file 

use Array::Utils qw(:all);  ## loading this utility to be albe to compare different arrays

if (!$ARGV[0]) {
  print "insert input name:\n";
   $file=<STDIN>;
    chomp $file;
} else {              
  $file=$ARGV[0];
}
print "Reading file $file\n";
open (input,$file);
open (output, ">$file"."best_hits.txt");
my $count = `wc -l $file`;  ###here i am reading the lines in the file to know when is the last line
#($count2, @rest)=split(/\s/,$count);
#print "$count\n";
my $query_prec;
my $pident_prec;
my $line_prec;
$mark=0;
$mark_tot=0;
while (<input>){
  chomp;
  $mark_tot++;
  ($query, $xx, $sub, $qlen, $slen, $pident, @rest)=split(/\t/,$_);
  if ($mark == 0){ #Creating the variables with the very first line
    $query_prec = $query; 
    $pident_prec = $pident;
    $line_prec = $_;
    }
  if (($query eq $query_prec) && ($pident > $pident_prec)){ # If is not the first line do the comparisons with the line before
    $query_prec = $query;
    $pident_prec = $pident;
    $line_prec = $_;
    }
  if ($query ne $query_prec){ # if the actual query is not the same as the one before means that we started a new query seqs so this is the very first of a new group. 
    #print "$query\n";                        #Then i need to put to 0 the counter and store this very first line in the variables. Before this i print the best hit of the previous seqs block
    print output "$line_prec\n";
    $mark=0;
    $query_prec = $query; 
    $pident_prec = $pident;
    $line_prec = $_;
    }
    #if ($count =~ $mark_tot){  # THE CASE WHEN IS THE LAST LINE!
    #print output "$line_prec\n";  
    #}
  $mark++;
}
print output "$line_prec";
close output;
close input;


