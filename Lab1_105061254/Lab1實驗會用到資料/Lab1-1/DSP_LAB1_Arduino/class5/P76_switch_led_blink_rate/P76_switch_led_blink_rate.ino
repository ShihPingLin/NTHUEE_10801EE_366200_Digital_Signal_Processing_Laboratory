int ledPin = 13;
int inPin = 7;
int val = 0;
int delayval = 100; //initial delay time

void setup() {
  pinMode(ledPin, OUTPUT);
  pinMode(inPin, INPUT);
}

void loop() {
  val = digitalRead(inPin);
  if (val == HIGH)
    delayval = 1000;
  else
    delayval = 100;
  digitalWrite(ledPin, HIGH);
  delay(delayval);
  digitalWrite(ledPin, LOW);
  delay(delayval);
}
