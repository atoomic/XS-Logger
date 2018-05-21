#!/bin/env perl

# compile.t
#
# Ensure the module compiles.

use strict;
use warnings;

use Test2::Bundle::Extended;
use Test2::Tools::Explain;
use Test2::Plugin::NoWarnings;

use XS::Logger;

my $logger;
{
	$logger = XS::Logger->new();
	isa_ok $logger, 'XS::Logger';
	is $logger->get_pid(),   0, "get_pid = 0 by default";
	is $logger->use_color(), 1, "use_color = 1 by default";
	
	undef $logger;    # trigger destroy	
	is $logger, undef;
}


{
	$logger = XS::Logger->new( { color => 0 } );
	isa_ok $logger, 'XS::Logger';
	is $logger->use_color(), 0, "use_color = 0";		
}


$logger = XS::Logger->new();
# we need some accessors/getters
is $logger->use_color, 1;
is $logger->quiet, 0;

# need to adjust new logic
$logger = XS::Logger->new( { color => 0, quiet => 1 } );
is $logger->use_color, 0;
is $logger->quiet, 1;

$logger->set_quiet(0);
is $logger->quiet, 0;

is XS::Logger::_loaded, 1, "_loaded";

is XS::Logger::DEBUG_LOG_LEVEL, 0, "DEBUG_LOG_LEVEL";
is XS::Logger::INFO_LOG_LEVEL, 1, "INFO_LOG_LEVEL";
is XS::Logger::WARN_LOG_LEVEL, 2, "WARN_LOG_LEVEL";


use XS::Logger;


is $XS::Logger::PATH_FILE, "/var/log/xslogger.log";

my $logger1 = XS::Logger->new( );
is $logger1->logfile, '/var/log/xslogger.log';

my $logger2 = XS::Logger->new( { logfile => q[/there] } );
is $logger2->logfile, '/there';

is $logger1->logfile, '/var/log/xslogger.log';



# # avoid using harcoded value
# $logger = XS::Logger->new( { level => 1 } );

# # avoid duplicate definition
# package XS::Logger;

# our $DEBUG_LOG_LEVEL = 0;
# our $INFO_LOG_LEVEL  = 1;

# package main;

# $logger = XS::Logger->new( { level => $XS::Logger::INFO_LOG_LEVEL } );



# $logger = XS::Logger->new( { level => XS::Logger::INFO_LOG_LEVEL } );


done_testing;




__END__

# is $logger->get_pid(),   0, "get_pid = 0 by default";
# is $logger->use_color(), 1, "use_color = 1 by default";

# undef $logger;    # trigger destroy
# is $logger, undef;
# $logger = XS::Logger->new( { color => 0 } );
# isa_ok $logger, 'XS::Logger';
# is $logger->use_color(), 0, "use_color = 0";
