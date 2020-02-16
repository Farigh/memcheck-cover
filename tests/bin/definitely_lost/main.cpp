namespace breakage {
    void evil_definitely_lost_func()
    {
        int* i = new int();
    }
}

int main()
{
    breakage::evil_definitely_lost_func();
    return 0;
}
