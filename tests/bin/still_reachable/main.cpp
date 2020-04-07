char* GlobalVar;

namespace breakage {
    void evil_still_reachable()
    {
        GlobalVar = new char[10];
    }
}

int main()
{
    breakage::evil_still_reachable();

    return 0;
}
