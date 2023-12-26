use 5.026;
use strict;
use warnings;
use ExtUtils::MakeMaker;
use File::ShareDir::Install;

install_share 'data';

WriteMakefile(
    NAME             => 'Dist::Setup',
    DIR              => [],  # Directories in which we look for Makefile.PL. Need to be specified so that "data" is ignored.
    AUTHOR           => q{Mathias Kende <mathias@cpan.org>},
    VERSION_FROM     => 'lib/Dist/Setup.pm',
    ABSTRACT         => 'Simple tool to setup a distribution directory.',
    LICENSE          => 'mit',
    EXE_FILES        => ['script/perl_dist_setup'],
    MIN_PERL_VERSION => '5.026',
    MAN3PODS         => {},
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker'     => '0',
        'Eval::Safe'              => '0',
        'File::ShareDir'          => '0',
        'Template'                => '0',
    },
    NO_MYMETA => 1,
    META_MERGE => {
      'meta-spec' => { version => 2 },
      # Goes with NO_MYMETA (which would provide the dynamic config).
      dynamic_config => 0,
      no_index => {
        directory => [ 'local', 'vendor' ],
      },
      resources => {
        repository => {
          type => 'git',
          url => 'git@github.com:mkende/dist_setup.git',
          web => 'https://github.com/mkende/dist_setup',
        },
        bugtracker => {
          web => 'https://github.com/mkende/dist_setup/issues',
        },
      },
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => '.gz', },
    clean => { FILES => 'Dist-Setup-*' },
);

package MY;
use File::ShareDir::Install qw(postamble);
