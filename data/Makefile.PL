use [% min_perl_version %];
use strict;
use warnings;
use ExtUtils::MakeMaker::CPANfile;
[% IF data_dir %]use File::ShareDir::Install;

install_share '[% data_dir %]';[% END %]

WriteMakefile(
    NAME             => '[% name %]',
    DISTNAME         => '[% dist_name %]',
    AUTHOR           => q{[% author.name %] <[% author.email %]>},
    VERSION_FROM     => '[% base_package %]',
    [% IF abstract %]ABSTRACT         => q{[% abstract %]},[% END %]
    LICENSE          => 'mit',
    [% IF exe_files %]EXE_FILES        => [[% FOREACH f IN exe_files %]'[% f %]',[% END %]],[% END %]
    MIN_PERL_VERSION => '[% min_perl_version %]',
    MAN3PODS         => {},
    # Directories in which we look for Makefile.PL. In general could be omitted but is needed in case there
    # is a file named Makefile.PL in a sub-directory. Should be customized if such a file needs to be
    # processed by ExtUtils.
    DIR              => [],
    NO_MYMETA => 1,
    META_MERGE => {
      'meta-spec' => { version => 2 },
      # Goes with NO_MYMETA (which would provide the dynamic config).
      dynamic_config => 0,
      no_index => {
        directory => [ 'local', 'vendor' ],
      },
      [% IF github %]resources => {
        repository => {
          type => 'git',
          url => 'git@github.com:[% github.username %]/[% github.repository_name %].git',
          web => 'https://github.com/[% github.username %]/[% github.repository_name %]',
        },
        bugtracker => {
          web => 'https://github.com/[% github.username %]/[% github.repository_name %]/issues',
        },
      },[% END %]
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => '.gz', },
    clean => { FILES => '[% dist_name %]-*' },
);

[% IF data_dir %]package MY;
use File::ShareDir::Install qw(postamble);[% END %]
