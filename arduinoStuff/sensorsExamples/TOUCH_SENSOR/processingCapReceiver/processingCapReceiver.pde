import processing.serial.*;
Serial myPort;

CapTouch[] touches = new CapTouch[12];


void setup() {
  size(1024, 1024);
  printArray(Serial.list());
  try {
    myPort = new Serial(this, Serial.list()[3], 115200);
  }
  catch(Exception e) {
    println(e);
  }
  for (int i = 0; i < touches.length; i++) {
    touches[i] = new CapTouch();
  }
}



void draw() {
  background(0);


  int center = width / 11;
  for (int i = 0; i  < touches.length; i ++) {
    if (touches[i].getTouch() == 1) {
      fill(255, 255, 255, 100);
      ellipse(center * i, height / 2, 100, 100);
    } else {
      fill(255, 255, 255, 50);
      ellipse(center * i, height / 2, 50, 50);
    }
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
  CapTouch() {
    touched = 0;
  }

  public void setTouched(int t) {
    touched = t;
  }

  public int getTouch() {
    return touched;
  }
}
