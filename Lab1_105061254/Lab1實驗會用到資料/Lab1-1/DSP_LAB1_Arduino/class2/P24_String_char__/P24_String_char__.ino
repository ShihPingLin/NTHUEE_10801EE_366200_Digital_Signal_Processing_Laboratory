String str = "I love you";
char str2[] = "I love you, too";

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  Serial.println("HELLO, this is a message from your Arduino.");
  Serial.println(str);
  Serial.println(str2);
  Serial.println("---------------------");
  delay(1000);
}
