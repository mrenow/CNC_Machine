import java.awt.event.KeyEvent;
import java.util.LinkedList;
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
  
  void mouseMoved(){
    PVector mouse = localMouse(this);
    pointerpos = mouse;
    float dist;
    ListIterator<PVector> chainiter;
    PVector point;
    float mindist = 36;
    focus = null; 
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