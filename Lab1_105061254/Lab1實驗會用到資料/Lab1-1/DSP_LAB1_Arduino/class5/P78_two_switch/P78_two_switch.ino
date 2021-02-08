int ledPin = 13;
int inPin1 = 6;
int inPin2 = 7;
int val1 = 0; //for inPin1
int val2 = 0; //for inPin2
int delayval = 100; //initial delay time

void setup() {
  pinMode(ledPin, OUTPUT);
  pinMode(inPin1, INPUT);
  pinMode(inPin2, INPUT);
}

void loop() {
  val1 = digitalRead(inPin1);
  val2 = digitalRead(inPin2);
  
  if (val1 == HIGH && val2 == HIGH) //switch 1 off; switch 2 off
    digitalWrite(ledPin, LOW);      //no blink
  else if (val1 == LOW && val2 == HIGH){ //switch 1 on; switch 2 off
    delayval = 100;                      //blink fast
    digitalWrite(ledPin, HIGH);
    delay(delayval);
    digitalWrite(ledPin, LOW);
    delay(delayval);
  }
  else if (val1 == HIGH && val2 == LOW){ //switch 1 off; switch 2 on
    delayval = 1000;                      //blink slow
    digitalWrite(ledPin, HIGH);
    delay(delayval);
    digitalWrite(ledPin, LOW);
    delay(delayval);
  }
  else  //switch 1 on; switch 2 on
    digitalWrite(ledPin, HIGH); //bright continuously
}
