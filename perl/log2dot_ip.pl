#!/usr/bin/perl -w

use strict;
use warnings;

use Net::Subnet;

my %connections;
my %ip2name;

my $SRCip="";
my $DSTip="";
my $SRCprt="";
my $DSTprt="";
my $PROTO="";
my $Pin="";
my $Pout="";
my $MAC="";
my $count=0;
my $countmax=1;
my $countfact=0;
my $penw=0;
my $is_rfc1918 = subnet_matcher qw' 10.0.0.0/8 172.16.0.0/12 192.168.0.0/16 ';
my $broadcast = subnet_matcher qw' 10.0.0.255/32 224.0.0./4';
     
#my $filename = '/var/log/netvipi-eth0.log';
my $filename = $ARGV[0];
my $IPsearch = $ARGV[1];
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";
     
while (my $row = <$fh>) {
  chomp $row;
#  print "$row\n";
  if ($row =~ m/$ARGV[1]/) {
  if ($row =~m/\s+(\S+) (\S+);(\S+);(\S+);(\S+);(\S+);(\S+);(\S+);(\S+)/) {
    $count=$1;
    $SRCip=$2;
    $DSTip=$4;
    $SRCprt=$3;
    $DSTprt=$5;
    $PROTO=$6;
    $Pin=$7;
    $Pout=$8;
    $MAC=$9;
  }
#  print "---> $row\n";
#  if ($PROTO eq "TCP") {
#    if ($count >= $countmax) {
#      $countmax = $count;
#      $countfact = 10/$countmax;
#      print "$countmax:$countfact\n";  
#    }
#    if ( $is_rfc1918->($SRCip) ) {
      if (exists $ip2name{$SRCip}) {      
      } else {
        $ip2name{$SRCip} = "1";
      }
#    } elsif ( $broadcast->($SRCip) ) {
#      $SRCip="Broadcast";
#    } else {
#      $SRCip="Internet";
#      if (exists $ip2name{$SRCip}) {
#      } else {
#        $ip2name{$SRCip} = "1";
#      }
#    }
#    if ( $is_rfc1918->($DSTip) ) {
      if (exists $ip2name{$DSTip}) {      
      } else {
        $ip2name{$DSTip} = "1";
      }
#    } elsif ( $broadcast->($DSTip) ) {
#      $DSTip="Broadcast";
#    } else {
#      $DSTip="Internet";
#      $ip2name{$DSTip} = "1";
#      if (exists $ip2name{$DSTip}) {
#      } else {
#        $ip2name{$DSTip} = "1";
#      }
#    }
    if ($SRCprt>=1025) {
      $SRCprt=0;    
    }
    if ($DSTprt>=1025) {
      $DSTprt=0;    
    }
#    $penw = $count * $countfact;
#    if ($penw >=2) {
      my $key = "$SRCip;$DSTip;$SRCprt;$DSTprt;$PROTO";
      if (exists $connections{$key}) {
        $connections{$key} = $connections{$key} + $count;
        if ($connections{$key} >= $countmax) {$countmax = $connections{$key};}
#        print "$key -> $connections{$key}\n";
      } else {
        $connections{$key} = $count;
        if ($connections{$key} >= $countmax) {$countmax = $connections{$key};}
#        print "$key --> $connections{$key}\n";
      }
      
#      print "  \"$SRCip\" -> \"$DSTip\" [label=\"$SRCprt->$DSTprt\", penwidth=$penw];\n";
#    }
#  }
  }
}
#print "$countmax\n";
$countfact = 10/$countmax;
#print "$countmax $countfact\n";


#print "digraph g {\n  rankdir=\"LR\";\n";     
print "digraph html {\n  rankdir=\"LR\";\n";     

my @ips = keys %ip2name;
for my $ip2 (@ips) {
  my $name = `nslookup $ip2 | grep name`;
  chomp $name;
  if ($name =~m/name = (\S+)/) {
#    print "  \"$ip2\" [label=\"$ip2\\n$1\"];\n";
    print "  \"$ip2\" [URL=\"https://netvisualpi/index.php?section=ipanalyze-$ip2\", target=\"_parent\", label=\"$ip2\\n$1\"];\n";
  }
}

my @keys = keys %connections;
for my $key2 (@keys) {
  my $counts = $connections{$key2}*$countfact;
  if ($counts >= 0) {
    ($SRCip, $DSTip, $SRCprt, $DSTprt, $PROTO) = split /;/,$key2;
    if ($PROTO eq "TCP") {
      if ($DSTprt == "80") {
        print "  \"$SRCip\" -> \"$DSTip\" [label=\"$SRCprt->$DSTprt\n$connections{$key2}\", penwidth=$counts, color=\"red\"];\n";
      } else {
        print "  \"$SRCip\" -> \"$DSTip\" [label=\"$SRCprt->$DSTprt\n$connections{$key2}\", penwidth=$counts, color=\"blue\"];\n";
      }
    } else {
      print "  \"$SRCip\" -> \"$DSTip\" [label=\"$SRCprt->$DSTprt\n$connections{$key2}\", penwidth=$counts, color=\"lightgrey\"];\n";
    }
  }
}

print "}\n";
