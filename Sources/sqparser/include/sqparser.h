#ifndef __SQUISHY_PARSER__
#define __SQUISHY_PARSER__
#define HTML 0
#define SWIFT_HEAD 1
#define SWIFT_BODY 2
#define QUOTATION 3
#define ERROR 4
typedef void (*ParserEvent)(void * caller, int state, const char * source);
extern void parse_squishy(void * caller, const char * path, ParserEvent event);
#endif
