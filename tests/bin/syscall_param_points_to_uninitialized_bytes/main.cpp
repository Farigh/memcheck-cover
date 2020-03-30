#include <cstdint>

#include <unistd.h>

namespace breakage {
    void evil_syscall_param_points_to_uninitialized_byte()
    {
        constexpr std::int32_t stdOutFd = 1;

        std::int32_t* buf = new std::int32_t;
        // Because of buf being uninitialized, we should get the following violation:
        //   Syscall param write(buf) points to uninitialised byte(s)
        const std::int32_t rez = write(stdOutFd, buf, sizeof(std::int32_t));

        delete buf;
    }
}

int main()
{
    breakage::evil_syscall_param_points_to_uninitialized_byte();
    return 0;
}
