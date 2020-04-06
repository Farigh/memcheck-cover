#include <string.h>

namespace breakage {
    void* pStr;

    /**
     * Generates the following violation :
     *    6 bytes in 1 blocks are possibly lost in loss record 1 of 1
     */
    void evil_possibly_lost_func()
    {
        pStr = strdup("dummy");

        // Shift the ptr value so valgrind gets lost
        pStr = ((char*)pStr) + 1;
    }
}

int main()
{
    breakage::evil_possibly_lost_func();
    return 0;
}
