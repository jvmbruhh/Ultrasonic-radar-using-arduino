
#include <Servo.h>

// Create servo object
Servo radarServo;

// Pin connections
const int trigPin = 10;
const int echoPin = 11;
const int servoPin = 9;

// Servo rotation settings
const int minAngle = 30;
const int maxAngle = 150;

int angle = 30;
int direction = 1;

long duration;
float distanceCm;

void setup() {

  Serial.begin(9600);

  // Attach servo
  radarServo.attach(servoPin);

  // Ultrasonic sensor pins
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);

  radarServo.write(angle);

  delay(500);
}

void loop() {

  // Rotate servo
  radarServo.write(angle);

  delay(30);

  // Send ultrasonic pulse
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);

  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);

  digitalWrite(trigPin, LOW);

  // Receive echo
  duration = pulseIn(echoPin, HIGH, 25000);

  // Calculate distance
  if (duration == 0) {
    distanceCm = 0;
  }
  else {
    distanceCm = duration * 0.0343 / 2;
  }

  // Send angle and distance to Processing
  Serial.print(angle);
  Serial.print(",");
  Serial.println(distanceCm, 1);

  // Move servo forward and backward
  angle += direction;

  if (angle >= maxAngle) {
    angle = maxAngle;
    direction = -1;
  }

  if (angle <= minAngle) {
    angle = minAngle;
    direction = 1;
  }
}
