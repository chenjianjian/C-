// log_ratelimit.h

#ifndef _LOG_RATELIMIT_H_
#define _LOG_RATELIMIT_H_

#ifdef __cplusplus
extern "C" {
#endif

#include <stdio.h>
#include <stdint.h>

// 若5分钟打印一次则修改宏DEFAULT_RATELIMIT_INTERVAL为5 * 60 * 1000
// ,DEFAULT_RATELIMIT_BURST修改为1 对于linux/macos需要链接-lrt库
// c++可以根据这宏进行相关改造即可

#define RATELIMIT_MSG_ON_RELEASE   (1 << 0)
#define DEFAULT_RATELIMIT_INTERVAL (5 * 1000) // 5S
#define DEFAULT_RATELIMIT_BURST     1        // 5S打印10次

struct ratelimit_state {
  int32_t burst;
  int32_t printed;
  int32_t missed;
  int32_t interval;
  int32_t flags;
  uint64_t begin;
};

int32_t ratelimit(struct ratelimit_state *rs, int32_t *missed);

#ifdef _WIN32
#define log_ratelimited(fmt, ...)                                   \
  {                                                                 \
    static struct ratelimit_state _rs = {                           \
        DEFAULT_RATELIMIT_BURST,  0, 0, DEFAULT_RATELIMIT_INTERVAL, \
        RATELIMIT_MSG_ON_RELEASE, 0};                               \
    int32_t missed = 0;                                             \
    int32_t ret = ratelimit(&_rs, &missed);                         \
    if (ret == 1) {                                                 \
      printf(fmt, ##__VA_ARGS__);                                   \
    } else if (ret == 2) {                                          \
      printf("%s missed:%d\n", __func__, missed);                   \
    }                                                               \
  }
#else
#define log_ratelimited(fmt, args...)                               \
  {                                                                 \
    static struct ratelimit_state _rs = {                           \
        DEFAULT_RATELIMIT_BURST,  0, 0, DEFAULT_RATELIMIT_INTERVAL, \
        RATELIMIT_MSG_ON_RELEASE, 0};                               \
    int32_t missed = 0;                                             \
    int32_t ret = ratelimit(&_rs, &missed);                         \
    if (ret == 1) {                                                 \
      printf(fmt, ##args);                                          \
    } else if (ret == 2) {                                          \
      printf("%s missed:%d\n", __func__, missed);                   \
    }                                                               \
  }
#endif

#ifdef __cplusplus
}
#endif

#endif  // log_ratelimit.h
