#include <cstdint>
#include <unistd.h>

namespace breakage {
    void evil_call_points_to_unaddressable_bytes()
    {
        // Error: unaddressable bytes (nullptr as buffer)
        const std::int32_t rez = read(STDOUT_FILENO, nullptr, 1);
    }
}

int main()
{
    breakage::evil_call_points_to_unaddressable_bytes();

    return 0;
}
