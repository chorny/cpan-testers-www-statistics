#!/usr/bin/perl -w
use strict;

use File::Path;
use File::Slurp;
use Test::More tests => 22;

use lib 't';
use CTWS_Testing;

my $LOG = '50logging.log';

unlink($LOG) if(-f $LOG);

{
    ok( my $obj = CTWS_Testing::getObj(config => 't/50logging.ini'), "got object" );

    is($obj->logfile, $LOG, 'logfile default set');
    is($obj->logclean, 0, 'logclean default set');

    $obj->_log("Hello");
    $obj->_log("Goodbye");

    ok( -f $LOG, '50logging.log created in current dir' );

    my @log = read_file($LOG);
    chomp @log;

    is(scalar(@log),12, 'log written');
    like($log[10], qr!\d{4}/\d\d/\d\d \d\d:\d\d:\d\d Hello!,   'line 1 of log');
    like($log[11], qr!\d{4}/\d\d/\d\d \d\d:\d\d:\d\d Goodbye!, 'line 2 of log');
}

{
    ok( my $obj = CTWS_Testing::getObj(config => 't/50logging.ini'), "got object" );

    is($obj->logfile, $LOG, 'logfile default set');
    is($obj->logclean, 0, 'logclean default set');

    $obj->_log("Back Again");

    ok( -f $LOG, '50logging.log created in current dir' );

    my @log = read_file($LOG);
    chomp @log;

    is(scalar(@log),23, 'log extended');
    like($log[10], qr!\d{4}/\d\d/\d\d \d\d:\d\d:\d\d Hello!,      'line 1 of log');
    like($log[11], qr!\d{4}/\d\d/\d\d \d\d:\d\d:\d\d Goodbye!,    'line 2 of log');
    like($log[22], qr!\d{4}/\d\d/\d\d \d\d:\d\d:\d\d Back Again!, 'line 3 of log');
}

{
    ok( my $obj = CTWS_Testing::getObj(config => 't/50logging.ini'), "got object" );

    is($obj->logfile, $LOG, 'logfile default set');
    is($obj->logclean, 0, 'logclean default set');
    $obj->logclean(1);
    is($obj->logclean, 1, 'logclean reset');

    $obj->_log("Start Again");

    ok( -f $LOG, '50logging.log created in current dir' );

    my @log = read_file($LOG);
    chomp @log;

    is(scalar(@log),1, 'log overwritten');
    like($log[0], qr!\d{4}/\d\d/\d\d \d\d:\d\d:\d\d Start Again!, 'line 1 of log');
}

unlink($LOG);
