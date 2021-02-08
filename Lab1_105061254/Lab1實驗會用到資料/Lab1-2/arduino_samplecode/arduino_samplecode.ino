int pot = A0;
int val = 0;
int start_time;
int now_time;


void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  pinMode(pot,INPUT);
}

void loop() {
  // put your main code here, to run repeatedly:

  start_time = micros();

  val = analogRead(pot);    //read analog input

  //val = map(/**************/);    //mapping  //not required in lab1-2

  Serial.println(val,DEC);     //print on Matlab  

  now_time = micros();    
  
  //micros : returns the number of microseconds(10^-6 s) since the 
  //Arduino board began running current program
  while(now_time-start_time<12500){    //sampling period 所以目前sampling period = 5000 * 10^-6 = 0.005(s)
    now_time = micros();              //sampling rate = 1 / 0.005 = 200(Hz)
    //公式：sampling period = 1 / (fs * 10^-6)
    //80Hz：sampling period = 12500
    //100Hz：sampling period = 10000
    //200Hz：sampling period = 5000
    //500Hz：sampling period = 2000
  }
}
