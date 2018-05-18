#define PERL_EXT_XS_LOG 1

#include <EXTERN.h>    // define thread context if necessary (faster)
#include <perl.h>      // Perl symbols, structures and constants definition
#include <XSUB.h>      // Perl API - xsub functions & macros

// load here any C library you want
#include <stdlib.h>
#include <unistd.h>
// ...

// your own .h file or add your declaration directly there
#include "logger.h"

/* function exposed to the module */
/* maybe a bad idea to use a prefix */
MODULE = XS__Logger    PACKAGE = XS::Logger PREFIX = xlog_

SV*
xlog_sum(a, b)
    SV* a;
    SV* b;
CODE:
{
		int sum = SvIV(a) + SvIV(b);
	    
	    RETVAL = newSViv(sum);
}
OUTPUT:
	RETVAL
