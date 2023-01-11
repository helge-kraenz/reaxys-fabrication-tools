#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my $IndiTab = "../tab";

my $ErrorTests =
{
  "config/zwf-replace-config-00.xml" => "FATAL - No config file found or config file is empty.",
  "config/zwf-replace-config-01.xml" => "FATAL - No config file found or config file is empty.",
  "config/zwf-replace-config-02.xml" => "FATAL - Field definition #1 has no name.",
  "config/zwf-replace-config-03.xml" => "FATAL - No rules for field f1 found.",
  "config/zwf-replace-config-04.xml" => "FATAL - Field f1 defined twice.",
  "config/zwf-replace-config-05.xml" => "FATAL - Rule definition #1 has no id.",
  "config/zwf-replace-config-06.xml" => "FATAL - Rule r1 of field f2 applied twice.",
  "config/zwf-replace-config-07.xml" => "FATAL - No nodes matching /config/fields/field found.",
  "config/zwf-replace-config-08.xml" => "FATAL - Rule r1 not found in rule definition.",
  "config/zwf-replace-config-09.xml" => "FATAL - Rule definition #1 has no name.",
  "config/zwf-replace-config-10.xml" => "FATAL - Rule r1 has no replace.",
  "config/zwf-replace-config-11.xml" => "FATAL - Rule r1 has no regex.",
};

my $Errors = 0;

$Errors = $Errors + processErrorTests( $ErrorTests );

$Errors = $Errors + simpleTest();
$Errors = $Errors + complexTest();

if( $Errors )
{
  print "Found $Errors errors in total.\n";
}
else
{
  print "Found no errors.\n";
}

exit $Errors;

sub complexTest
{
  my $Temp = "temp";
  my $File1 = "in/fct.in";
  my $File2 = "$Temp/fct1.in";
  my $File3 = "$Temp/fct2.in";

  `mkdir -p $Temp`;

  # Replace characters with placeholders
  my $Command1 = "INDITAB=$IndiTab zwf-replace -c config/config1.xml $File1 -o $File2";
  system( $Command1 );

  # Translate placeholders back to characters
  my $Command2 = "INDITAB=$IndiTab zwf-replace -c config/config2.xml $File2 -o $File3";
  system( $Command2 );

  # Compare original file with translated file
  my $Command3 = "cmp $File1 $File3";
  system( $Command3 );
  my $Rv = $?>>8;
  if( $Rv != 0 )
  {
    print "Test of $File1 failed.\n";
    return 1;
  }

  print "Test of $File1 succeeded.\n";

  return 0;
}

sub simpleTest
{
  my $File = "in/cit.in";

  # This dumps the original file and extracts R1N field and cuts off
  # after the 7th bytes. This should result in "R1N2022"
  my $Command1 = "zwf-dump $File | grep R1N | cut -b 1-7 | sort -u";
  chomp( my $Result1 = `$Command1` );

  # This applies the replacements as defined in config file, then
  # dumps the file and extracts R1N field and cuts off
  # after the 7th bytes. This should result in "R1N1999"
  my $Command2 = "INDITAB=$IndiTab zwf-replace -c config/config.xml $File  2>/dev/null | zwf-dump | grep R1N | cut -b 1-7 | sort -u";
  chomp( my $Result2 = `$Command2` );

  if( $Result1 ne "R1N2022" )
  {
    print "Test of $File failed:\n";
    print "Expected: >R1N2022<\n";
    print "Got:      >$$Result1<\n";
    return 1;
  }
  if( $Result2 ne "R1N1999" )
  {
    print "Test of $File failed:\n";
    print "Expected: >R1N1999<\n";
    print "Got:      >$$Result2<\n";
    return 1;
  }

  print "Test of $File succeeded.\n";

  return 0;
}

sub processErrorTests
{
  my $ErrorTests = shift;

  my $Errors = 0;

  for my $File ( sort keys %$ErrorTests )
  {
    next if ! $File;
    my $Message = $ErrorTests->{$File};
    next if ! $Message;
    $Errors = $Errors + processErrorTest( $File , $Message );
  }

  $Errors;
}

sub processErrorTest
{
  my $File    = shift;
  my $Message = shift;

  my $Command = "INDITAB=$IndiTab zwf-replace -c $File 2>/dev/null";
  chomp( my $Result = `$Command` );

  my $Error = ( $Message =~ /^$Result$/ms );

  if( $Error )
  {
    print "Test of $File failed:\n";
    print "Expected: >$Message<\n";
    print "Got:      >$Result<\n";
  }
  else
  {
    print "Test of $File succeeded.\n";
  }

  $Error;
}
