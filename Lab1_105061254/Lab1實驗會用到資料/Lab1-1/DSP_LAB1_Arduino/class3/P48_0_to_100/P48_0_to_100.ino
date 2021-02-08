int x = 0;

void setup() {
  Serial.begin(9600);
}

void loop() {
  x += 1;
  if (x > 100){
    x = 0;
  }
  else{
    Serial.println(x);
  }
  delay(100);
}
