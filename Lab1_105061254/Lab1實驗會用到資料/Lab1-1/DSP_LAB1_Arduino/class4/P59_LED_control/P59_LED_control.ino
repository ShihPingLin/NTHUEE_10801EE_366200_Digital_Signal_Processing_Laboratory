int ledPin = 3;

void setup() {
  Serial.begin(9600);
  Serial.println("Ready");
  pinMode(ledPin, OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  if (Serial.available()) { //發現有資料尚未被讀取時進入
    char ch = Serial.read();
    Serial.println(ch);

    if (ch == 't') {
      digitalWrite(ledPin, HIGH);
      //delay(1000);
    }
    else if (ch == 'r') {
      digitalWrite(ledPin, LOW);
      //delay(1000);
    }
  }
}
