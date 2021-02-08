#include <Wire.h>
#include <SPI.h>
#include <Adafruit_LSM9DS0.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include <SoftwareSerial.h>
#define OLED_RESET 6

Adafruit_SSD1306 display(OLED_RESET);
Adafruit_LSM9DS0 lsm = Adafruit_LSM9DS0();

int start_time;
int now_time;

float threshold = 1500.0;  // Most important hyperparameter****************************************************************
int w_len = 15;         // The length of trangular filter
float w[] = {0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1, 0.875, 0.75, 0.625, 0.5, 0.375, 0.25, 0.125};
float buffer_w[] = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0};   // Buffer for filter

int peak_buf = 7;       // The length of peak buffer
float buffer_peak[] = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
float difference[] = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
int peak, valley; // The value of peak and valley
int peak_pos, valley_pos;
bool peak_yes, valley_yes;

int count_num;  // dealing with initial value problem

float maximum , minimum;

int steps;
String val;

int initialx, initialy, initialz;

void setupSensor() {
  lsm.setupAccel(lsm.LSM9DS0_ACCELRANGE_2G);
}
  
void setup() {
  display.begin(SSD1306_SWITCHCAPVCC, 0x3C);
  
  while (!Serial);
  Serial.begin(19200);
  Serial.println("Starting communication");

  if (!lsm.begin()) {
    Serial.println("Something went wrong, check your connections");
    while(1);
  }
  Serial.println("Connection established");
  Serial.println("");
  Serial.println("");

  // Read the first data
  lsm.read();
  initialx = (int)lsm.accelData.x;
  initialy = (int)lsm.accelData.y;
  initialz = (int)lsm.accelData.z;

  maximum = 0;
  minimum = 1000000;
  peak = 0;
  valley = 0;
  peak_pos = 0;
  valley_pos = 0;
  peak_yes = false;
  valley_yes = false;
  count_num = 0;
  steps = 0;
}

void loop() {  
  float value = 0, abs_value;
  int j;
  
  start_time = micros();
  
  lsm.read();
  if (count_num < 20)
    count_num = count_num + 1;  // to avoid initial problem

  abs_value = abs((int)lsm.accelData.x) + abs((int)lsm.accelData.y) + abs((int)lsm.accelData.z);
  
  // 1. Update the buffer values for the filter
  for (j = 0; j < w_len - 1; j++)
    buffer_w[j] = buffer_w[j+1];
  buffer_w[w_len-1] = abs_value;

  // 2. Trangular filter
  for (j = 0; j < w_len; j++)
    value = value + buffer_w[j] * w[j];
  value = value / w_len;
  
  // 3. Update buffer value for find peak
  // Using value after triangular filter
  for (j = 0; j < peak_buf - 1; j++)
    buffer_peak[j] = buffer_peak[j+1];
  buffer_peak[peak_buf-1] = value;

  // 4. Difference filter for finding peak
  for (j = 0; j < peak_buf - 1; j++)
    difference[j] = buffer_peak[j+1] - buffer_peak[j];

  // 5. find peak
  if (difference[0] >= 0 && difference[1] >= 0 && difference[2] >= 0 && difference[3] < 0 &&
      difference[4] < 0 && difference[5] < 0){
        peak = buffer_peak[3];
        peak_yes = true;
  }
  else if (difference[0] < 0 && difference[1] < 0 && difference[2] < 0 && difference[3] >= 0 &&
           difference[4] >= 0 && difference[5] >= 0){
       valley = buffer_peak[3];
       valley_yes = true;
  }

  // 6. find local maximum and local minimum
  if (value > maximum && value >= 0 && count_num >= 20)
    maximum = value;
  if (value < minimum && value >= 0 && count_num >= 20)
    minimum = value;

  Serial.println(maximum - minimum);  // for debug
  // 7. Setting threshold and identity a step
  if (peak_yes == true && valley_yes == true && (maximum - minimum) > threshold) {// && (peak - valley) > threshold2) {
    peak_yes = false;
    valley_yes = false;
    steps = steps + 1;
      
    maximum = 0;
    minimum = 10000000;
  }

  // Display
  display.clearDisplay();     //清除螢幕
  display.setTextSize(2);     //設定文字大小(最小是1)
  display.setTextColor(WHITE);//設定文字顏色
  display.setCursor(0,0);     //設定文字起始位置，以x,y座標指定
  display.print("Step=");     //時鐘的下一行印出步數
  display.print(steps);
  display.display();          //把上述資訊送往螢幕
  
  now_time = micros();
  // initial sampling rate : 287Hz
  // set sampling rate : 50Hz
  while(now_time - start_time < 20000){   //sampling period 所以目前sampling period = 5000 * 10^-6 = 0.005(s)
    now_time = micros();                 //sampling rate = 1 / 0.005 = 200(Hz)
    //公式：sampling period = 1 / (fs * 10^-6)
    //80Hz：sampling period = 12500
    //100Hz：sampling period = 10000
    //200Hz：sampling period = 5000 //will have problems
    //500Hz：sampling period = 2000 //will have problems
  }

  //Serial.println(now_time - start_time);  // for debug
}
