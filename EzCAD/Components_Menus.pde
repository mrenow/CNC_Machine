
//text functionality, hover highlighting, button highlighting 
class BasicButton extends Button{
  boolean pressed = false;
  
  color DEFAULT_BUTTSTROKE = color(142,169,204);
  color DEFAULT_BUTTBGFILL = color(153,217,234);
 
  final color DEFAULT_STROKEHOVER = color(188,230,243);
  final color DEFAULT_FILLPRESSED = color(188,230,243);
 
/* 
  color fillinactive;
  color strokeinactive;
*/
  color strokehover;
  color fillpressed;
  
  TextBox textbox;
  BasicButton(float x,float y,float w,float h,String text, Container parent){
    super(x,y,w,h,parent);
    
    strokehover = DEFAULT_STROKEHOVER;
    fillpressed = DEFAULT_FILLPRESSED;
    textbox = new TextBox(0,0,w,h,text,this);
    textbox.setFill(DEFAULT_BUTTBGFILL);
    textbox.setStroke(DEFAULT_BUTTSTROKE);
    add(textbox);
    textbox.setPadding(0);
    textbox.textarea.setAlign(CENTER,CENTER);
    
    addClickListener(this);
  }
  
  @Override
  void update(){
    super.update();
   // t.setStroke(t.DEFAULT_STROKE);
    
  }
  void setText(String text){
     textbox.setText(text);
  }
  void elementClicked(){
    textbox.setFill(fillpressed);
    pressed= true;
  }
  void elementReleased(){
    textbox.setFill(DEFAULT_BUTTBGFILL);
    pressed = false;
  }
  
  

  void elementHovered(){
   textbox.setStroke(strokehover);
  
  }
  void elementUnhovered(){
    textbox.setStroke(DEFAULT_BUTTSTROKE);
    if(mousePressed){
      textbox.setFill(DEFAULT_BUTTBGFILL);
      pressed = false;
    }
  }

}