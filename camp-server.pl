#! /usr/bin/env perl
use v5.16;
use strict;
use warnings;
use Mojolicious::Lite;
use Mojo::JSON qw(decode_json encode_json);
use English;
use Perlmazing;

my $surveys_dir = "response";
my $counter = 0;

my @surveys;
opendir(my $survey_dh, $surveys_dir);
while (my $node = readdir $survey_dh) {
  push @surveys, decode_json slurp("$surveys_dir/$node") unless $node =~ m/^\./;
}

say 'Loaded ' . scalar(@surveys) . ' surveys.';

get '/css/master' => {template => 'css/master', format => 'css',};

get '/survey' => sub {
  my $c = shift;

  $c->render(template => 'main')
};

post '/submit' => sub {
  my $c = shift;
  open(
    my $out_fh,
    ">",
    "$surveys_dir/" . $PID . "-" . time . ".json"
  ) or warn "Unable to open file for write: $!";
  print $out_fh encode_json($c->req->body_params->to_hash);
  close $out_fh;

  $c->render(template => 'submit')
};

get "/response/:index" => sub {
  my $c = shift;
  my $index = $c->stash('index');
  $index = ($index > 0 and $index < scalar @surveys) ? $index : 0;
  $c->stash(response => $surveys[$index]);

  $c->render(template => 'view-response');
};

get "/summarise" => sub {
  my $c = shift;

  $c->render(text => join "\n", map {
    join ", ", (
      $_->{'camper-name'},
      $_->{'note-for'},
      '[', $_->{'note-content'}, ']'
    )
  } @surveys)
};

get "/" => sub {
  my $c = shift;
  $c->stash(surveys => \@surveys);
  $c->render(template => 'index')
};

app->start;
