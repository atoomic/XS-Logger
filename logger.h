/*
 * logger.h
 */

#ifndef XS_LOGGER_H
#  define XS_LOGGER_H 1

#include <perl.h>
#include <sys/types.h>

#ifndef false
#	define false 0
#endif

#ifndef true
#	define true 1
#endif


/* typedef enum { xfalse, xtrue } xbool; */

typedef enum {
		LOG_DEBUG, /* 0 */
		LOG_INFO,  /* 1 */
		LOG_WARN,  /* 2 */
		LOG_ERROR, /* 3 or also DIE */
		LOG_FATAL,  /* 4 or also PANIC */
		/* keep it in last position */
	    LOG_DISABLE  /* 5 - disable all log events - should be preserved in last position */
} logLevel;

typedef union {
        int ival;
        double fval;
        char *sval;
} MultiValue;

typedef struct {
	bool use_color;
	bool quiet; /* do not display messages on stderr when quiet mode enabled */
	pid_t pid;
	FILE *fhandle;
	char filepath[256];
	logLevel level; /* only display what is after the log level (included) */
} MyLogger;

/* function prototypes */
char* get_default_file_path();
void do_log(MyLogger *mylogger, logLevel level, const char *fmt, int num_args, ...);

#define ACQUIRE_LOCK_ONCE(f) if ( hold_lock == false ) { flock( fileno(f), LOCK_EX ); hold_lock = true; }
#define RELEASE_LOCK(f) if ( hold_lock == true ) flock( fileno(f), LOCK_UN );

/*
	https://gcc.gnu.org/onlinedocs/gcc/Variadic-Macros.html

	Some tricks:
	https://codecraft.co/2014/11/25/variadic-macros-tricks/
*/

/* print on provided fh + stderr as a bonus */
#define M_FPRINTF(fh, format, ...) { \
	fprintf(fh, format, __VA_ARGS__); \
	if (quiet == false) fprintf(stderr, format, __VA_ARGS__); \
}

#define M_VFPRINTF(fh, format, xargs) { \
	va_list xargs2; \
	if (quiet == false) va_copy(xargs2, xargs); \
	vfprintf(fh, format, xargs); \
	if (quiet == false) { vfprintf(stderr, format, xargs2); va_end(xargs2); } \
}

#define M_FPUTS(format, fh) { \
	fputs( format, fh ); \
	if (quiet == false) fputs( format, stderr ); \
}

#endif /* XS_LOGGER_H */