#define VELOCITY = 0;
#define FORWARD = true;
#define BACKWARD = false;




//
class StepperDriver{
  
  //velocity mode, 
  
  double stepWidth;
  double length;
  
  
  int mode;
  
  
  
  
  double pos;
  
  unsigned long time; //
  unsigned long timestart;
  long stepsElapsed;
  long stepsMax;
  double stepPeriod;
  double timer;
  boolean direction;
  boolean complete;
  boolean instructionLoaded;
  StepperDriver(double threadWidth, int length){
    stepWidth = threadWidth/200;
    
  
  
  }
  //add time interval onto timer. if timer exceeds step period, subtract one step period from timer, step and increase elapsed steps.
  //also check for overbounds case
  void checkMovement(){
    if(stepsElapsed >=stepsMax){
        complete = true;    
    } 
    timer += (double)(micros()-time);
    time = micros();
    while(timer > stepPeriod){
      step(direction);
      stepsElapsed++; 
    }
  }
  
  void step(boolean dir){
    
  }
  
  
  void loadInstruction(int distance, int period){
    if(distance + pos > length){
      //Error here
      return;
    }
    direction = distance > 0;
    stepsMax = (abs(distance)/stepWidth);
    pos += distance;
    
    
    
    
    instructionLoaded = true;
  }
  

}
