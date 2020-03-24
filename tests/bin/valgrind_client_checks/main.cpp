#include <cstdint>

#include <stdlib.h>
#include <valgrind/memcheck.h>

namespace breakage {
    /**
     * Trigger the following client check violations:
     *   - Uninitialised byte(s) found during client check request
     *   - Unaddressable byte(s) found during client check request
     */
    void client_check_unaddressable_uninitialised_byte()
    {
        constexpr std::uint32_t arraySize = 8;
        char* a = new char[arraySize];

        for (std::uint32_t i = 0; i < arraySize; i++)
        {
            // Skip initialisation at index 4
            // This will trigger 'Uninitialised byte' violation
            if (i == 4)
            {
                continue;
            }

            a[i] = '0';
        }

        // Range will be unaddressable at index "arraySize" (out of bound)
        VALGRIND_CHECK_MEM_IS_DEFINED(a, arraySize + 1);

        delete[] a;
    }
}

int main(void)
{
    breakage::client_check_unaddressable_uninitialised_byte();

    return 0;
}
