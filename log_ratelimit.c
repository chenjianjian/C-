// log_ratelimit.c

#ifdef _WIN32
#include <windows.h>
#else
#include <time.h>
#endif

#include "log_ratelimit.h"

#ifdef _WIN32
static uint64_t steady_clock_now_ms() {
  LARGE_INTEGER frequency, counter;
  QueryPerformanceFrequency(&frequency);
  QueryPerformanceCounter(&counter);

  return counter.QuadPart * 1000 / frequency.QuadPart;
}
#else
static uint64_t steady_clock_now_ms() {
  struct timespec ts;
  clock_gettime(CLOCK_MONOTONIC, &ts);

  return (uint64_t)ts.tv_sec * 1000 + (uint64_t)ts.tv_nsec / 1000000;
}
#endif


int32_t ratelimit(struct ratelimit_state* rs,
                                    int32_t* missed) {
  uint64_t now_ms;
  int32_t ret = 0;

  if (!rs || !rs->interval) {
    return 1;
  }

  now_ms = steady_clock_now_ms();
  if (!rs->begin) {
    rs->begin = now_ms;
  }

  if (missed) {
    *missed = 0;
  }
  if (rs->begin + rs->interval < now_ms) {
    if (rs->missed) {
      if (rs->flags & RATELIMIT_MSG_ON_RELEASE) {
        if (missed) {
          *missed = rs->missed;
        }
        rs->missed = 0;
      }
    }
    rs->begin = now_ms;
    rs->printed = 0;
  }
  
  if (rs->burst && rs->burst > rs->printed) {
    rs->printed++;
    ret = 1;
  } else {
    rs->missed++;
    ret = 0;
  }
  if (missed && *missed > 0) {
    ret = 2;
  } 

  return ret;
}
