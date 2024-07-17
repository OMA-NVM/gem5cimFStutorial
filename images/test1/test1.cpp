/*
Test m5 functionality and access through your app

    ** note that if you run this app with KVM cpu it would show:
        ____________________________________________________
        |        ***	Hello World!	***                 |
        |                                                   |
        |   Illegal instruction (core dumped)               |
        |___________________________________________________|

So, first switch to TIMING cpu then run the compiled app.
---------
Compile with:

    sudo g++ test1.cpp  /usr/local/lib/libm5.a  -o test1.exe

To switch from KVM to TIMING, you can run:

    m5 exit

Run:

    ./text.exe

for more info:
https://www.gem5.org/documentation/general_docs/m5ops/
*/

#include <iostream>

#include <gem5/m5ops.h>

int
main(int argc, char *argv[])
{
    std::cout << "\n\t***\tHello World!\t***\n" << std::endl;

    std::cout << "sum result (should be 21): " << m5_sum(1, 2, 3, 4, 5, 6)
              << std::endl;

    std::cout << "m5 which shutdowns gem5..." << std::endl;
    m5_dump_reset_stats(0ul, 0ul);
    m5_exit(0ul);

    return EXIT_SUCCESS;
}
