#include <iostream>

namespace breakage {
    void evil_jump_on_stack_uninitialized_value()
    {
        int a[2];
        a[0] = 0; // a[1] is not initialized
        int res = 0;
        for (int i = 0; i < 2; i++)
        {
            res += a[i];
        }

        if (res == 377)
        {
            // Do something with res
            std::cout << res << std::endl;
        }
    }

    void evil_use_of_uninitialized_value()
    {
        int* array = new int;

        // Do something with array
        std::cout << *array << std::endl;

        delete array;
    }
}

int main()
{
    breakage::evil_jump_on_stack_uninitialized_value();
    breakage::evil_use_of_uninitialized_value();

    return 0;
}
