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
my $countmax=0;
my $countfact=0;
my $penw=0;
my $is_rfc1918 = subnet_matcher qw' 10.0.0.0/8 172.16.0.0/12 192.168.0.0/16 ';
my $broadcast = subnet_matcher qw' 255.255.255.255/32 224.0.0.0/4 ';
     
#my $filename = '/var/log/netvipi-eth0.log';
my $filename = $ARGV[0];
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";
     
while (my $row = <$fh>) {
  chomp $row;
#  print "$row\n";
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
#  if ($PROTO eq "TCP") {
#    if ($count >= $countmax) {
#      $countmax = $count;
#      $countfact = 10/$countmax;
#      print "$countmax:$countfact\n";  
#    }
    if ( $is_rfc1918->($SRCip) ) {
      if (exists $ip2name{$SRCip}) {      
      } else {
        $ip2name{$SRCip} = "1";
      }
    } elsif ( $broadcast->($SRCip) ) {
      $SRCip="Broadcast";
    } elsif ( $SRCip eq "224.0.0.251") {
      $SRCip="MDNS";
    } elsif ( $SRCip eq "0.0.0.0") {
      $SRCip="0.0.0.0";
    } else {
      $SRCip="Internet";
    }
    if ( $is_rfc1918->($DSTip) ) {
      if (exists $ip2name{$DSTip}) {      
      } else {
        $ip2name{$DSTip} = "1";
      }
    } elsif ( $broadcast->($DSTip) ) {
      $DSTip="Broadcast";
    } elsif ( $DSTip eq "224.0.0.251") {
      $DSTip="MDNS";
    } elsif ( $DSTip eq "0.0.0.0") {
      $DSTip="0.0.0.0";
    } else {
      $DSTip="Internet";
    }
    if ($SRCprt==5353) {
      $SRCprt=5353;
    } elsif ($SRCprt==6771) {
      $SRCprt=6771;
    } elsif ($SRCprt>=1025) {
      $SRCprt=0;    
    }
    if ($DSTprt==5353) {
      $DSTprt=5353;
    } elsif ($DSTprt==6771) {
      $DSTprt=6771;
    } elsif ($DSTprt>=1025) {
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
#print "$countmax\n";
$countfact = 10/$countmax;
#print "$countmax $countfact\n";


#print "digraph g {\n  graph[ splines=polyline; rankdir=\"LR\" ];\n";     
print "digraph html {\n  rankdir=\"LR\";\n  labelloc=\"t\";\n label=\"$filename\";\n \"Internet\" [style=filled, fillcolor=lightblue];\n \"Broadcast\" [style=filled, fillcolor=purple];\n";     

my @ips = keys %ip2name;
for my $ip2 (@ips) {
  my $name = `nslookup $ip2 | grep name`;
  chomp $name;
  if ($name =~m/name = (\S+)/) {
#    print "  \"$ip2\" [label=\"$ip2\\n$1\"];\n";
    print "  \"$ip2\" [URL=\"index.php?section=ipanalyze-$ip2\",target=\"_parent\", label=\"$ip2\\n$1\", shape=box, style=filled, fillcolor=lightgrey];\n";
  }
}

my @keys = keys %connections;
for my $key2 (@keys) {
  my $counts = $connections{$key2}*$countfact;
  if ($counts >= 0.1) {
    ($SRCip, $DSTip, $SRCprt, $DSTprt, $PROTO) = split /;/,$key2;
    if ($PROTO eq "TCP") {
      if ($DSTprt == "80") {
        print "  \"$SRCip\" -> \"$DSTip\" [label=\"$SRCprt->$DSTprt\n$connections{$key2}\", penwidth=$counts, color=\"red\"];\n";
      } elsif ($DSTprt == "443") {
        print "  \"$SRCip\" -> \"$DSTip\" [label=\"$SRCprt->$DSTprt\n$connections{$key2}\", penwidth=$counts, color=\"green\"];\n";
      } else {
        print "  \"$SRCip\" -> \"$DSTip\" [label=\"$SRCprt->$DSTprt\n$connections{$key2}\", penwidth=$counts, color=\"blue\"];\n";
      }
    } else {
      if ($DSTprt == "6771") {
        print "  \"$SRCip\" -> \"$DSTip\" [label=\"$SRCprt->$DSTprt\n$connections{$key2}\", penwidth=$counts, color=\"red\"];\n";
      } else {
        print "  \"$SRCip\" -> \"$DSTip\" [label=\"$SRCprt->$DSTprt\n$connections{$key2}\", penwidth=$counts, color=\"lightgrey\"];\n";
      }
    }
  }
}

print "}\n";
