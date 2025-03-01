
#include <ESP32Servo.h>
#include <ESP32PWM.h>

// Published values for SG90 servos; adjust if needed 
int minUs  =    1000;
int maxUs  =    12000;
  
#define Units  5

Servo servos[Units] = { Servo(), Servo(), Servo(), Servo(), Servo() };
  
int ServoPin[Units] = {26,27,14,12,13}; //{13,14,26,33};
int Sensor[Units] = {34,35,32,33,25}; //{35,27,25,32};
int sflip[Units] = {0,0,0,0};


//ESP32PWM pwm;
int unit = 0;

int gamemode = 0;


void servo_move(int which, int angle)
{
  if (sflip[which])
    angle = 180 - angle;
  servos[which].write(angle);
  //Serial.printf(" -- MOVED(%d) to %d\n", which, angle);
}

void targetUpMulti(int u) {
  for (int i=0; i<Units; i++)
    if (u & (1<<i)) servo_move(i, 170);
  delay(500);
  for (int i=0; i<Units; i++)
    servo_move(i, 70);
  delay(300);
}

void targetUp(int u) {
  Serial.printf("--- Target %d UP\n", u);
  servo_move(u, 170);
  delay(500);
  servo_move(u, 70);  
  delay(300);      
}


void targetDownMulti(int u) {
  Serial.printf("-- DOWN Multi:%X ", u);
  for (int i=0; i<Units; i++) {
    if (u & (1<<i)) {
      servo_move(i, 0);
      Serial.printf(" %d", i);
    }
  }
  Serial.println();
  
  delay(500);
  for (int i=0; i<Units; i++)
    servo_move(i, 70);
  delay(300);
}

void targetDown(int u)
{
  Serial.printf("--- Target %d DOWN", u);
  servo_move(u, 0);
  delay(450);
  servo_move(u, 70);   
  delay(300);     
}

int score = 0;

void setup() {
  // put your setup code here, to run once:
 
  // allocate timers
  ESP32PWM::allocateTimer(0);
  ESP32PWM::allocateTimer(1);
  ESP32PWM::allocateTimer(2);
  ESP32PWM::allocateTimer(3);


  Serial.begin(115200);
  while (!Serial);

  Serial.println("----------------------------------------------------------");
  Serial.println("Electronic knock-down target system");
  Serial.println("Game Modes:");
  Serial.println("0: All targets at once. Unlimioted count.");
  Serial.println("1: One target at once. Random selection.");
  Serial.println("Number of down targets at power on sets game mode.");

  for (int i=0; i<Units; i++) {
    servos[i].setPeriodHertz(200);
    servos[i].attach(ServoPin[i], minUs, maxUs);
    pinMode(Sensor[i], INPUT);
  }

  delay(10000);
  for (int i=0;i<Units;i++)  {
    int x = digitalRead(Sensor[i]);
    if (x) gamemode++;
  }
  Serial.println();
  Serial.println("----------------------------------------------------------");
  Serial.printf("Auto Target GameMode=%d\n", gamemode);

  delay(5000);

  int all = 0;
  for (int i=0; i<Units; i++) all |= 1<<i;
  targetDownMulti(all);
  
  if (gamemode == 1) {
    unit = random(Units);
    targetUp(unit);
  } else {
    for (int i=0; i<Units; i++) 
      targetUp(i);
  }

}

int safepick(int exc) {
  int i;

  do {
    i = random(Units);
  } while(i == exc);
  return i;
}


void loop() {
  // put your main code here, to run repeatedly
  int in[Units];
  for (int i=0;i<Units;i++)
    in[i] = digitalRead(Sensor[i]);

  if (gamemode == 0)
  for (int i=0;i<Units;i++) {
    if (in[i]) {
      score++;
      Serial.printf("-- HIT   Score: %d\n", score);
      targetUp(i);
    }
  }

  if (gamemode == 1) {
    if (in[unit]) {
      score++;
      Serial.printf("-- HIT   Score: %d\n", score);
      unit = safepick(unit);
      targetUp(unit);
    }
  }

  while (Serial.available()) {
    Serial.print("Servo[");
    Serial.print(unit);
    Serial.print("] > ");
    Serial.flush();

    int angle = Serial.parseInt();
    if (Serial.read() == '\n') {
      if (angle >= 1 && angle <= 5) {
        unit = angle - 1;
        Serial.printf("Selecting Servo %d\n", unit);
      } else
      if (angle == 7) {
        targetUp(unit);
      } else
      if (angle == 8) {
        targetDown(unit);
      } else 
      if (angle == 9) {
        Serial.print("-- Sensor[");
        Serial.print(unit);
        Serial.print("]: ");
        Serial.print(in[unit]);
        Serial.println();
      } else {
        Serial.print("--- MOVING ");
        Serial.print(unit);
        Serial.print(" to: "); 
        Serial.println(angle);
        servo_move(unit, angle);
      }
    }
  }
  delay(200);

}
