# Ultrasonic-radar-using-arduino
# Arduino-Based Ultrasonic Radar System

## Project Overview
An Arduino-based ultrasonic radar system that uses an HC-SR04 sensor mounted on a servo motor to scan the surroundings and detect nearby objects. Distance and angle readings are visualized through a radar interface.

## Components Used
- Arduino Uno
- HC-SR04 Ultrasonic Sensor
- Servo Motor
- Breadboard
- Jumper Wires

## Pin Connections

| Component | Arduino Pin |
|---|---|
| HC-SR04 Trig | Digital Pin 10 |
| HC-SR04 Echo | Digital Pin 11 |
| Servo Signal | Digital Pin 9 |
| Servo VCC | 5V |
| Servo GND | GND |
| HC-SR04 VCC | 5V |
| HC-SR04 GND | GND |

## Software Used
- Arduino IDE
- Tinkercad
- Processing

## Working Principle
1. The servo rotates the ultrasonic sensor across a specified angle.
2. The HC-SR04 measures the distance to nearby objects using ultrasonic pulses.
3. Arduino processes the distance and angle readings.
4. Data is transmitted through serial communication.
5. Processing displays the readings as a radar visualization.


## Author
**M. Jahnavi**  
Electronics and Communication Engineering Student
3rd year
