#include <string>

namespace breakage {
    void evil_out_of_range_assignment()
    {
        constexpr int size = 5;
        char* str = new char[size];
        int i = 0;

        /* 'i' goes too far and exceeds 'str' max range, should be a < */
        for (int i = 0; i <= size; ++i)
        {
            str[i] = '\0';
        }
        delete[] str;
    }

    void evil_null_pointer_assignment()
    {
        int *p = NULL;
        *p = 0;
    }
}

int main()
{
    breakage::evil_out_of_range_assignment();
    breakage::evil_null_pointer_assignment();
    return 0;
}
