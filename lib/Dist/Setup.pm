package Dist::Setup;

use strict;
use warnings;
use utf8;
use feature ':5.24';

use Eval::Safe;
use File::Basename 'basename', 'dirname';
use File::Copy;
use File::Find;
use File::Spec::Functions 'abs2rel', 'catfile';
use Template;

our $VERSION = '0.01';

my %conf;
my $tt;
my $tt_raw;
my $target_dir;

my $footer_marker = '# End of the template. You can add custom content below this line.';

sub setup {
  my ($data_dir, $target_dir_local) = @_;
  $target_dir = $target_dir_local;

  my $conf_file_name = 'dist_setup.conf';
  my $conf_file = catfile($target_dir, $conf_file_name);
  if (! -e $conf_file) {
    print STDERR "No ${conf_file_name} in target directory.\n";
    copy(catfile($data_dir, $conf_file_name), $conf_file) or die "Cannot copy ${conf_file_name}: $!";
    print STDERR "Created a new configuration file. Modify it then run this tool again.\n";
    exit 0;
  }

  my $eval = Eval::Safe->new();
  %conf = %{$eval->do($conf_file)} or die "Cannot parse the ${conf_file_name} configuration: $@";
  $eval->share('%conf');

  $conf{auto}{date}{year} = (localtime)[5] + 1900 ;
  $conf{dist_name} //= $conf{name} =~ s/::/-/gr;
  $conf{base_package} //= 'lib/'. ($conf{name} =~ s{::}{/}gr) .'.pm';
  $conf{footer_marker} = $footer_marker;

  $tt = Template->new({
    INCLUDE_PATH => $data_dir, 
    OUTPUT_PATH => $target_dir,
    ENCODING => 'utf8',
    PRE_PROCESS => 'tt_header',
    POST_PROCESS => 'tt_footer',
  });
  $tt_raw = Template->new({
    INCLUDE_PATH => $data_dir, 
    OUTPUT_PATH => $target_dir,
    ENCODING => 'utf8',
  });

  find({
    no_chdir => 1,
    wanted => sub {
      my $f = basename($_);
      print "Seeing $_\n";
      if ($f =~ m/^\./) {
        $File::Find::prune = 1;
        return;
      }
      my $cond_file = -d $_ ? catfile($_, '.cond') : $_ . '.cond';
      if (-f $cond_file) {
        print "Evaluating ${cond_file}\n";
        my $ret = $eval->do($cond_file);
        print "Result is: $ret\n";
        die "Cannot evaluate ${cond_file}: $@" if $@;
        die "Cannot read ${cond_file}: $!" if $!;
        unless ($ret) {
          $File::Find::prune = 1;
          print "Pruned $_\n";
          return;
        }
      }
      return if -d $_;
      die "Cannot read $_: $!" unless -r $_;
      return if $f eq 'dist_setup.conf';
      return if $f =~ m/^tt_/;

      my $src = abs2rel($_, $data_dir);
      $f =~ s/^dot_/./;
      my $out = catfile(dirname($src), $f);

      setup_file($src, $out);
    },
  }, $data_dir);
}

sub setup_file {
  my ($src_file, $target_file) = @_;
  my $footer = '';

  my $dest_tt;

  if ($src_file =~ m/\.raw$/) {
    $dest_tt = $tt_raw;
    $target_file =~ s/\.raw$//;
  } else {
    $dest_tt = $tt;
    my $dest_file = catfile($target_dir, $target_file);
    if (-e $dest_file) {
      open my $f, '<',  $dest_file;
      while (<$f>) {
        last if /^${footer_marker}$/m; 
      }
      $footer = join('', <$f>) unless eof($f);
      $footer =~ s/\n+$//;
      close $f;
    }
  }

  $dest_tt->process($src_file, { %conf, footer_content => $footer }, $target_file)
    or die "Cannot process template ${src_file}: ".$dest_tt->error()."\n";
}

1;
