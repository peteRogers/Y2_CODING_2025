import processing.serial.*;
import processing.sound.*;

SoundFile[] file;
Serial myPort;
int numsounds = 9;

CapTouch[] touches = new CapTouch[12];


void setup() {
  size(1024, 1024);
  file = new SoundFile[numsounds];
   for (int i = 0; i < numsounds; i++) {
    file[i] = new SoundFile(this, (i+1) + ".wav");
  }
  printArray(Serial.list());
  try {
    myPort = new Serial(this, Serial.list()[5], 115200);
  }
  catch(Exception e) {
    println(e);
  }
  for (int i = 0; i < touches.length; i++) {
    touches[i] = new CapTouch();
  }
}



void draw() {
  background(173,216,230);


  int center = width / 11;
  for (int i = 0; i  < touches.length; i ++) {
    if (touches[i].getTouch() == 1) {
      fill(255, 255, 255, 100);
      rect(center * i, height / 2, 90, 300);
      
      //if(file[0].isPlaying() == false){
        if(touches[i].isDown == false){
          println(i);
          file[i].play( 1.0);
          
          touches[i].isDown = true;
        }
      
     
    } else {
      fill(255, 255, 255);
     // file[0].pause();
      rect(center * i, height / 2, 90, 300);
       fill(0, 0,0);
       rect((center * i)+40, height / 2, 60, 200);
    }
  }
  for (int i = 0; i  < touches.length; i ++) {
    fill(0, 0,0);
    rect((center * i)+40, height / 2, 60, 200);
       
  }
}


void serialEvent (Serial p) {
  String inString = p.readStringUntil('\n');
  if (inString != null) {
    inString = trim(inString);
    String[] sensorArray = split(inString, '>');
    int pin = int(sensorArray[0]);
    touches[pin].setTouched(int(sensorArray[1]));
  }
}




class CapTouch {
  private int touched;
  Boolean isDown = false;
  CapTouch() {
    touched = 0;
  }

  public void setTouched(int t) {
    touched = t;
    if(t == 0){
      isDown = false;
    }
  }

  public int getTouch() {
    return touched;
  }
}
