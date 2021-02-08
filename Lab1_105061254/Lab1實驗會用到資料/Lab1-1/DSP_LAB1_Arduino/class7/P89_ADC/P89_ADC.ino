int LEDpin = 9;
int ADCpin = 3;
int val = 0;

void setup() {
  Serial.begin(9600);
  pinMode(9, OUTPUT);
}

void loop() {
  val = analogRead(ADCpin);

  Serial.println(val);
  analogWrite(9, map(val, 0, 1023, 0, 255));
}
