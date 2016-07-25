#include <stdlib.h>

template <typename T>
class List;

template <typename T>
class ListNode
{
    friend class List<T>;
private:
    T _value;
    ListNode<T>* _prev;
    ListNode<T>* _next;
	
public:
    ListNode(T v, ListNode<T>* p, ListNode<T>* n);
	
    T* value();
    ListNode<T>* prev();
    ListNode<T>* next();
	
    void setValue(T v);
    void setPrev(ListNode<T>* p);
    void setNext(ListNode<T>* n);
};

template <typename T>
class List
{
private:
    int _length;
    ListNode<T>* _head;
    ListNode<T>* _tail;
	
	
public:
    List();
	
    ListNode<T>* append(T value);
    ListNode<T>* prepend(T value);
    ListNode<T>* link(T v, ListNode<T>* p, ListNode<T>* n);
	
    void unlink(ListNode<T>* s);
	
    ListNode<T>* tail();
    ListNode<T>* head();
    int length();
};

template <typename T>
List<T>::List ()
{
    this->_head = NULL;
    this->_tail = NULL;
    this->_length = 0;
}
                
template <typename T>
ListNode<T>::ListNode (T v, ListNode<T>* p, ListNode<T>* n)
{
    this->_value = v;
    this->_prev = p;
    this->_next = n;   

}

template <typename T>
ListNode<T>*
List<T>::link (T v, ListNode<T>* p, ListNode<T>* n)
{
    ListNode<T>* newLink = new ListNode<T>(v, p, n);

    if(p != NULL)
	p->setNext(newLink);
    else 
	this->_head = newLink;
        
    if(n != NULL)
	n->setPrev(newLink);
    else
	this->_tail = newLink;
        
    this->_length++;
        
    return newLink;
}

template <typename T>
void
List<T>::unlink (ListNode<T>* toDelete)
{
    if(toDelete->prev() != NULL)
	toDelete->prev()->setNext(toDelete->next()); // required if list is not friend
    else
	this->_head = toDelete->_next;

    if(toDelete->next() != NULL)
	toDelete->_next->_prev = toDelete->_prev; // fine if list is a friend
    else
	this->_tail = toDelete->_prev;

    delete toDelete;
    this->_length--;
}

template <typename T>
ListNode<T>*
List<T>::append (T value)
{
    return link(value, this->_tail, NULL);
}

template <typename T>
ListNode<T>*
List<T>::prepend (T value)
{
    return link(value, NULL, this->_head);
}

template <typename T>
T*
ListNode<T>::value()
{
    return &this->_value;
}

template <typename T>
ListNode<T>*
ListNode<T>::prev()
{
    return this->_prev;
}

template <typename T>
ListNode<T>*
ListNode<T>::next()
{
    return this->_next;
}

template <typename T>
void
ListNode<T>::setValue(T v)
{
    this->_value = v;
}

template <typename T>
void 
ListNode<T>::setNext(ListNode<T>* n)
{
    this->_next = n;
}

template <typename T>
void 
ListNode<T>::setPrev(ListNode<T>* p)
{
    this->_prev = p;
}

template <typename T>
ListNode<T>*
List<T>::head()
{
    return this->_head;
}

template <typename T>
ListNode<T>*
List<T>::tail()
{
    return this->_tail;
}



