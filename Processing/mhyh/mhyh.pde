// Need G4P library
import g4p_controls.*;
import processing.serial.*;
import cc.arduino.*;

Arduino arduino;

PImage logo;
PImage title;
PImage name;

boolean advanced = true;

public void setup(){
  if (advanced == true) {
     size(500, 800, JAVA2D);
  } else {
     size(500, 450, JAVA2D); 
  }
  logo = loadImage("logo.png");
  title = loadImage("title.png");
  name = loadImage("name.png");
  
  createGUI();   
}

public void draw(){
  background(255);
  image(logo, 125, 10);
  image(title, 147, 35);
    
  if (running == true) {
     //println_log("running");
     if (ack != true) {
       
     }
  } else {
     //println_log("not running"); 
  }
 
}


