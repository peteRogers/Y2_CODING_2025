# Starter code for FM Radio

```Arduino

#include <Bounce2.h>
Bounce buttonA = Bounce();

void setup() {
  buttonA.attach( 8 ,  INPUT_PULLUP );
  buttonA.interval(20);
  Serial.begin(9600);
}

void loop() {
  buttonA.update();
  if (buttonA.fell() ) {
      Serial.println("pressed");
  }
  if ( buttonA.rose() ) {
      Serial.println("depressed");
  }
}

```
