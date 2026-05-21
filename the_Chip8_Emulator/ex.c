#define _GNU_SOURCE
#include <sys/ptrace.h>
#include <stdarg.h>

long ptrace(enum __ptrace_request request, ...) {
    return 0;
}
