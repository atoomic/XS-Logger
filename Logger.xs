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
/* https://www.lemoda.net/perl/perl-xs-object/index.html */

MODULE = XS__Logger    PACKAGE = XS::Logger PREFIX = xlog_

TYPEMAP: <<HERE

MyLogger*  T_PTROBJ
XS::Logger T_PTROBJ

HERE

XS::Logger
xlog_new(class)
    char* class;
PREINIT:
        MyLogger* mylogger;
        SV*            obj;
CODE:
{
    Newxz( mylogger, 1, MyLogger );
    RETVAL = mylogger;
}
OUTPUT:
    RETVAL

void xlog_DESTROY(self)
    XS::Logger self;
CODE:
	if (self) {
		free(self);	
	}
