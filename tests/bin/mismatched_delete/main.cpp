namespace breakage {
    int* alloc_int_array()
    {
        return new int[3];
    }

    void evil_delete_int_array(int* i)
    {
        delete i; /* Should be delete[] */
    }
}

int main()
{
    int* i = breakage::alloc_int_array();

    breakage::evil_delete_int_array(i);

    return 0;
}
