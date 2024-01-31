#!/usr/bin/perl

use strict;
use warnings;
use Test2::V0;

our $VERSION = 0.01;

BEGIN {
  ok(eval 'use [% name %]; 1', 'use [% name %]');  ## no critic
}
{
  no warnings 'once';  ## no critic
  note("Testing [% name %] $[% name %]::VERSION, Perl $], $^X, $ENV{SHELL}");
}

done_testing;
