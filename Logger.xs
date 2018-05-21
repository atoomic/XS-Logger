#define PERL_EXT_XS_LOG 1

#include <EXTERN.h>    // define thread context if necessary (faster)
#include <perl.h>      // Perl symbols, structures and constants definition
#include <XSUB.h>      // Perl API - xsub functions & macros

// load here any C library you want
#include <stdlib.h>
#include <unistd.h>

// your own .h file or add your declaration directly there
#include "logger.h"

MODULE = XS__Logger    PACKAGE = XS::Logger PREFIX = xlog_

TYPEMAP: <<HERE

MyLogger*  T_PTROBJ
XS::Logger T_PTROBJ

HERE

XS::Logger
xlog_new(class, ...)
    char* class;
PREINIT:
        MyLogger* mylogger;
        SV*            obj;
        HV*    opts = NULL;
        SV           **svp;        
CODE:
{
    Newxz( mylogger, 1, MyLogger );
    RETVAL = mylogger;

    if ( items > 1 ) { /* kinda va_start, va_list, ... */
        SV *extra = (SV*) ST(1);

        if ( SvROK(extra) && SvTYPE(SvRV(extra)) == SVt_PVHV )
            opts = (HV*) SvRV( extra );
    }

    /* default (non zero) values */
    mylogger->use_color = true; /* maybe use a GV from the stash to set the default value */
    if ( opts ) {
        if ( (svp = hv_fetchs(opts, "color", FALSE)) ) {
            if (!SvIOK(*svp)) croak("invalid color option value: should be a boolean 1/0");
            mylogger->use_color = (bool) SvIV(*svp);
        }
        if ( (svp = hv_fetchs(opts, "level", FALSE)) ) {
            if (!SvIOK(*svp)) croak("invalid log level: should be one integer");
            mylogger->level = (logLevel) SvIV(*svp);
        }
        if ( (svp = hv_fetchs(opts, "quiet", FALSE)) ) {
            if (!SvIOK(*svp)) croak("invalid quiet value: should be one integer 0 or 1");
            mylogger->quiet = (logLevel) SvIV(*svp);
        }
        if ( (svp = hv_fetchs(opts, "logfile", FALSE)) || (svp = hv_fetchs(opts, "path", FALSE)) ) {
            STRLEN len;
            char *src;

            if (!SvPOK(*svp)) croak("invalid logfile path: must be a string");
            src = SvPV(*svp, len);
            if (len >= sizeof(mylogger->filepath))
                croak("file path too long max=256!");
            strcpy(mylogger->filepath, src); /* do a copy to the object */
        }
    }
}
OUTPUT:
    RETVAL



SV*
xlog_getters(self)
    XS::Logger self;
ALIAS:
     XS::Logger::get_pid               = 1
     XS::Logger::use_color             = 2
     XS::Logger::get_level             = 3
     XS::Logger::get_quiet             = 4
     XS::Logger::quiet                 = 4
     XS::Logger::debug                 = 5
CODE:
{ 
    switch (ix) {
        case 1:
             RETVAL = newSViv( self->pid );
        break;
        case 2:
             RETVAL = newSViv( self->use_color );
        break;
        case 3:
             RETVAL = newSViv( (int) self->level );
        break;
        case 4:
             RETVAL = newSViv( (int) self->quiet );
        break;
        default:
             XSRETURN_EMPTY;
     }
}
OUTPUT:
    RETVAL

void
xlog_setters(self, value)
    XS::Logger self;
    SV* value;
ALIAS:
     XS::Logger::set_level             = 1
     XS::Logger::set_quiet             = 2
CODE:
{
    switch (ix) {
        case 1:
            if ( !SvIOK(value) ) croak("invalid level: must be interger.");
             self->level = SvIV(value);
        break;
        case 2:
            if ( !SvIOK(value) ) croak("invalid quiet value: must be interger.");
             self->quiet = SvIV(value);
        break;
        default:
             croak("undefined setter");
     }

     XSRETURN_EMPTY;
}


void xlog_DESTROY(self)
    XS::Logger self;
CODE:
	if (self) {
		free(self);	// Safefree
	}

BOOT:
{
    HV *stash;
    SV *sv;
    stash = gv_stashpvn("XS::Logger", 10, TRUE);

    newCONSTSUB(stash, "_loaded", newSViv(1) );
    newCONSTSUB(stash, "DEBUG_LOG_LEVEL", newSViv( LOG_DEBUG ) );
    newCONSTSUB(stash, "INFO_LOG_LEVEL", newSViv( LOG_INFO ) );
    newCONSTSUB(stash, "WARN_LOG_LEVEL", newSViv( LOG_WARN ) );
    newCONSTSUB(stash, "ERROR_LOG_LEVEL", newSViv( LOG_ERROR ) );
    newCONSTSUB(stash, "FATAL_LOG_LEVEL", newSViv( LOG_FATAL ) );
    newCONSTSUB(stash, "DISABLE_LOG_LEVEL", newSViv( LOG_DISABLE ) );
}	


