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
xlog_new(class)
    char* class;
PREINIT:
        MyLogger* mylogger;
        SV*            obj;
CODE:
{
    //Newxz( mylogger, 1, MyLogger ); /* malloc our object */
    mylogger = malloc( sizeof(MyLogger) );
    RETVAL = newSViv(0);
    obj = newSVrv(RETVAL, class); /* bless our object */


    char buffer[255];
            sprintf( buffer, "new --- %x\n", (long int) mylogger );
            warn( buffer );


    sv_setiv(obj, PTR2IV(mylogger)); /* get a pointer to our malloc object */
    SvREADONLY_on(obj);
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
    SV* self;
PREINIT:
        I32* temp;
        MyLogger* mylogger;
PPCODE:
{
	char buffer[255];
        //temp = PL_markstack_ptr++;

        if ( self && SvROK(self) && SvOBJECT(SvRV(self)) ) { /* check if self is an object */
            mylogger = INT2PTR(MyLogger*, SvIV(SvRV(self)));

            sprintf( buffer, "destroy %x\n", (long int) mylogger );
            warn( buffer );
            /* free the logger... maybe more to clear from struct */
            free(mylogger);

        }

        // if (PL_markstack_ptr != temp) {
        //     /* truly void, because dXSARGS not invoked */
        //     PL_markstack_ptr = temp;
        //     XSRETURN_EMPTY;
        //     /* return empty stack */
        // }  /* must have used dXSARGS; list context implied */        

        return;  /* assume stack size is correct */
}
