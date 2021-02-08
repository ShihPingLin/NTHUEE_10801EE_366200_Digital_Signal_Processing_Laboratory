int ledAPin = 7;
int ledBPin = 6;
int ledCPin = 5;

void setup() {
  pinMode(ledAPin, OUTPUT);
  pinMode(ledBPin, OUTPUT);
  pinMode(ledCPin, OUTPUT);
}

void loop() {
  digitalWrite(ledAPin, HIGH);
  digitalWrite(ledBPin, LOW);
  delay(1000);
  digitalWrite(ledAPin, LOW);
  digitalWrite(ledBPin, HIGH);
  delay(1000);

  digitalWrite(ledCPin, HIGH);
  delay(100);
  digitalWrite(ledCPin, LOW);
  delay(100);
  digitalWrite(ledCPin, HIGH);
  delay(100);
  digitalWrite(ledCPin, LOW);
  delay(100);
}
