
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
  void makeFile(){
    PrintWriter file = createWriter(textbox.text+".txt"); 
    ArrayList<PVector[]> data = c.linedata;
    for(PVector[] line : data){
      String s = String.format("0%f,1%f,2%f,3%f.",line[0].x,line[0].y,line[1].x,line[1].y);
      file.print(s);
    }
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