
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  "build_requires" => {
    "Module::Build" => "0.3601"
  },
  "configure_requires" => {
    "Module::Build" => "0.3601"
  },
  "dist_abstract" => "Make your Moo-based object constructors blow up on unknown attributes.",
  "dist_author" => [
    "George Hartzell <hartzell\@cpan.org>"
  ],
  "dist_name" => "MooX-StrictConstructor",
  "dist_version" => "0.006",
  "license" => "perl",
  "module_name" => "MooX::StrictConstructor",
  "recommends" => {},
  "recursive_test_files" => 1,
  "requires" => {
    "B" => 0,
    "Class::Method::Modifiers" => 0,
    "Moo" => "1.001000",
    "Moo::Role" => 0,
    "constant" => 0,
    "perl" => "5.006",
    "strictures" => 1
  },
  "script_files" => [],
  "test_requires" => {
    "File::Find" => 0,
    "File::Temp" => 0,
    "Test::Fatal" => 0,
    "Test::More" => "0.88",
    "bareword::filehandles" => 0,
    "indirect" => 0,
    "multidimensional" => 0,
    "strict" => 0,
    "warnings" => 0
  }
);


unless ( eval { Module::Build->VERSION(0.4004) } ) {
  my $tr = delete $module_build_args{test_requires};
  my $br = $module_build_args{build_requires};
  for my $mod ( keys %$tr ) {
    if ( exists $br->{$mod} ) {
      $br->{$mod} = $tr->{$mod} if $tr->{$mod} > $br->{$mod};
    }
    else {
      $br->{$mod} = $tr->{$mod};
    }
  }
}

my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
