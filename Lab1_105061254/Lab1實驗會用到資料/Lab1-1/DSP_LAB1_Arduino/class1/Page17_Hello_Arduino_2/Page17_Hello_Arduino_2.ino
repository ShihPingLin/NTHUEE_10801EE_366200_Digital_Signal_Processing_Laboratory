void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  Serial.println("HELLO, this is a message from your Arduino.");
  Serial.println("What's 7X11?");
  Serial.println("7X11 = ");
  Serial.println(7*11, DEC);
  Serial.println("---------------------");
  delay(1000);
}
