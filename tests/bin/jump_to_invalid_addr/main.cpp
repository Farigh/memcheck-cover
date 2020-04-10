namespace breakage {
    void evil_jump_at_invalid_addr()
    {
        // Trying to call a function at addr 0x0
        void (*fn)(void) = 0;
        fn();
    }
}


int main(void)
{
    breakage::evil_jump_at_invalid_addr();

    return 0;
}
