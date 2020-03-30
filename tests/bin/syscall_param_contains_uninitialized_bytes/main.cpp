#include <cstdint>

namespace breakage {
    std::int32_t get_invalid_uninitialized_number()
    {
        std::int32_t* intPtr = new std::int32_t;

        // Initialize intVal with garbage
        const std::int32_t intVal = *intPtr;

        delete intPtr;

        return intVal;
    }
}

int main()
{
    // Syscall param exit_group(status) contains uninitialised byte(s)
    return breakage::get_invalid_uninitialized_number();
}
