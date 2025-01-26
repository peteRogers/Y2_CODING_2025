#include <SPI.h>
#include <RDA5807.h>
#include <Bounce2.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
Bounce buttonUp = Bounce();
Bounce buttonDown = Bounce();
RDA5807 rx;
#define OLED_MOSI 9
#define OLED_CLK 10
#define OLED_DC 11
#define OLED_CS 12
#define OLED_RESET 13
Adafruit_SSD1306 display(128, 64, OLED_MOSI, OLED_CLK, OLED_DC, OLED_RESET, OLED_CS);
float freq = 0.0;


void setup() {
  Serial.begin(9600);
  //display code
  if (!display.begin(SSD1306_SWITCHCAPVCC)) {
    Serial.println(F("SSD1306 allocation failed"));
    for (;;)
      ;  // Don't proceed, loop forever
  }
  //buttons
  buttonUp.attach(7, INPUT_PULLUP);    // Arduino pin 7 - Seek station up
  buttonDown.attach(8, INPUT_PULLUP);  // Arduino pin 8 - Seek station down
  buttonUp.interval(20);
  buttonDown.interval(20);
  //radio setup
  rx.setup();              // Starts the receiver with default parameters
  rx.setLnaPortSel(3);     // Trying improve sensitivity.
  rx.setAFC(true);         // Sets Automatic Frequency Control
  rx.setFmDeemphasis(1);   //sorts for Europe broadcasting
  rx.setFrequency(10000);  // Tunes in 97.3 MHz  - Switch to your local favorite station
  rx.setVolume(4);
}//end setup function 

void loop() {
  buttonUp.update();
  buttonDown.update();
  if (buttonUp.fell()) {
    rx.seek(RDA_SEEK_WRAP, RDA_SEEK_DOWN, showStatus);
  }
  if (buttonDown.fell()) {
    rx.seek(RDA_SEEK_WRAP, RDA_SEEK_UP, showStatus);
  }
  //display code
  display.clearDisplay();
  display.setTextSize(2);
  display.setTextColor(WHITE);
  display.setCursor(10, 10);
  display.print(freq);
  for (int i = 0; i < rx.getVolume(); i++) {
    display.drawRect(10 + (i * 10), 50, 10, 14, WHITE);
  }
  display.display();
}//end loop function

void showStatus() {
  freq = rx.getFrequency() / 100.0;
}
