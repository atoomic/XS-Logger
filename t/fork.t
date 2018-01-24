#!/bin/env perl

use strict;
use warnings;

use Test2::Bundle::Extended;
use Test2::Tools::Explain;
use Test2::Plugin::NoWarnings;

use XS::Logger;

use File::Temp;

use FindBin;
use lib "$FindBin::Bin/lib";

use Test::XSLogger qw{:all};

$| = 1;

my $tmp = File::Temp->newdir( 'DIR' => '/tmp', 'TEMPLATE' => 'xslogger-test.XXXXX' );

{
    my $logfile = $tmp->dirname() . '/a-file.log';

    my $logger = XS::Logger->new( { path => $logfile, quiet => 1 } );
    ok !-e $logfile;

    $logger->info("1. before fork...");

    is count_lines($logfile), 1;

    if ( my $pid = fork() ) {
        waitpid( $pid, 0 );
        is count_lines($logfile), 2;
        $logger->info("3. back to parent");
    }
    else {
        $logger->info("2. from kid");
        exit;
    }

    is count_lines($logfile), 3, "three lines logged";
}

done_testing;
