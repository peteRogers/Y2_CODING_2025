int vibr_Pin = 3;

void setup(){
  pinMode(vibr_Pin, INPUT);
  Serial.begin(115200);
}

void loop(){
  long measurement = measureVib();
  if(measurement > 0){
    Serial.println(measurement);
    delay(2);
  }
}

long measureVib(){
  long measurement = pulseIn(vibr_Pin, HIGH);  //wait for the pin to get HIGH and returns measurement
  return measurement;
}
