#include <memory>

namespace breakage {
    class LinkedElem
    {
    public:
        void SetPrev(const std::shared_ptr<LinkedElem>& prev)
        {
            _prev = prev;
        }

        void SetNext(const std::shared_ptr<LinkedElem>& next)
        {
            _next = next;
        }

    private:
        std::shared_ptr<LinkedElem> _next;
        std::shared_ptr<LinkedElem> _prev;
    };

    void evil_linked_ptr_indirectly_lost()
    {
        const auto p1 = std::make_shared<LinkedElem>();
        const auto p2 = std::make_shared<LinkedElem>();

        // Linking the pointed will result in them not being freed
        p1->SetNext(p2);
        p2->SetPrev(p1);
    }
}

int main()
{
    breakage::evil_linked_ptr_indirectly_lost();

    return 0;
}
