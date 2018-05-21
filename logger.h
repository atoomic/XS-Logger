#ifndef XS_LOGGER_H
#  define XS_LOGGER_H 1

#include <perl.h>
#include <sys/types.h>

 typedef enum {
         LOG_DEBUG,   /* 0 */
         LOG_INFO,    /* 1 */
         LOG_WARN,    /* 2 */
         LOG_ERROR,   /* 3 or also DIE */
         LOG_FATAL,   /* 4 or also PANIC */
         /* keep it in last position */
         LOG_DISABLE  /* 5 - disable all log events - should be preserved in last position */
 } logLevel;

 typedef struct {
     bool use_color;
     bool quiet; /* do not display messages on stderr when quiet mode enabled */
     pid_t pid;
     FILE *fhandle;
     char filepath[256];
     logLevel level; /* only display what is after the log level (included) */
 } MyLogger;

typedef MyLogger * XS__Logger;

#endif /* XS_LOGGER_H */

