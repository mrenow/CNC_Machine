import java.awt.event.KeyEvent;
import java.util.ListIterator;
class Canvas extends Element implements MovementListener, ClickListener, KeyboardListener{
  PVector pointerpos;
  
  
  //the entire map will be comprised of multiple line chains. Every exposed line that is created will create a new line chain.
  //When checking for pointerpos, all line chains will be looped through. 
  
  //all line chains
  ArrayList<Linechain> linechainlist;
  
  //history
  ArrayList<Action> history;
  Action recent(){ 
    return history.remove(history.size()-1);
  }
  
  int UNNOCUPIED = 0, DRAWING = 1;
  int state = 0;
  //free draw -> 
  int mode = 0;
  
  
  //list of points that have been focused in the last session.
  ArrayList<PVector> buffer;
  PVector focusedpoint;
  Linechain focusedchain;
  //the lists that will be added to
  //if both lists not null, merge
  ArrayList<Linechain> focusbuffer;
  
  //some constants
  
  
  
  Canvas(float x, float y, float w, float h,Container p){
    super(x,y,w,h,p);
    pointerpos = new PVector(0,0);
    linechainlist = new ArrayList<Linechain>(10);
    focusbuffer = new ArrayList<Linechain>(2);
    buffer = new ArrayList<PVector>(2);
    history = new ArrayList<Action>(10);
    addClickListener(this);
    addMovementListener(this);
    addKeyboardListener(this);
    
  }

  void update(){
      resetGraphics();
      
      g.background(255);
      //caret
      g.line(pointerpos.x+5,pointerpos.y,pointerpos.x-5,pointerpos.y);
      g.line(pointerpos.x,pointerpos.y+5,pointerpos.x,pointerpos.y-5);
      //drawing linechain;
      for(Linechain l: linechainlist){
        Iterator<PVector> iter = l.iterator();
        PVector prev = iter.next();
        PVector next;
        while(iter.hasNext()){
          next = iter.next();
          g.line(prev.x,prev.y,next.x,next.y);
          prev = next;
        }
      }
      //drawing preview line
      if(state == DRAWING){
        g.line(buffer.get(0).x,buffer.get(0).y,pointerpos.x,pointerpos.y);
      }
      
      
  }
  
