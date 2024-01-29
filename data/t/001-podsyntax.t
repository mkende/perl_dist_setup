#!/usr/bin/perl

use strict;
use warnings;

use English;
use FindBin;
use Test2::V0;

BEGIN {
  if (not $ENV{EXTENDED_TESTING}) {
    skip_all('Extended test. Set $ENV{EXTENDED_TESTING} to a true value to run.');
  }
}

# Ensure a recent version of Test::Pod is present
BEGIN {
  my $test_pod_version = 1.22;
  eval "use Test::Pod $test_pod_version";
  if ($EVAL_ERROR) {
    skip_all("Test::Pod $test_pod_version required for testing POD");
  }
}

my @dirs;
sub add_if_exists {
  return push @dirs, $_[0] if -d $_[0];
}

if (!add_if_exists("${FindBin::Bin}/../blib")) {
  add_if_exists("${FindBin::Bin}/../lib")
}
add_if_exists("${FindBin::Bin}/../script");
my @files = all_pod_files(@dirs);
my $nb_files = @files;
diag("Testing $nb_files POD files.");

all_pod_files_ok(@files);
