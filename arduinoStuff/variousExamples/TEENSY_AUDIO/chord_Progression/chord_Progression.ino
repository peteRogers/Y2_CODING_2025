#include <Audio.h>
#include <Wire.h>
#include <SPI.h>
#include <SD.h>
#include <SerialFlash.h>

// Audio objects
AudioSynthWaveform waveform1;
AudioSynthWaveform waveform2;
AudioSynthWaveform waveform3;
AudioSynthWaveform waveform4;
AudioSynthWaveform melodyWaveform;
AudioMixer4 mixer;
AudioOutputI2S output;
AudioConnection patchCord1(waveform1, 0, mixer, 0);
AudioConnection patchCord2(waveform2, 0, mixer, 1);
AudioConnection patchCord3(waveform3, 0, mixer, 2);
AudioConnection patchCord4(waveform4, 0, mixer, 3);
AudioConnection patchCord5(melodyWaveform, 0, mixer, 0);
AudioConnection patchCord6(mixer, 0, output, 0);
AudioConnection patchCord7(mixer, 0, output, 1);
AudioControlSGTL5000     sgtl5000_1;
// Analog sensor pin
const int sensorPin = A0;

// Amplitudes and chords
const float amplitude = 0.25;
int chordIndex = 0;

// Chord frequencies (in Hz)
float chords[5][4] = {
  {261.63, 329.63, 392.00, 493.88},  // Cmaj7: C, E, G, B
  {293.66, 349.23, 440.00, 523.25},  // D7: D, F#, A, C
  {329.63, 392.00, 493.88, 587.33},  // Em7: E, G, B, D
  {349.23, 440.00, 523.25, 659.26}
 
};

// Melody notes (in Hz)
float melodyNotes[8] = {261.63, 293.66, 329.63, 349.23, 392.00, 440.00, 493.88, 523.25}; // C, D, E, F, G, A, B, C
int melodyIndex = 0;
unsigned long previousMelodyTime = 0;
const unsigned long melodyInterval = 300; // Time between melody notes in milliseconds

void setup() {
  AudioMemory(10);
    sgtl5000_1.enable();
  sgtl5000_1.volume(0.5);
  // Set waveform types
  waveform1.begin(WAVEFORM_SINE);
  waveform2.begin(WAVEFORM_SINE);
  waveform3.begin(WAVEFORM_SINE);
  waveform4.begin(WAVEFORM_SINE);
  melodyWaveform.begin(WAVEFORM_SINE);

  // Set amplitudes
  waveform1.amplitude(amplitude);
  waveform2.amplitude(amplitude);
  waveform3.amplitude(amplitude);
  waveform4.amplitude(amplitude);
  melodyWaveform.amplitude(amplitude * 0.5); // Melody at half the amplitude of chords

  Serial.begin(9600);
}

void loop() {
  // Read the sensor value and map it to the chord index
  int sensorValue = analogRead(sensorPin);
  chordIndex = map(sensorValue, 0, 1023, 0, 3); // Map to 0-4 for 5 chords

  // Set frequencies for the selected chord
  waveform1.frequency(chords[chordIndex][0]);
  waveform2.frequency(chords[chordIndex][1]);
  waveform3.frequency(chords[chordIndex][2]);
  waveform4.frequency(chords[chordIndex][3]);

  // Play melody notes as the sensor value increases
  if (millis() - previousMelodyTime > melodyInterval) {
    previousMelodyTime = millis();

    // Map sensor value to melody index
    melodyIndex = map(sensorValue, 0, 1023, 0, 7); // Map to 0-7 for 8 melody notes

    // Set the melody waveform frequency
    melodyWaveform.frequency(melodyNotes[melodyIndex]);

    // Debugging output
    Serial.print("Playing chord index: ");
    Serial.print(chordIndex);
    Serial.print(" | Melody note frequency: ");
    Serial.println(melodyNotes[melodyIndex]);
  }

  delay(50); // Small delay for smoother transitions
}
