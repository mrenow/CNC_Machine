import java.util.Iterator;
/* a specific implementation of linked list which contains a focus pointer which is used to perform
 * various splicing or joining tasks
 * size updates will only occur after splicing, so that the splicing operations stay in a static context while occuring.
 *
 */
class LinkedList <T> implements Iterable<T>{
 
  
  int index;
  int size;
  Node<T> start;
  Node<T> focus;
  Node<T> last;
  boolean destroyed;
  
  LinkedList(){
    index = 0;
    size = 0;
  }
  //linked list with one element.
  LinkedList(T e){
    start = last = new Node<T>(e,null);
    size = 1;
    
  }
  LinkedList(T... e){
    this();
    append(e);
  }
  //creates a new linked list starting at a certian node. If a loop is encountered, it will break the loop forming a linked list that way.
  LinkedList(Node n){
    this();
    start = n;
    Node<T> curr = n.next;
    while (curr != start && curr != null){
      curr = curr.next;
      size += 1;
    }
    curr.next = null;
    last = curr;
  }
  //O(n)
  //highly inefficient, would be better off using an iterator
  T get(int i){
    resetFocus();
    for(;i>0;i--){
      focusTo(index+1);
    }
    return focus.o;
  }
  //not tested
  int indexOf(T e){
    resetFocus();
    for(int i = 0;i<size;i++){
      if(focus.o == e){
        return i;
      }
      focusTo(index+1);
    }
    return -1;
  }
  
  
  
  void append(T e){
    if(destroyed){
      print("Attempted append to destroyed LinkedList:",this);
      exit();
    }
    last.next = (last = new Node<T>(e,null));
    size++;
  }
  //O(1)
  void append(LinkedList<T> e){
    last.next = e.start;
    last = e.last;
    size++;  
  }
  //O(n)
  void append(T... list){
    for(T e: list){
      append(e);
      
    } 
    size+=list.length;
  }
  //insert will place elements before element at specified index.
  void insert(int i, T e){
    if(i == size){
      append(e);  
      return;
    }    
    resetFocus();
    focusTo(i-1);
    Node<T>e1 = new Node(e,focus.next);
    focus.next = e1;
    size++;
  }
  void insert(int i,T... list){
    //if inserting after last index
    if(i == size){
      append(list);  
      return;
    }
    resetFocus();
    focusTo(i-1);
    Node<T> next = focus.next;
    for(T e :list){
      Node<T> e1 = new Node<T>(e,null);
      focus.next = e1;
      focusTo(index+1);  
    }
    focus.next = next;
    size+=list.length;
  }
  void insert(int i , LinkedList<T> list){
     if(i == size){
       append(list);  
       return;
     }
     resetFocus();
     focusTo(i-1);
     //Join end
     list.last.next = focus.next;
     //Join beginning
     focus.next = list.start.next;
     
     size+=list.size;
  }
  T remove(int i, T e){
    if(i==0){
      start = start.next;
    }
    resetFocus();
    focusTo(i-1);
    Node<T> next = focus.next;
    focus.next = focus.next.next; // parent = grandparent, skipping one element.
    return next.o;
  }
  //splits before element at specified index
  LinkedList<T>[] split(int i){
    if (i==0) return new LinkedList[]{new LinkedList(), new LinkedList(start)};
    resetFocus();
    focusTo(i-1);
    Node<T> start2 = focus.switchNext(null);
    return new LinkedList[]{new LinkedList(start), new LinkedList(start2)};
  }
  
  
  
  //focus manupulation
  void resetFocus(){
    if(destroyed){
      print("Attempted accessing destroyed LinkedList:",this);
      exit();
    }
    focus = start;
    index = 0;
  }
  //moves focus to index n and increments index counter.  
  void focusTo(int n){
    if(n>=size){
      throw new ArrayIndexOutOfBoundsException(Integer.toString(n));
    }
    if(destroyed){
      print("Attempted accessing destroyed LinkedList:",this);
      exit();
    }
    while(index<n){
      focus = focus.next;
      index++;
    }
  }
  void destroy(){
    destroyed = true;
    start = last = focus = null;
    size = index = -1;
    
    
  }
  
  
  
  
  Iterator<T> iterator(){
    return new Iterator<T>(){
      Node<T> curr;
      
      public boolean hasNext(){
        return curr.next != null;
      }
      
      public T next(){
        if(curr == null){
          return (curr = start).o;
        }
        return (curr = curr.next).o;
      }
    };
  }
  T[] toArray(T[] out){
    Node<T> curr = start;
    for(int i = 0; i < size; i++){
      out[i] = curr.o;  
      curr = curr.next;
    }
    return out;
  }
}

class Node <T>{
  Node next;
  T o;
  Node(T o, Node next){
    this.o = o;
    this.next = next;
  }
  
  Node switchNext(Node next){
    Node<T> old = this.next;
    this.next  = next;
    return old;
  }
  void set(T e){
    o = e;
  }
  
}