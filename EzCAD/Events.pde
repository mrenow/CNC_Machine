//runs all event checkers, except for those that are automatically called by processing eg. mousePressed


abstract interface Listener{
}
//All listeners will check through their element lists for events.


//event checker that is called every tick
void checkEvents(){
  hoverCheck();
    
  
}

void mousePressed(){
  focusCheck();
  mouseClickCheck();
}
void mouseReleased(){
  mouseReleaseCheck();
}
void mouseMoved(){
  mouseMovedCheck();

}

boolean cursorWithinBounds(Element e){
  //if the element is not attached to a screen, do not listen for cursor events
  if(!e.isConcrete()) return false;
  PVector pos = e.getGlobalPos();
  return (mouseX>=pos.x&&mouseX<=e.w+pos.x)&&(mouseY>=pos.y && mouseY <=e.h+pos.y);  
}

PVector localMouse(Element e){
  PVector pos = e.getGlobalPos();
  return new PVector(mouseX-pos.x, mouseY-pos.y);
}





/*
HOVERLISTENER
*/
ArrayList<HoverListener> hovereventlist = new ArrayList<HoverListener>();
interface HoverListener extends Listener{
  void elementHovered();
  void elementUnhovered();
}
void hoverCheck(){
  for(HoverListener e: new ArrayList<HoverListener>(hovereventlist)){
    boolean buffercursorhover = cursorWithinBounds((Element)e);
    //if cursorhover changes state, one of the hover events will activate.
    if(((Element)e).cursorhover!=buffercursorhover){
      //if cursor hover is initially false, it will change to true and activate the hover event.
      if(((Element)e).cursorhover){
        e.elementUnhovered();
      }else{
        e.elementHovered();
      }
      ((Element)e).cursorhover = buffercursorhover;
    }
  }
}
void addHoverListener(HoverListener e){
  hovereventlist.add(e);
}
/*
MOUSEMOVEDLISTENER
*/
ArrayList<MovementListener> movementlistenerlist = new ArrayList<MovementListener>();
interface MovementListener extends HoverListener{
  void mouseMoved();
}
void mouseMovedCheck(){
  for(int i = movementlistenerlist.size()-1; i>=0; i--){
    MovementListener e = movementlistenerlist.get(i);
    if(((Element)e).cursorhover){
      e.mouseMoved();
    }
  
  }
}
void addMovementListener(MovementListener e){
  movementlistenerlist.add(e);
}


/*
CLICKLISTENER
*/
ArrayList<ClickListener> clickeventlist = new ArrayList<ClickListener>();
interface ClickListener extends HoverListener{
  
  void elementClicked();
  void elementReleased();
}
void mouseClickCheck(){
  for(int i = clickeventlist.size()-1;i>=0;i--){
    ClickListener e = clickeventlist.get(i);
    if(((Element)e).cursorhover){
      e.elementClicked();
      println(e,"GOT PRESSED",((Element)e).isConcrete());
      break;
    }
  }
}
void mouseReleaseCheck(){
  for(int i = clickeventlist.size()-1;i>=0;i--){
    ClickListener e = clickeventlist.get(i);
    if(((Element)e).cursorhover){
      e.elementReleased();
      break;
    }
  }
}
void addClickListener(ClickListener e){
  addHoverListener(e);
  clickeventlist.add(e);
}

/*
FOCUSLISTENER
*/
ArrayList<FocusListener> focuseventlist = new ArrayList<FocusListener>();
interface FocusListener extends HoverListener{
  void elementFocused();
  void elementUnfocused();
}

void focusCheck(){ 
  //the latest element in the list will gain focus. This is consistent with the order of drawing (last on top). 
  for(FocusListener e: focuseventlist){
    if(((Element)e).cursorhover){
      //if the focus changes, call unfocused on the old focus. Then set the new focus and call focused.
      print("focuscheck",this);
      if(focus != e){
        if(focus != null) focus.elementUnfocused();
        focus = e;
        focus.elementFocused();
      }
    }
  }
}
void addFocusListener(FocusListener e){
  addHoverListener(e);
  focuseventlist.add(e);
}


/*
KEYBOARDLISTENER
*/
//passive listener 
boolean[] keys = new boolean[65536];
int keycode;
ArrayList<KeyboardListener> keyeventlist = new ArrayList<KeyboardListener>();
interface KeyboardListener extends Listener{
  
  void keyPressed();
  void keyReleased();       
  void keyTyped();
}



void keyPressed(){
  keycode = keyCode;
  keys[keyCode] = true;
  for(KeyboardListener e: new ArrayList<KeyboardListener>(keyeventlist)){
    e.keyPressed();
    
  }
}

void keyReleased(){
  keys[keyCode] = false;
  for(KeyboardListener e: new ArrayList<KeyboardListener>(keyeventlist)){
    e.keyReleased();
    
  }
}
void keyTyped(){
  for(KeyboardListener e: new ArrayList<KeyboardListener>(keyeventlist)){
    e.keyTyped();
  }
}
void addKeyboardListener(KeyboardListener e){
  keyeventlist.add(e);
}


//A list of the listener lists. useful when you want to make sure an element is not in any list.
ArrayList[] alllisteners = {hovereventlist,clickeventlist,focuseventlist,keyeventlist};
void removeListener(Element object){
  for(ArrayList list: alllisteners){
    list.remove(object);
  
  }
}