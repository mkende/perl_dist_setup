# perl_dist_setup

A simple, opinionated tool to set up a Perl distribution directory.

## Features

This tool allows to automatically set-up and keep up-to-date the directory of a
Perl distribution. Among others it supports the following features:

-   Custom `make` targets for `perlcritic`, `perltidy`, test code coverage,
    automatic upload to CPAN, and more.
-   Setup for GitHub continuous integration tests and GitHub codespaces.
-   State-of-the-art distribution setup, with `cpanfile`, proper `MANIFEST.skip`
    file, etc. and tests for all these files.
-   Spell-checking of the distribution.
-   And more...

## Installation

Install the tool from CPAN, 

```
cpanm Dist::Setup
```

## Usage

For the usage description, please refer to the
[perl_dist_setup](https://metacpan.org/pod/perl_dist_setup) documentation on
metacpan.
