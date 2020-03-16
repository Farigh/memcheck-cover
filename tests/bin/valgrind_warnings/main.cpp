#include <cstdint>

#include <signal.h>
#include <unistd.h>

namespace {
    void set_signal_handler(const std::int32_t signal)
    {
        struct sigaction  sa;
        sa.sa_flags   = 0;
        sigemptyset(&sa.sa_mask);
        sa.sa_handler = [](std::int32_t){};

        const std::int32_t rc = sigaction(signal, &sa, nullptr);
    }
}

namespace breakage {
    /**
     * Warning: invalid file descriptor -1 in syscall write()
     */
    void evil_invalid_fd()
    {
        constexpr std::uint32_t len = 5;
        const std::int32_t buf[len] = { 1, 2, 3, 4, 5 };
        const std::int32_t rez = write(-1, buf, len * sizeof(std::int32_t));
    }

    /**
     * Sigaction warnings:
     *    - Warning: bad signal number 65 in sigaction()
     *    - Warning: ignored attempt to set <sigName> handler in sigaction()
     *      With context:
     *        -  the SIGSTOP signal is uncatchable
     *        -  the SIGRT32 signal is used internally by Valgrind
     */
    void evil_sigaction()
    {
        // SIGSTOP is uncatchable
        set_signal_handler(SIGSTOP);

        // Signal 65 is not a valid one
        set_signal_handler(65);

        // Signal 64 should be reserved by valgrind as SIGRT32
        // VKI_SIGRTMIN is set to 32 one most systems (except solaris: 41)
        // And this SIGRT signal formula is sigNo - VKI_SIGRTMIN
        set_signal_handler(64);
    }
}

int main(void)
{
    breakage::evil_invalid_fd();
    breakage::evil_sigaction();

    return 0;
}
