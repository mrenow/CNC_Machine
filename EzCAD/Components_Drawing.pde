import java.awt.event.KeyEvent;
import java.util.ListIterator;
class Canvas extends Element implements MovementListener, ClickListener, KeyboardListener{
  PVector pointerpos;
  
  
  //the entire map will be comprised of multiple line chains. Every exposed line that is created will create a new line chain.
  //When checking for pointerpos, all line chains will be looped through. 
  
  //all line chains
  
  
  ArrayList<LinkedList<PVector>> linechainlist;
  
  
  
  //old
  ArrayList<PVector[]> linedata = new ArrayList<PVector[]>();

  
  //start and end points must take priority when checking linechains, otherwise they will be incorrectly selected.
  //endpoints of line chains
  ArrayList<PVector> starts;
  //ends of all line chains`
  ArrayList<PVector> ends;
  
  
  //state variables
  boolean drawing = false;
  boolean unoccupied =true;
  boolean focusstate = true; //beginning is true;
  ArrayList<PVector> buffer;
  //the lists that will be added to
  //if both lists not null, merge
  ArrayList<LinkedList<PVector>> focusbuffer;
  
  //some constants
  
  
  
  Canvas(float x, float y, float w, float h,Container p){
    super(x,y,w,h,p);
    pointerpos = new PVector(0,0);
    buffer = new ArrayList<PVector>();
    linechainlist = new ArrayList<LinkedList<PVector>>(10);
    starts = new ArrayList<PVector>();
    ends = new ArrayList<PVector>();
    addClickListener(this);
    addMovementListener(this);
    addKeyboardListener(this);
    
  }
  //needs updating (hah ironic)
  void update(){
      resetGraphics();
      
      g.background(255);
      g.line(pointerpos.x+5,pointerpos.y,pointerpos.x-5,pointerpos.y);
      g.line(pointerpos.x,pointerpos.y+5,pointerpos.x,pointerpos.y-5);
      
      for(PVector[] line : linedata){
        g.line(line[0].x,line[0].y,line[1].x,line[1].y);
      }
      if(!unoccupied){
        g.line(buffer.get(0).x,buffer.get(0).y,pointerpos.x,pointerpos.y);
      }
      
      
  }
  
  void addBuffer(){
    linedata.add(buffer.toArray(new PVector[buffer.size()]));
    buffer.clear(); 
  }
  void cancelAction(){
    unoccupied = true;
    buffer.clear();
  }
  /*
  BEGIN onMove
    check for dots in priority:
    closest -> is start/is end
    
  
  Cases:
   point-point
   linechain- point(which end and order of the linchain must detected and dealt with)
   linechain-linechain (sides still need to be taken into consideration, selection )
  */ 
  
  void mouseMoved(){
    PVector mouse = localMouse(this);
    pointerpos = mouse;
    float dist;
    ListIterator<PVector> chainiter;
    PVector point;
    float mindist = 36;
    focus = null;
    
    //linechain ends must be prioritized manually:
    for(LinkedList<PVector> linechain: linechainlist){
      
      if((dist = PVector.sub(point,pointerpos).magSq())<=mindist){
        mindist = dist;
        pointerpos = point.copy();
        focusBuffer = linechain;
        focusstate = true;
      }
      
      
      
    for(LinkedList<PVector> linechain: linechainlist){
      chainiter = linechain.listIterator();
      point= chainiter.next();
      
      if((dist = PVector.sub(point,pointerpos).magSq())<=mindist){
        mindist = dist;
        pointerpos = point.copy();
        focusBuffer = linechain;
        focusstate = true;
      }
      while(true){
        point = chainiter.next();
        if(chainiter.hasNext()){
          if((dist = PVector.sub(point,pointerpos).magSq())<mindist){
            mindist = dist;
            pointerpos = point.copy();
          }
        }else{
          if((dist = PVector.sub(point,pointerpos).magSq())<=mindist){  
            mindist = dist;
            pointerpos = point.copy();
            focus = linechain;
            focusstate = false;
          }
          return;
        }
      }
    
    }
    //snap tool
    if(!unoccupied && keys[SHIFT]){
      PVector diff = PVector.sub(pointerpos,buffer.get(0));
      if(abs(diff.x) < abs(diff.y)){
        pointerpos.x = buffer.get(0).x;
      
      }else{
        pointerpos.y = buffer.get(0).y; 
      }
        
    }
    
    requestUpdate();
  }
  void elementHovered(){
    
  }
  void elementUnhovered(){
  
  }

  //
  void elementClicked(){
    /*
    unoccupied = !unoccupied;
    if(unoccupied){
        buffer.add(new PVector(pointerpos.x,pointerpos.y));
        addBuffer();
        
        //simulate a click to deposit new point.
        if(keys[CONTROL]){
          elementClicked();
        }
    }else{
        buffer.add(new PVector(pointerpos.x,pointerpos.y));
    }
    */
    if(focus != null){
    
    }else{
      
      linechainlist.add(new LinkedList<PVector>());
      linechain.
      
    
    }
    
    requestUpdate();
  }
  void elementReleased(){
  
  }
  void keyPressed(){
    if(!unoccupied && keys[BACKSPACE]){
      cancelAction();
    }
    if(keys[CONTROL] && keys[KeyEvent.VK_Z]){
      linedata.remove(linedata.size()-1);
      cancelAction();
    }
    requestUpdate(); 
  }
  void keyReleased(){
  
  }
  void keyTyped(){
  }
}






class Linechain implements Iterable<PVector>{
  
