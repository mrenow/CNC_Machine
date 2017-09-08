//A plain rectangle
class Box extends Element{
  
  final color DEFAULT_STROKE = color(0);
  final color DEFAULT_BGFILL = color(255);
  
  //color data
  color stroke;
  color bgfill;
  
  Box(float x, float y, float w, float h,Container parent){
    super(x,y,w,h,parent);
    stroke = DEFAULT_STROKE;
    bgfill = DEFAULT_BGFILL;
  }
  void update(){
    resetGraphics();
    
    g.stroke(stroke);
    g.fill(bgfill);
    g.rect(0,0,w,h);
    
  }
  void setStroke(float r,float g, float b){
    stroke = color(r,g,b);
    requestUpdate();
  }
  void setFill(float r,float g, float b){
    bgfill = color(r,g,b);
    requestUpdate();
  }
  void setStroke(color c){
    stroke = color(c);
    requestUpdate();
  }
  void setFill(color c){
    bgfill = color(c);
    requestUpdate();
  }
  
  
  
}


//A button is a container without graphics that allows for a click and hover event.
//All visible parts of a button are derived from its children.
//Functions: classes that extend must implement ClickListener
abstract class Button extends Container implements ClickListener{
  Button(float x, float y, float w, float h, Container parent){
    super(x,y,w,h,parent);
  }
}


//Fields: text, padding,border,line spacing, text color, font/size , ?text wrap , default values for all layout and color included.
class Text extends Element{
  
  final color DEFAULT_TEXTFILL = color(0);
  
  final PFont DEFAULT_FONT = createFont("Arial", 20); 
  
  
  String text;
  color textfill;
  PFont font;
  int alignx ,aligny;
  
  //does nothing atm
  boolean textwrapping;

    
  Text(float x, float y, float w, float h, String text, Container parent){
    super(x,y,w,h,parent);
    
    this.text = text;
    this.parent = parent;
    textfill = DEFAULT_TEXTFILL;
    font = DEFAULT_FONT;  
    alignx = LEFT;
    aligny = TOP;
  
  }
  @Override
  void update(){
    resetGraphics();
    
    g.fill(textfill);
    g.textFont(font);
    g.textAlign(alignx,aligny);
    g.text(text,0,0,w,h);
    
  }
  void setText(String text){
    this.text = text;
    requestUpdate();
  
  }
  void setFont(String fontname,float size){
    font = createFont(fontname,size);
    requestUpdate();
  }
  void setAlign(int x, int y){
    alignx = x;
    aligny = y;
    requestUpdate();
  
  }
}


class TextBox extends Container {

  final float DEFAULT_PADDING = 10;
  final float DEFAULT_LINEGAP = 0;
  
  Text textarea;
  Box box;
  
  
  float padding;
  float border;
  float linegap;
  //basic constructor for rectangle bounds and text
  TextBox(float x, float y, float w, float h, String t, Container parent){
    super(x,y,w,h,parent);
    box = new Box(0,0,w,h,this);
    textarea = new Text(0,0,w,h,t,this);
    this.parent = parent;
    setPadding(DEFAULT_PADDING);
    //unused
    /*
    padding = DEFAULT_PADDING;
    linegap = DEFAULT_LINEGAP;
     */
  }
  
  
  //DODGY FIX AFTER GAME
  void setText(String text){
    textarea.setText(text);
    requestUpdate();
  }
    void setStroke(float r,float g, float b){
    box.setStroke(r,g,b);
    requestUpdate();
  }
  void setFill(float r,float g, float b){
    box.setFill(r,g,b);
    requestUpdate();
  }
  void setStroke(color c){
    box.setStroke(c);
    requestUpdate();
  }
  void setFill(color c){
    box.setFill(c);
    requestUpdate();
  }
  void setFont(String s, float size){
    textarea.setFont(s,size);
    requestUpdate();
  }
  void setPadding(float p){
    textarea.setPosition(p,p);
    textarea.setDimensions(w-2*p,h-2*p);
    requestUpdate();
  }
}

class TextField extends Text implements FocusListener,KeyboardListener{
  
  int cursorblinkvalue = 59;
  
  TextField(float x, float y, float w, float h, Container parent){
    super(x,y,w,h,"",parent);
    addFocusListener(this);
    addKeyboardListener(this);
    
    
  }
  
  @Override
  void update(){
    resetGraphics();
    
    g.fill(textfill);
    g.textFont(font);
    if(cursorblinkvalue%60 <=30){
      g.text(text+'|',0,0,w,h);
      
    }else{
      g.text(text,0,0,w,h);
    }
    
    
    //will continue to update every tick as long as item is focused.
    if(focus==this){
      cursorblinkvalue++;
      requestUpdate();
    }
  }
  
  void elementHovered(){}
  void elementUnhovered(){}
  void elementFocused(){
    requestUpdate();
  }
  void elementUnfocused(){
    cursorblinkvalue=59;
    requestUpdate();
  }
  
  void keyPressed(){}
  void keyReleased(){}       
  void keyTyped(){
    if(focus==this){
      if(keycode == 8){
        if(text.length()>0){
        text = text.substring(0,text.length()-1);
        }
      }else{
      text += key;
      cursorblinkvalue = 59;
      requestUpdate();
      }
    }
    
  }
}
/*
  //deals with text wrapping.
  void update() {
    String[] words = text.split(" ");
    g = createGraphics((int)w+1,(int)h+1 );
    
    
    g.fill(bgfill);
    g.rect(0,0,w,h);
    g.fill(textfill);
    g.textFont(font);

    //maximum text height + line gap
    float lineheight = font.descent()+font.ascent()+font.getSize() + linegap;
    
    float linewidth = w - padding*2;
    
    //index in words
    int i = 0;
    
    int row = 1;
    while (i<words.length && lineheight*(row-1)<h) {
      String line = "";
      
      
      //if the current word exceeds box width, the word will be wrapped to the next line.
      if(linewidth<g.textWidth(words[i])){
        
        //index in string;
        int j = 0;
        
        //counts up each letter until the length of the line is exceeded. Draws to screen and moves to next row.
        //Repeats until word is exhausted of characters.
        while(lineheight*(row-1)<h){
          String nextline = line + words[i].charAt(j);
          do{
            line = nextline;
            j++;
          }while(j<words[i].length() && linewidth>g.textWidth(nextline = (line+words[i].charAt(j))));
          
          line += " ";
          
          //when word finishes writing, break out of the loop without resetting line as we have not yet reached the end of the line.
          if(j>=words[i].length()){
            break;
          } 
          g.text(line, padding, lineheight*row+padding);
          row++;
          line = "";
          
        }
        i++;
      }
      
      //then normal text wrapping to the end of the line.
      while (i<words.length&& linewidth>g.textWidth(words[i]+line)) {
        line += words[i]+" ";
        i++;
      }
      g.text(line, padding, lineheight*row+padding);
      row++;
    }
    
  }
  */