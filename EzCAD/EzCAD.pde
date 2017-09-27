
Screen LEVEL;
FocusListener focus;
void setup(){
  
  size(1200,800);
  //Game g = new Game(5);
  //addKeyboardListener(g);
  //LEVEL = g;
  LEVEL = new TestScreen2();
  focus = null;
}

void draw(){
  checkEvents();
  long time = millis();
  LEVEL.draw();
  strokeWeight(2);
  fill(0);
}

class TestScreen2 extends Screen{
  
  Canvas c;
  TextField textbox;
  TestScreen2(){
    super();
    c = new Canvas(0,0,1000,800,this);
    textbox = new TextField(1000,150,200,200,this);
    new BasicButton(1000,0,200,100,"Load",this){
    
      void elementClicked(){
        makeFile();
      }
      
      
    };
  
  }
  /* Format:
   * [1,2*3,4*5,6*5,22]![]
   * 
   * 
   * 
   */
  void makeFile(){
    PrintWriter file = createWriter(textbox.text+".txt"); 
    ArrayList<Linechain> data = c.linechainlist;
    StringBuilder out = new StringBuilder();
    for(Linechain l :data){
      out.append('[');
      for(PVector v :l){
        out.append(String.format("%d,%d*"));
      }
      out.setCharAt(out.length()-1,']');
      out.append("!");
    }
    out.deleteCharAt(out.length()-1);
    file.print(out.toString());
    file.flush();
    file.close();
  }
  void update(){
    background(255);
    super.update();
  }

}


class TestScreen extends Screen{
  Arrow a;
  TestScreen(){
    super();
    
    
    a= new Arrow(300,300,10,10,5,100,1,this);
    BasicButton b = new BasicButton(100,0,50,50,"test",this){
      int count = 0;
      @Override
      void elementReleased(){
        super.elementReleased();
        count++;
      //  print(count);
      }
      @Override
      void elementHovered(){
        super.elementHovered(); 
        print("AAAAAAAAAHHHH");
      }
    };
    addClickListener(b);
    
    
  }
  void update(){
  //  a.addRotation(0.08);
    resetGraphics();
    background(255);
    
    drawChildren();
    
    requestUpdate();
  }

}