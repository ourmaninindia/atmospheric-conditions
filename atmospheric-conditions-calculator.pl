#!/usr/bin/perl

use strict;
use warnings;

# Version: 	0.2
# Author; 	Daniel Tuinman  
# 		 	daniel@ourmaninindia.com
# Purpose:	Calculate temperature, pressure under various atmospheric conditions
#           or calculate density using a given temperature for an altitude below 11000 m

my $input = $ARGV[0] // 0;
my $unit  = $ARGV[1] // '';
   
my $T;
my $rho;
my $Tzero;
my $Hzero;
my $a='undefined';
my $Pzero;	
my $P;
my $altitude;

our $g = 9.80665;
our $R = 287;
our $e = 2.718281828459;

$unit = uc $unit;

if ($unit eq 'C' || $unit eq 'K') {
	my $temperature = ($unit eq 'C') ? $input + 273.15 : $input;
	
	$rho = 1.225 * ($temperature / 283.15)**($g/(0.0065*$R)-1); # Toussaint's equation

	print "Temperature used: $temperature K (". (($unit eq 'C') ? $input : $input - 273.15)."C) \n" ;
	print "Density (below 11000m) = $rho \n";
} 
elsif ($unit eq 'FT' || $unit eq 'M') {
	$unit 	  = lc $unit;
	$altitude = ($unit eq 'ft') ? ($input * 0.3040) : $input;

	if ($altitude < 11000) {
		$Tzero 		= 288.15;
		$Hzero 		= 0;
		$a 		    = -.0065;
		$Pzero 	    = 101325;
		$T 			= temperature($Tzero,$Hzero,$a);
		$P 			= pressure($Pzero,$Tzero,$a,$T);
		$rho 		= density($P,$T);
	} 
	elsif ($altitude < 20000) {
		$Tzero		= 216.65;
		$Hzero 		= 11000;
		$Pzero 		= 22625.79149;
		$T       	= $Tzero;
		$P 			= $Pzero * ($e**((-$g/($R*$T))*($altitude-$Hzero)));
		$rho 		= density($P,$T);
	} 
	elsif ($altitude < 32000) {
		$Tzero 		= 216.65;
		$Hzero 		= 20000;
		$a 			= .001;
		$Pzero 		= 5471.935072; 
		$T 			= temperature($Tzero,$Hzero,$a);
		$P 			= pressure($Pzero,$Tzero,$a,$T);
		$rho 		= density($P,$T);
	}
	elsif ($altitude < 47000) {
		$Tzero 		= 228.65;
		$Hzero 		= 32000;
		$a 			= .0028;
		$Pzero 		= 867.255; 
		$T 			= temperature($Tzero,$Hzero,$a);
		$P 			= pressure($Pzero,$Tzero,$a,$T);
		$rho 		= density($P,$T);
	}
	else {
		print "T, P and Rho are not calculated for altitudes for 47000m and above\n"; 
	};

	print "Variables used: Tzero=$Tzero, Hzero=$Hzero, a=$a altitude=$altitude m ".(($unit eq 'ft') ? " ($altitude $unit)" : '')." \n" ;
	print "Temperature = $T \n";
	print "Pressure    = $P \n";
	print "Density     = $rho \n";
} 
else {
	print "Use a parameter: m or ft for altitude or C or K for temperature \n";
}

sub temperature {
	my ($Tzero, $Hzero, $a)= @_;
	my $T = $Tzero + ($a * ($altitude - $Hzero));
	return $T;
}

sub pressure {
	my ($Pzero,$Tzero,$a,$T)=@_;
	my $P = $Pzero * (($T / $Tzero)**(-$g/($a*$R))) ;
	return $P;
}

sub density {
	my ($P,$T) = @_;
	my $rho = $P / ($R * $T);
	return $rho;
}

1;
