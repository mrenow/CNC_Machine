int stepPin = 22;
int dirPin = 24;
int stepDecreasePin = 25;
int stepIncreasePin = 23; 



int time;
boolean dir = false;

// internal clock is in microseconds

//Programs will be loaded by serial into the program buffer.
/*
wait for "ready" signal from usb
Recieve program strings one by one until buffer is full.
When a program is completed, notify the computer via serial.
recieve new program
if new program is the terminator program, do not notify.
once terminator program is run, move to 0,0,0 and movee ito base state.

Instructions are sent to each stepper driver. Instructions consist of:
- Time interval
- Displacement on axis



*/
String[10] programqueue;
int queuestartindex = 0;

StepperDriver[3] m = new Seppe

void setup(){
  Serial.begin(9600);
  Serial.println("Drv Test Begin");
  pinMode(stepPin,OUTPUT);
  pinMode(dirPin,OUTPUT);
  pinMode(stepActivationPin,OUTPUT);
  pinMode(dirActivationPin,OUTPUT);
  time = millis();
}

void loop(){
  //run until all motors finish.
  if(m[0].complete && m[1].complete && m[2].complete){
    
  }else{
    m[0].checkmovement();
    m[1].checkmovement();
    n[2].checkmovement(); 
  }
  
  if(programqueue. )
  
  
}


void checkTimetables(){
  f

}
