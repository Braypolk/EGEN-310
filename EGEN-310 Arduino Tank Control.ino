#include <Wire.h>
#include <Adafruit_MotorShield.h>
#include "utility/Adafruit_MS_PWMServoDriver.h" 

// Create the motor shield object with the default I2C address
Adafruit_MotorShield AFMS = Adafruit_MotorShield(); 

// Select which 'port' M1, M2, M3 or M4. In this case, M1
Adafruit_DCMotor *leftMotor = AFMS.getMotor(4);
Adafruit_DCMotor *rightMotor = AFMS.getMotor(3);
Adafruit_DCMotor *pivotMotor = AFMS.getMotor(2);

//Initialize Variables
String inString = "";    // string to hold input
String left, leftDir, right, rightDir, pivot, pivotDir;

void setup() {
  //start serial communication
    Serial.begin(9600);
    Serial.println("running");
    //turn on motors
    AFMS.begin();
    leftMotor->setSpeed(150);
    rightMotor->setSpeed(150);
    pivotMotor->setSpeed(150);
    leftMotor->run(FORWARD);
    rightMotor->run(FORWARD);
    pivotMotor->run(FORWARD);
    // turn on motor
    leftMotor->run(RELEASE);
    rightMotor->run(RELEASE);
    pivotMotor->run(RELEASE);
}


void loop() {

  //if serial data is recieved, procede with code
  while(Serial.available() == 0){}

  //get data being sent from processing and store as string
  inString = Serial.readStringUntil('\n');
  int i, j, k;

  //store speed and direction of motor 1
  for(i = 0; inString.charAt(i) != ','; i++){}
  
  left = inString.substring(0, i);
  leftDir = inString.substring(i+1, i+2);

  //store speed and direction of motor 2
  for(j = i+3; inString.charAt(j) != ','; j++){}
  
  right = inString.substring(i+3, j);
  rightDir = inString.substring(j+1, j+2);

  //store speed and direction of motor 3
  for(k = j+3; inString.charAt(k) != ','; k++){}
  
  pivot = inString.substring(j+3, k);
  pivotDir = inString.substring(k+1, inString.length());

  //set motor direction based on value stored above
  if(leftDir.toInt() == 1){
    leftMotor->run(FORWARD);
  }
  else{
    leftMotor->run(BACKWARD);
  }

  if(rightDir.toInt() == 0){
    rightMotor->run(BACKWARD);
  }
  else{
    rightMotor->run(FORWARD);
  }
  if(pivotDir.toInt() == 1){     
    pivotMotor->run(BACKWARD);
  }
  else{
    pivotMotor->run(FORWARD);
  }

  //set motor speed
  leftMotor->setSpeed((unsigned int)left.toInt());
  rightMotor->setSpeed((unsigned int)right.toInt());
  pivotMotor->setSpeed((unsigned int)pivot.toInt());

  //delay just enough to not have backup in buffer
  delay(2);
}
