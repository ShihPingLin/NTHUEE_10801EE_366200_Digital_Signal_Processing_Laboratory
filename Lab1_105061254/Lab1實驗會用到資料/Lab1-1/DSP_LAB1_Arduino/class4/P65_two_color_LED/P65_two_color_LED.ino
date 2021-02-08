int ledPin1 = 3;
int ledPin2 = 4;

void setup() {
  pinMode(ledPin1, OUTPUT);
  pinMode(ledPin2, OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  digitalWrite(ledPin1, HIGH);
  digitalWrite(ledPin2, LOW);
  delay(1000);
  digitalWrite(ledPin2, HIGH);
  digitalWrite(ledPin1, LOW);
  delay(1000);
}
