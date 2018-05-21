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

OUTPUT

O_OBJECT
   sv_setref_pv( $arg, CLASS, (void*)$var );

INPUT

O_OBJECT
   if ( sv_isobject($arg) && (SvTYPE(SvRV($arg)) == SVt_PVMG) )
     $var = ($type)SvIV((SV*)SvRV( $arg ));
   else
     croak( "${Package}::$func_name() -- $var is not a blessed SV reference" );

HERE

XS::Logger
xlog_new(class)
    char* class;
PREINIT:
        MyLogger* mylogger;
        SV*            obj;
CODE:
{
    //Newxz( mylogger, 1, MyLogger ); /* malloc our object */
    //RETVAL = mylogger;
    RETVAL = calloc (1, sizeof(MyLogger) );
    //RETVAL = newSViv(0);
    //obj = newSVrv(RETVAL, class); /* bless our object */

    //sv_setiv(obj, PTR2IV(mylogger)); /* get a pointer to our malloc object */
    //SvREADONLY_on(obj);

    // RETVAL = calloc (1, sizeof (MyLogger));
}
OUTPUT:
    RETVAL


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

void xlog_DESTROY(self)
    XS::Logger self;
CODE:
	if (self) {
		free(self);	
	}
