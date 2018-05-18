use strict;
use Test::More;

use XS::Logger;

is XS::Logger::sum( 1, 3 ), 4;
is XS::Logger::sum( "1", "2" ), 3;
is XS::Logger::sum( "4", 1 ), 5;

done_testing;
