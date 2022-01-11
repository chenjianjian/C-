#ifndef _ATOMIC_H_
#define _ATOMIC_H_

#ifndef __GNUC__
#error "Atomic operations require GCC compiler!"
#endif /* !GCC */

#include <linux/types.h>

typedef struct __atomic {
    volatile int val;
} atomic_t;

//#define atomic_read(a)   ((a)->val)
//#define atomic_set(a, b) ((a)->val = b)

static inline int atomic_read(atomic_t *a)
{
     return __sync_add_and_fetch(&a->val, 0);
}

static inline int atomic_set(atomic_t *a, int b)
{
    return __sync_lock_test_and_set(&a->val, b);
}

static inline int atomic_add(atomic_t *a, int b)
{
    return __sync_add_and_fetch(&a->val, b);
}

static inline int atomic_sub(atomic_t *a, int b)
{
    return __sync_sub_and_fetch(&a->val, b);
}

static inline int atomic_inc(atomic_t *a)
{
    return __sync_add_and_fetch(&a->val, 1);
}

static inline int atomic_dec(atomic_t *a)
{
    return __sync_sub_and_fetch(&a->val, 1);
}

static inline int atomic_and(atomic_t *a, int mask)
{
    return __sync_fetch_and_and(&a->val, mask);
}

static inline int atomic_or(atomic_t *a, int mask)
{
    return __sync_fetch_and_or(&a->val, mask);
}

static inline __u64 atomic_add_u64(__u64 *p, __u64 x)
{
	return __sync_add_and_fetch(p, x);
}

static inline __u64 atomic_sub_u64(__u64 *p, __u64 x)
{
	return __sync_sub_and_fetch(p, x);
}

static inline __u64 atomic_inc_u64(__u64 *p)
{
    return __sync_add_and_fetch(p, 1);
}

static inline __u64 atomic_dec_u64(__u64 *p)
{
    return __sync_sub_and_fetch(p, 1);
}

static inline __u64 atomic_read_u64(__u64 *p)
{
#if (__SIZEOF_POINTER__ == 4) 
    return *p;
#else        
    return __sync_sub_and_fetch(p, 0);
#endif
}

static inline __u64 atomic_set_u64(__u64 *p, __u64 b)
{
#if (__SIZEOF_POINTER__ == 4)     
    return (*p = b);
#else
    return __sync_lock_test_and_set(p, b);
#endif
}

static inline __s64 atomic_add_s64(__s64 *p, __s64 x)
{
	return __sync_add_and_fetch(p, x);
}

static inline __s64 atomic_sub_s64(__s64 *p, __s64 x)
{
#if (__SIZEOF_POINTER__ == 4)
	return (*p -= x);
#else    
    return __sync_sub_and_fetch(p, x);
#endif    
}

static inline __s64 atomic_inc_s64(__s64 *p)
{
    return __sync_add_and_fetch(p, 1);
}

static inline __s64 atomic_dec_s64(__s64 *p)
{
    return __sync_sub_and_fetch(p, 1);
}

static inline __s64 atomic_read_s64(__s64 *p)
{
    return __sync_sub_and_fetch(p, 0);
}

static inline __s64 atomic_set_s64(__s64 *p, __s64 b)
{
#if (__SIZEOF_POINTER__ == 4)
    return (*p = b);
#else
    return __sync_lock_test_and_set(p, b);
#endif    
}

#endif /* _ATOMIC_H_ */

