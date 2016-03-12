
import g4p_controls.*; //g4p library contains all GUI objects
import processing.serial.*; //serial library contains UART tools

// Static images for GUI
PImage logo;
PImage title;
PImage name;


// Set up either the simple or debug GUI
boolean advanced = false;

// Required by langauge. Called once on boot.
public void setup(){
  //Setup window
  if (advanced == true) {
     size(500, 800, JAVA2D);
  } else {
     size(500, 450, JAVA2D); 
  }
  
  //Setup static images
  logo = loadImage("logo.png");
  title = loadImage("title.png");
  name = loadImage("name.png");
  
  //Build GUI
  createGUI();   
}

// Required by langauge. Called repeatedly after public void setup() 
public void draw(){
  //Draw the GUI frame.
  background(255);
  image(logo, 125, 10);
  image(title, 147, 35);
}


