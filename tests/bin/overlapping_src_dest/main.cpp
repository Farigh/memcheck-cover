#include <cstdint>
#include <cstring>

namespace breakage {
    /**
     * Trigger the following violation:
     *   - Source and destination overlap in strncpy(0x.*, 0x.*, 21)
     */
    void evil_overlapping_call()
    {
        constexpr std::uint32_t arraySize = 100;
        char x[arraySize];
        int  i;

        // Initialize the array with non-zero values
        for (i = 0; i < arraySize - 1; i++)
        {
            x[i] = i + 1;
        }

        // Zero-terminate the buffer to avoid any problem
        x[arraySize - 1] = '\0';

        std::strncpy(x, x + 20, 21); // Overlapping memory
    }
}

int main()
{
    breakage::evil_overlapping_call();

    return 0;
}
