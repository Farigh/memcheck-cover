#include <iostream>

#include <stdlib.h>

namespace breakage {
    void* evil_fishy_alloc()
    {
        // Disable gcc warning, we are messing with memory on purpose
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Walloc-size-larger-than="
        return malloc(-1);
#pragma GCC diagnostic pop
    }
}

int main()
{
    int* p = (int*)breakage::evil_fishy_alloc();

    // Print to avoid optimization discarding p and it's assignment
    std::cout << p << std::endl;

    return 0;
}
