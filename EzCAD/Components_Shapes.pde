//allows for update value of 2, signifies shape update.
abstract class Shape extends Element{
 
  PShape shape;
  Shape(float x, float y , float w, float h, Container p){
    super(x,y,w,h,p);
    
    updatable = 2;
  }
  
  //shapes are intended to be usually static, so most updates will not update the shape. Activated when updatable == 2
  abstract void updateShape();
  @Override
  void checkUpdates(){
    //if an update has been queued for this element do the business

    if(updatable>0){
      if(updatable==2){
        updateShape();  
      }
      updatable = 0;
      update();
    }
    
    
    
    
  }
  

}


//arrow is drawn from point
class Arrow extends Shape{  
  
  //in radians
  float direction;
  
  //other dimensions.
  //if the head width is too large it will draw off the graphics context.
  //No I am not handling that exception. Your bad design taste, your loss.
  
  
  float linelength;
  float headlength;
  float linewidth;
  float headwidth;
  //distance of point from specified destination.
  float offset;
  
  float DEFAULT_OFFSET= 10;
  
  Arrow(float x,float y,float hw, float hl, float lw,float ll,float tilt, Container p){
    super(x,y,ll+10,hw,p);
    direction = tilt;
    linelength = ll;
    headlength = hl;
    linewidth = lw;
    headwidth = hw;
    offset = DEFAULT_OFFSET;
    
    
  }
  //will rotate the component before drawing.
  @Override
  void applyTransform(){
    //translate 0,0 to tip
    pg().translate(pos.x+w,pos.y+h/2);
    //rotate around tip
    pg().rotate(direction);
    pg().translate(-w-offset,-h/2);
  }
  void update(){
    resetGraphics();
    
    g.shape(shape);
    
  }
  void updateShape(){
    //It draws an arrow.
    //trust me.
    shape = createShape();
    shape.beginShape(7);
    shape.fill(0);
    //shape.strokeWeight(0);
    shape.vertex(0,(headwidth-linewidth)/2);
    shape.vertex(linelength-headlength, (headwidth-linewidth)/2);
    shape.vertex(linelength-headlength,0);
    shape.vertex(linelength,headwidth/2);
    shape.vertex(linelength-headlength,headwidth);
    shape.vertex(linelength-headlength,(headwidth+linewidth)/2);
    shape.vertex(0,(headwidth+linewidth)/2);
    shape.endShape(CLOSE);
  
  }
  //modify transform
  void addRotation(float ang){
    direction += ang;
  }
  void setRotation(float ang){
    direction = ang;
  }
  void setOffset(float dist){
    offset = dist;
  
  }

} 