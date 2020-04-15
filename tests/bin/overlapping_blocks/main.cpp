#include <cstdint>

#include <valgrind/memcheck.h>

namespace breakage {
    void evil_mempool_alloc()
    {
        struct pool
        {
            std::uint8_t* buf;
        } MyPool;

        constexpr std::uint32_t PoolBlockSize = 256;

        std::uint8_t MyBlock[PoolBlockSize];

        VALGRIND_CREATE_MEMPOOL_EXT(&MyPool, 0, 0, 0);
        VALGRIND_MEMPOOL_ALLOC(&MyPool, MyBlock, PoolBlockSize);

        MyPool.buf = MyBlock;

        VALGRIND_MALLOCLIKE_BLOCK(MyPool.buf, 10, 0, 0);
        // Should be MyPool->buf + 10
        VALGRIND_MALLOCLIKE_BLOCK(MyPool.buf + 2, 10, 0, 0);
    }
}

int main()
{
    breakage::evil_mempool_alloc();

    return 0;
}