  void cancelAction(){
    state = UNNOCUPIED;
    buffer.clear();
    focusbuffer.clear();
  }
  //a.type can only be a.INDEX OR a.POINT, so in all cases split will be assigned.
  void undo(){
    Action a = recent();
    //if a linechain-linechain has occured
    Linechain[] split = null;
    if(a.type == a.INDEX){
      split = a.focus.splitLinechain(a.index);

    //if a point-linechain has occured.
    }else if (a.type == a.POINT){
      split = a.focus.breakLinechain(a.point);
    }
    linechainlist.remove(a.focus);
    if(split[0].size != 0) linechainlist.add(split[0]);
    if(split[1].size != 0) linechainlist.add(split[1]);
  
  
  }
  /*
  BEGIN onMove
    check for dots in priority:
    closest -> is start/end
    IF start/end
      use respective linechain
    ELSE
      create new linechain with single component
    
    
    once both linechains have been identified, join.
  
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
    float mindist = 36;
    
    //starts and ends of linechain prioritized.
    for(Linechain linechain: linechainlist){
      PVector point;
      if((dist = PVector.sub(point = linechain.getStart(),pointerpos).magSq())<mindist){
        mindist = dist;
        pointerpos = point.copy();
        focusedpoint = point;
        focusedchain = linechain;
      }else if((dist = PVector.sub(point = linechain.getEnd(),pointerpos).magSq())<mindist){
        mindist = dist;
        pointerpos = point.copy();
        focusedpoint = point;
        focusedchain = linechain;
      } 
    }
    //goes through all linechain elements everywhere.
    for(Linechain linechain: linechainlist){
      for(PVector point:linechain){
        if((dist = PVector.sub(point,pointerpos).magSq())<mindist){
          mindist = dist;
          pointerpos = point.copy();
          //this will signify to place a new point
          focusedchain = null;
          focusedpoint = null;
        }
      }
    }
    //straight line tool. If activated, the latest focusbuffer is set null
    if(state == DRAWING && keys[SHIFT]){
      focusedchain = null;
      focusedpoint = null;
      PVector diff = PVector.sub(pointerpos,buffer.get(0));
      //if position difference closer to y axis, lock x component and vice versa
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

  void elementClicked(){
   
    if(focusedchain == null){
      focusedchain = new Linechain(pointerpos);
    }
    if(focusedpoint == null){
      focusedpoint = pointerpos;
    }
    
    
    if(state == UNNOCUPIED){
      focusbuffer.add(focusedchain);
      buffer.add(focusedpoint);
      state++;
    }else if(state == DRAWING){
      
      //linechainpoint
      Linechain joined;
      if(focusbuffer.get(0).size==0){
        history.add(new Action(joined = focusbuffer.get(0).join(focusedchain,focusedpoint,buffer.get(0)),focusedpoint));
      }else{
        int size = focusbuffer.get(0).size;
        history.add(new Action(joined = focusbuffer.get(0).join(focusedchain,focusedpoint,buffer.get(0)),size));
      }
      linechainlist.remove(focusbuffer.get(0));
      linechainlist.add(joined);
      print(joined.size);
      state = UNNOCUPIED;
      //simulate click to continue line.
      if(keys[CONTROL]){
        elementClicked();
      }    
    }
    requestUpdate();
  }
  void elementReleased(){
  
  }
  void keyPressed(){
    if(!(state == UNNOCUPIED) && keys[BACKSPACE]){
      cancelAction();
    }
    if(keys[CONTROL] && keys[KeyEvent.VK_Z]){
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
  
  Linechain(PVector point){
    this();
    //pair of reversed and non reversed linkedlist of start and end
    chains[0] = new LinkedList<PVector>(point);
    chains[1] = new LinkedList<PVector>(point);
    size = 1;  
  
  
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
  Linechain[] breakLinechain(PVector e){
    int index = 0;
    chains[0].resetFocus();
    while(e!=chains[0].focus.next.o){
      index++;
      chains[0].focusTo(chains[0].index + 1);
    }
    chains[1].resetFocus();
    chains[1].focusTo(size-index-2);
    
    chains[0].focus.next = null;
    chains[1].focus.next = null;
    
    //creates 2 pairs of linked lists, one for each linechain.
    //00 | 10
    //01 | 11
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
  //for chain breakage without element removeal
  Linechain[] splitLinechain(int index){
    LinkedList<PVector>[] a = chains[0].split(index);  //00 | 10
    LinkedList<PVector>[] b = chains[1].split(index);  //01 | 11
    Linechain[] out = new Linechain[2];
    out[0] = new Linechain(a[0],b[0]);
    out[1] = new Linechain(a[1],b[1]);
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
  PVector getStart(){
    return chains[0].start.o;
  }
  PVector getEnd(){
    return chains[0].last.o;
  }
  //UNCHECKD
  Linechain join(Linechain that, PVector enda, PVector startb){
    
    //my attempt to make things look less disgusting made them look less comprehensible
    //determines which sides of each linechain to glue, then selects linechains accordingly.
    int sidea = this.getEnd() == enda ? 1:-1;
    int sideb = that.getStart() == startb? 1:-1;
    this.chains[(sidea+1)>>1].append(that.chains[(sideb+1)>>1]);
    this.chains[(-sidea+1)>>1].append(that.chains[(-sideb+1)>>1]);
    //linechain that is consumed;
    println(this.size,that.size);
    size += that.size;
    
    that.destroy();
    return this;
    
  }
  void destroy(){
    chains[0].destroy();
    chains[1].destroy();
    size = 0;
  }
  Iterator<PVector> iterator(){
    return chains[0].iterator();
  }
  String toString(){
    return chains[0].toString();
  }
}
// denotes a certian click action from the user, documenting the linechain it has created (Ill deal with node deletion later)
class Action{
  Linechain focus;
  int index;
  PVector point;
  int type;
  //linechain-linechain does not create a point so the index to split is stored instead in index.
  int INDEX = 0, POINT = 1;
  Action(Linechain focus, int index){
    type = INDEX;
    this.focus = focus;
    this.index = index;
  }
  Action(Linechain focus, PVector point){
    type = this.POINT;
    this.focus = focus;
    this.point = point;
  }
}