  LinkedList<PVector>[] chains;
  int size;
  
  
  
  //in the external program, linechains will be created if no linechain stored in buffers (meaning that no linechain end has been clicked on)
  
  
  Linechain(){
    chains = new LinkedList[2];
    size = 0;
  
  }
  
  Linechain(PVector start, PVector end){
    this();
    //pair of reversed and non reversed linkedlist of start and end
    chains[0] = new LinkedList<PVector>(start,end);
    chains[1] = new LinkedList<PVector>(end,start);
    size = 2;  
  
  
  }
  Linechain(LinkedList<PVector> forward,LinkedList<PVector> backward){
    this();
    chains[0] = forward;
    chains[1] = backward;
    if(!check()){
      print("LinkedList mismatch in constructor: Linechain(LinkedList<PVector> forward,LinkedList<PVector> backward)");
    }
    size = forward.size;
    
  
  }
  
  void appendFront(PVector e){
    chains[0].append(e);
    chains[1].insert(0,e);
  } 
  void appendBack(PVector e){
    chains[1].append(e);
    chains[0].insert(0,e);
  }
  //removes a particular PVector and splits the linechain.
  //UNVERIFIED
  Linechain[] splitLinechain(PVector e){
    int index = 0;
    chains[0].resetFocus();
    while(e!=chains[0].focus.next.o){
      index++;
      chains[0].focusTo(chains[0].index + 1);
    }
    chains[1].resetFocus();
    chains[1].focusTo(size-index-2);
    
    //creates 2 pairs of linked lists, one for each linechain.
    //00 10
    //01 11
                  //left
    Node<PVector> start00 = chains[0].start,
                  end00 = chains[0].focus,
                  //right
                  start10 = chains[0].focus.next.next,
                  end10 = chains[0].last,
                  //right
                  start11 = chains[1].focus,
                  end11 = chains[1].start,
                  //left
                  start01 = chains[1].last,
                  end01 = chains[1].focus.next.next;
    Linechain[] out = new Linechain[2];
    out[0] = new Linechain(new LinkedList(start00,end00),
                           new LinkedList(end01,start01));
    out[1] = new Linechain(new LinkedList(start10,end10),
                           new LinkedList(end11,start11));
    return out;
  }
  
  PVector getFront(){
    return chains[0].start.o;
  }
  PVector getBack(){
    return chains[1].start.o;
  }
  //check that chains[0] reversed == chains[1]
  //UNCHECKD
  boolean check(){
    if(!(chains[0].size == chains[1].size && chains[1].size == size)){
      return false;
    }
    PVector[] forward = chains[0].toArray(new PVector[size]);
    int i = size;
    //traversing chains[1] forwards, traversing chains[0] (now as forward array) backwards, and components should be equivalent.
    for(PVector e: chains[1]){
      i--;
      if(forward[i] != e){
        return false;
      
      }
    }
    return true;
  }
  PVector getStart(int i){
    return chains[i].start.o;
  }
  PVector getEnd(int i){
    return chains[i].last.o;
  }
  //UNCHECKD
  void join(Linechain that, PVector enda, PVector startb){
    
    //my attempt to make things look less disgusting made them look less comprehensible
    //determines which sides of each linechain to glue, then selects linechains accordingly.
    int sidea = this.getEnd(0) == enda ? 1:-1;
    int sideb = that.getStart(0) == startb? 1:-1;
    this.chains[(sidea+1)>>1].append(that.chains[(sideb+1)>>1]);
    this.chains[(-sidea+1)>>1].append(that.chains[(-sideb+1)>>1]);
    //linechain that is consumed;
    that.destroy();
    
  }
  void destroy(){
    chains[0].destroy();
    chains[1].destroy();
    size = 0;
  }
  Iterator<PVector> iterator(){
    return chains[0].iterator();
  }
}