#include <cstdint>
#include <memory>
#include <iostream>

namespace breakage {
    struct MyStruct
    {
        std::int32_t i = 12;
    };

    std::int32_t& evil_get_value()
    {
        const auto p = std::make_unique<MyStruct>();

        p->i = 7;

        // Returns a ref on the pointed member
        // which will be deleted on return
        return p->i;
    }

    void evil_invalid_read()
    {
        // Use the value, part of the freed memory
        std::cout << evil_get_value() << std::endl;
    }
}

int main()
{
    breakage::evil_invalid_read();
    return 0;
}
