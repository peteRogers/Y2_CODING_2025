#include <Audio.h>
#include <Wire.h>
#include <SPI.h>
#include <SD.h>
#include <SerialFlash.h>

// GUItool: begin automatically generated code
AudioPlaySdWav           playWav1;     //xy=151,324
AudioEffectFreeverb      freeverb1;      //xy=407,277
AudioOutputI2S           i2s1;           //xy=559,261
AudioConnection          patchCord1(playWav1, 0, freeverb1, 0);
AudioConnection          patchCord2(freeverb1, 0, i2s1, 0);
AudioControlSGTL5000     sgtl5000_1;     //xy=152,223
// GUItool: end automatically generated code


// Use these with the Teensy Audio Shield
#define SDCARD_CS_PIN    10
#define SDCARD_MOSI_PIN  7   // Teensy 4 ignores this, uses pin 11
#define SDCARD_SCK_PIN   14  // Teensy 4 ignores this, uses pin 13


void setup() {
  Serial.begin(9600);
  AudioMemory(8);
  sgtl5000_1.enable();
  sgtl5000_1.volume(0.5);

  SPI.setMOSI(SDCARD_MOSI_PIN);
  SPI.setSCK(SDCARD_SCK_PIN);
  if (!(SD.begin(SDCARD_CS_PIN))) {
    // stop here, but print a message repetitively
    while (1) {
      Serial.println("Unable to access the SD card");
      delay(500);
    }
  }
}



void loop() {
  if(playWav1.isPlaying()==false){
    playWav1.play("BAMBOO.WAV");
  }
   //reverb1.reverbTime(0.5);
  float f = (analogRead(A0) / 1023.0) * 0.9;
  Serial.println(f);
  freeverb1.roomsize(f);
   // filenames are always uppercase 8.3 format
}

