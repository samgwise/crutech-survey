#!/usr/bin/env perl6
use v6;
use JSON::Class;

class Question does JSON::Class {
  has Str $.html-title is required;
  has Str $.question-text is rw;
}

class Survey does JSON::Class {
  has Question @.questions handles <map push>;
}

sub MAIN(Str :$in is required, Str :$out is required) {
  my Survey $survey .= new;

  for $in.IO.slurp.comb( /name '=' '"' <( .+? )> '"'/ ).unique -> $match {
    $survey.push: Question.new( :html-title($match) );
  }
  say $survey.map( { .html-title }).join: "\n";

  spurt $out, $survey.to-json;
}
