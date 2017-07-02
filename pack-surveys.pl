#! /usr/bin/env perl
use Perlmazing;
use strict;
use warnings;
use JSON qw( decode_json );
use Text::CSV;

my $surveys_dir = 'response';

my @surveys;
opendir(my $survey_dh, $surveys_dir);
while (my $node = readdir $survey_dh) {
  unless ($node =~ m/^\./) {
    push @surveys, decode_json slurp("$surveys_dir/$node");
    say $surveys[-1]{'camper-name'}, " -> $node";
  }
}

my $prefix = @ARGV ? shift(@ARGV) : die "prefix is required to specify structure file and output name!";

my $structure = decode_json( slurp("$prefix-survey.json") )->{'questions'};

#Table up our data

my @header;
foreach my $elem (@$structure) {
  push @header, $elem->{'question-text'};
}

my @rows = (\@header);

foreach my $survey (@surveys) {
  my @row;
  foreach my $key (map { $_->{'html-title'} } @$structure) {
    push @row,
    ref($survey->{$key}) eq 'ARRAY'
      ? join ", ", @{$survey->{$key}}
      : $survey->{$key};
  }
  push @rows, \@row;
}

#save as csv

my $csv = Text::CSV->new ( { binary => 1 } )  # should set binary attribute.
                or die "Cannot use CSV: " . Text::CSV->error_diag();
$csv->eol ("\r\n");

my $survey_out_name = "$prefix-surveys.csv";
open my $fh, ">:encoding(utf8)", $survey_out_name or die "$survey_out_name: $!";
$csv->print ($fh, $_) for @rows;
close $fh or die "$survey_out_name: $!";
