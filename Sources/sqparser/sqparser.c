#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include "sqparser.h"
#define COPY_TEXT(caller, state, sz, string, cursor, cache) \
string = (char*) malloc(sz + 1); \
memset(string, 0, sz + 1); \
memcpy(string, cache, sz); \
(*event)(caller, state, string); \
free(string);
typedef struct STACK {
  int data;
  struct STACK * next;
} Stack;

Stack * push(Stack * stack, int data) {
  Stack * top = (Stack *)malloc(sizeof(Stack));
  memset(top, 0, sizeof(Stack));
  top->data = data;
  top->next = stack;
  return top;
}

Stack * pop(Stack * stack, int * data) {
  if (stack && data) {
    Stack * top = stack;
    *data = top->data;
    Stack * next = top->next;
    free(top);
    return next;
  } else {
    return stack;
  }
}

void parse_squishy(void * caller, const char * path, ParserEvent event)
{
  if (path == NULL || event == NULL) { return ; }
  struct stat info; memset(&info, 0, sizeof(info));
  if (stat(path, &info)) {
    (*event)(caller, ERROR, "File not found\0");
    return ;
  }
  size_t size = (size_t)info.st_size;
  if (size < 1) {
    return ;
  }
  FILE * file = fopen(path, "r");
  if (file == NULL) {
    (*event)(caller, ERROR, "File not opened\0");
    return ;
  }
  char * source = (char *)malloc(size);
  memset(source, 0, size);
  size_t fetched = fread(source, 1, size, file);
  fclose(file);
  if ( fetched < size) {
    char msg[] = "File not read";
    (*event)(caller, ERROR, "File not read");
    return ;
  }
  int state = HTML;
  Stack * stack = NULL;
  char * cache = source, * next = source,
  * string =  NULL, * terminal = source + size;
  size_t sz = 0;
  for (char * cursor = source; cursor < terminal; cursor ++) {
    switch (*cursor) {
      case '<':
        next = cursor + 1;
        if (next >= terminal || state != HTML) break;
        if (*next == '?') {
          sz = (size_t)(cursor - cache);
          COPY_TEXT(caller, state, sz, string, cursor, cache);
          cache = next + 1;
          cursor = cache;
          state = SWIFT_BODY;
        } else if (*next == '%') {
          sz = (size_t)(cursor - cache);
          COPY_TEXT(caller, state, sz, string, cursor, cache);
          cache = next + 1;
          cursor = cache;
          state = SWIFT_HEAD;
        }
        break;
      case '?':
      case '%':
        next = cursor + 1;
        if (next >= terminal || (state != SWIFT_BODY && state != SWIFT_HEAD)) break;
        if (*next != '>') break;
        sz = (size_t)(cursor - cache);
        COPY_TEXT(caller, state, sz, string, cursor, cache);
        cache = next + 1;
        cursor = cache;
        state = HTML;
        break;
      case '\"':
      case '\'':
        if (state == QUOTATION) {
          stack = pop(stack, &state);
        } else {
          stack = push(stack, state);
          state = QUOTATION;
        }
        break;
    }
  }
  if (cache < terminal) {
    sz = (size_t)(terminal - cache);
    COPY_TEXT(caller, state, sz, string, cursor, cache);
  }
}

