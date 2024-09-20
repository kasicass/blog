# [pthread] thread self & equal

Too simple to explain, just read the code.

```C
#include <stdio.h>
#include <pthread.h>

pthread_t pid;

void *mythr1(void *_)
{
    printf("#1 equal = %d\n", pthread_equal(pid, pthread_self()));
    return (void *)0;
}

void *mythr2(void *_)
{
    printf("#2 equal = %d\n", pthread_equal(pid, pthread_self()));
    return (void *)0;
}

int main()
{
    pthread_t pid2;
    pthread_create(&pid, NULL, mythr1, NULL);
    pthread_create(&pid2, NULL, mythr2, NULL);

    pthread_join(pid, NULL);
    pthread_join(pid2, NULL);

    return 0;
}
```

运行结果：

```
$ ./a.out 
#1 equal = 1
#2 equal = 0
```
