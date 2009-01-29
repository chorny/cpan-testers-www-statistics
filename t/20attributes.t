#!perl

use strict;
use warnings;

use Test::More tests => 25;
use CPAN::Testers::WWW::Statistics;

use lib 't';
use CTWS_Testing;

ok( my $obj = CTWS_Testing::getObj(), "got object" );

# test the attributes generated by Class::Accessor::Chained::Fast

# predefined attributes
foreach my $k ( qw/
	directory
	database
	templates
    address
    logclean
/ ){
  my $label = "[$k]";
  SKIP: {
    ok( $obj->can($k), "$label can" )
	or skip "'$k' attribute missing", 3;
    isnt( $obj->$k(), undef, "$label has default" );
    is( $obj->$k(123), $obj, "$label set" ); # chained, so returns object, not value.
    is( $obj->$k, 123, "$label get" );
  };
}

# undefined attributes
foreach my $k ( qw/
    logfile
/ ){
  my $label = "[$k]";
  SKIP: {
    ok( $obj->can($k), "$label can" )
	or skip "'$k' attribute missing", 3;
    is( $obj->$k(), undef, "$label has no default" );
    is( $obj->$k(123), $obj, "$label set" ); # chained, so returns object, not value.
    is( $obj->$k, 123, "$label get" );
  };
}
