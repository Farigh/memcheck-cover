#include <valgrind/valgrind.h>

namespace breakage {
    /**
     * Trigger the following violation:
     *   - Illegal memory pool address
     */
    void evil_illegal_memory_pool_address()
    {
        char notAPool[100];

        /**
         * Illegal pool addr, a pool must be created using
         * VALGRIND_CREATE_MEMPOOL first
         */
        VALGRIND_MEMPOOL_ALLOC(notAPool, notAPool, 8);
    }
}

int main(void)
{
    breakage::evil_illegal_memory_pool_address();

    return 0;
}
