int stepPin = 22;
int dirPin = 24;
int dirActivationPin = 25;
int stepActivationPin = 23; 

boolean dir = false;


void setup(){
  Serial.begin(9600);
  Serial.println("Drv Test Begin");
  pinMode(stepPin,OUTPUT);
  pinMode(dirPin,OUTPUT);
  pinMode(stepActivationPin,OUTPUT);
  pinMode(dirActivationPin,OUTPUT);


}

void loop(){
  if(digitalRead(stepActivationPin)== HIGH){
    digitalWrite(stepPin, HIGH);
    delayMicroseconds(2);
    digitalWrite(stepPin, LOW);
    delayMicroseconds(100);
    Serial.print("Step");
    Serial.println(dir);
  } 
  digitalWrite(dirPin,digitalRead(dirActivationPin));
  dir = digitalRead(dirActivationPin) == HIGH;
}
