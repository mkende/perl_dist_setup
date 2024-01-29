#!/usr/bin/perl

use strict;
use warnings;
use Test2::V0;

BEGIN {
  ok(eval "use [% name %]; 1", "use [% name %]");
}
{
  no warnings 'once';
  note("Testing [% name %] $[% name %]::VERSION, Perl $], $^X, $ENV{SHELL}");
}

done_testing;
