namespace breakage {
    int* evil_alloc_int()
    {
        /* No return */
    }

    void evil_double_free()
    {
        int* i = new int();
        delete i;
        delete i;
    }
}

int main()
{
    int* i = breakage::evil_alloc_int();
    delete i;

    breakage::evil_double_free();

    return 0;
}
