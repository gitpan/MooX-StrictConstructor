
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  "build_requires" => {
    "File::Find" => 0,
    "File::Temp" => 0,
    "Module::Build" => "0.3601",
    "Test::Fatal" => 0,
    "Test::More" => "0.88",
    "bareword::filehandles" => 0,
    "indirect" => 0,
    "multidimensional" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "configure_requires" => {
    "Module::Build" => "0.3601"
  },
  "dist_abstract" => "Make your Moo-based object constructors blow up on unknown attributes.",
  "dist_author" => [
    "George Hartzell <hartzell\@cpan.org>"
  ],
  "dist_name" => "MooX-StrictConstructor",
  "dist_version" => "0.001",
  "license" => "restrictive",
  "module_name" => "MooX::StrictConstructor",
  "recommends" => {},
  "recursive_test_files" => 1,
  "requires" => {
    "B" => 0,
    "Moo" => 0,
    "Moo::Role" => 0,
    "perl" => "5.006",
    "strictures" => 1
  },
  "script_files" => []
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
