int x = 0;

void setup() {
  Serial.begin(9600);
}

void loop() {
  x += 1;
  if (x == 100)
    Serial.println(x);
  else if (x == 200)
    Serial.println(x);
  else if (x == 300)
    Serial.println(x);
    
  //delay(10);
}
