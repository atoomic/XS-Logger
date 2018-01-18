#!/bin/env perl

# compile.t
#
# Ensure the module compiles.

use strict;
use warnings;

use Test2::Bundle::Extended;
use Test2::Tools::Explain;
use Test2::Plugin::NoWarnings;

# make sure the module compiles
ok eval { require XS::Logger; 1 }, "load XS::Logger" or diag $@;

done_testing;
