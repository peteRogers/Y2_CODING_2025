#include <Audio.h>
#include <Wire.h>
#include <SPI.h>
#include <SD.h>
#include <SerialFlash.h>

#include <synth_simple_drum.h>

#include <Audio.h>
#include <Wire.h>
#include <SPI.h>
#include <SD.h>
#include <SerialFlash.h>

// GUItool: begin automatically generated code

AudioSynthSimpleDrum     drum1;          //xy=431,197

AudioMixer4              mixer1;         //xy=737,265
AudioOutputI2S           i2s1;           //xy=979,214
AudioConnection          patchCord1(drum1, 0, mixer1, 1);

AudioConnection          patchCord5(mixer1, 0, i2s1, 0);
AudioConnection          patchCord6(mixer1, 0, i2s1, 1);
AudioControlSGTL5000     sgtl5000_1;     //xy=930,518
// GUItool: end automatically generated code

static uint32_t next;

void setup() {
  // put your setup code here, to run once:

  Serial.begin(115200);

  // audio library init
  AudioMemory(15);

  next = millis() + 1000;

  AudioNoInterrupts();

  drum1.frequency(1200);
  drum1.length(150);
  drum1.secondMix(1.0);
  drum1.pitchMod(1.0);
  
  
  
  sgtl5000_1.enable();
  sgtl5000_1.volume(0.5);

  AudioInterrupts();

}

void loop() {
  // put your main code here, to run repeatedly:
  
  drum1.noteOn();
  drum1.frequency(analogRead(A0));
  delay(200);
}
