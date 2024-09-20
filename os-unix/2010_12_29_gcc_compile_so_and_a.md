# GCC编译.a和.so

```C++
// print_hello.c
#include <stdio.h>

void print_hello()
{
  printf("hello\n");
}
```

```C++
// print_bye.c
#include <stdio.h>

void print_bye()
{
  printf("bye\n");
}
```

```C++
// main.c
void print_hello();
void print_bye();

int main()
{
  print_hello();
  print_bye();
  return 0;
}
```

```Makefile
all:
  gcc -o print_hello.o -Wall -fPIC -c print_hello.c
  gcc -o print_bye.o -Wall -fPIC -c print_bye.c
  gcc -o libprint.so -shared print_hello.o print_bye.o
  ar cru libprint.a print_hello.o print_bye.o
  gcc -o myprint main.c libprint.so
  gcc -o myprint_static main.c libprint.a
```

运行结果

```
$ ./myprint
./myprint: error while loading shared libraries: libprint.so: cannot open shared object file: No such file or directory

$ LD_LIBRARY_PATH=. ./myprint
hello
bye

$ ./myprint_static 
hello
bye

$ ldd myprint
        linux-vdso.so.1 (0x00007ffff79f7000)
        libprint.so => not found
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007fbe2ca47000)
        /lib64/ld-linux-x86-64.so.2 (0x00007fbe2cdf2000)

$ ldd myprint_static 
        linux-vdso.so.1 (0x00007ffd3d5cb000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f1b3de51000)
        /lib64/ld-linux-x86-64.so.2 (0x00007f1b3e1fc000)
```
