#include <RDA5807.h>

RDA5807 rx; 
float freq = 0.0;



void setup() {
  Serial.begin(9600);
  //radio setup
  rx.setup(); // Starts the receiver with default parameters
  rx.setLnaPortSel(3);  // Trying improve sensitivity.
  rx.setAFC(true);      // Sets Automatic Frequency Control
  rx.setFmDeemphasis(1); //sorts for Europe broadcasting
  rx.setFrequency(9730); // Tunes in 97.3 MHz  - Switch to your local favorite station
  rx.setVolume(4);
}

void loop() {
  //rx.seek(RDA_SEEK_WRAP,RDA_SEEK_DOWN, showStatus);
  Serial.println(freq);
  delay(50);
 
}

void showStatus() {
 freq = rx.getFrequency()/100.0;
}
