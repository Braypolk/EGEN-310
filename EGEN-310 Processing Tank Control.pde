//import necessary libraries
import org.gamecontrolplus.gui.*;
import org.gamecontrolplus.*;
import net.java.games.input.*;
import processing.serial.*;

//initialize variables
Serial myPort;
ControlIO control;
ControlDevice stick;
float left, right, pivot;
short leftSend, rightSend, pivotSend, mult, leftDir, rightDir, pivotDir;
boolean normal, slow, slowest, STOP;

public void setup() {
  //start program and serial communication
  size(400, 400);
  myPort = new Serial(this, "COM3", 9600); // Starts the serial communication between hc05 and computer
  myPort.bufferUntil('\n');
  // Initialise the ControlIO
  control = ControlIO.getInstance(this);
  // Find a device that matches the configuration file, if none exists, quit program
  stick = control.getMatchedDevice("tankDrive");
  if (stick == null) {
    println("No suitable device configured");
    System.exit(-1); // End the program NOW!
  }
}

// Poll for user input called from the draw() method.
public void getUserInput() {
  //configure sliders and buttons for tank drive
  left = stick.getSlider("LEFT").getValue();
  right = stick.getSlider("RIGHT").getValue();
  pivot = stick.getSlider("PIVOT").getValue();
  normal = stick.getButton("NORMAL").pressed();
  slow = stick.getButton("SLOW").pressed();
  slowest = stick.getButton("SLOWEST").pressed();
  STOP = stick.getButton("STOP").pressed();
  
}

//from user input, multiply values to get a value from 0-255
public void act(){
  //stop all motors
  if(STOP){
    left = 0;
    right = 0;
    pivot = 0;
    return;
  }
  if(slow){
    mult = 140;
  }
  else if(slowest){
    mult = 80;
  }
  else{
    mult = 255;
  }
  
  //send to new function to each value is correctly set
  //each function sets direction and speed for specified motor
  left();
  right();
  pivot();
}

public void left(){
  if(left > 0){
    left *= mult;
    leftDir = 0;
    
  }
  if(left < 0){
   left = Math.abs(left * mult);
   leftDir = 1;
  }
  if(left > -5 && left < 5){
    left = 0;
  }
  
}

public void right(){
  if(right > 0){
    right *= mult;
    rightDir = 0;
    
  }
  
  if(right < 0){
   right = Math.abs(right * mult);
   rightDir = 1;
   
  }
 
  if(right > -5 && right < 5){
    right = 0;
  }
}
 
public void pivot(){
  if(pivot > 0){
    pivot *= mult;
    pivotDir = 0;
    
  }
  
  if(pivot < 0){
   pivot = Math.abs(pivot * mult);
   pivotDir = 1;
   
  }
 
  if(pivot > -5 && pivot < 5){
    pivot = 0;
  }
}

public void draw() {
  getUserInput();
  act();

  //convert from long to short in order to be converted again
  leftSend = (short)left;
  rightSend = (short)right;
  pivotSend = (short)pivot;
  
  //send data to hc-05 as a string
  myPort.write(str(leftSend) + "," + str(leftDir)+"," + str(rightSend) + ","+str(rightDir)+","+str(pivotSend)+","+str(pivotDir)+"\n");
  println(left+" "+right+" "+ pivot);
}
