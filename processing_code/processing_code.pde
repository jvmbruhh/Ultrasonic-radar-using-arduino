
import processing.serial.*;

Serial myPort;

// Radar readings
int angle = 90;
int previousAngle = 90;
int direction = 1;

float distance = 0;

// Radar settings
int maxDistance = 10;
int radarRadius = 350;

// Detection storage
float[] detectedDistance = new float[181];
int[] detectedTime = new int[181];

void setup() {

  size(1000, 650);
  smooth();

  // Connect Arduino through COM3
  myPort = new Serial(this, "COM3", 9600);

  myPort.bufferUntil('\n');
}

void draw() {

  background(5, 12, 5);

  // Radar centre
  translate(width/2, height-65);

  // ==============================
  // GREEN RADAR CIRCLES
  // ==============================

  stroke(0, 200, 0);
  strokeWeight(2);
  noFill();

  for (int i = 1; i <= 5; i++) {

    float r = radarRadius * i / 5.0;

    arc(0, 0, r*2, r*2, PI, TWO_PI);
  }

  // ==============================
  // GREEN RADAR ANGLE LINES
  // ==============================

  for (int a = 0; a <= 180; a += 30) {

    float x = radarRadius * cos(radians(a));
    float y = -radarRadius * sin(radians(a));

    stroke(0, 180, 0);
    strokeWeight(2);

    line(0, 0, x, y);
  }

  // ==============================
  // DISTANCE LABELS
  // ==============================

  fill(0, 255, 0);
  textSize(15);
  textAlign(CENTER);

  for (int i = 1; i <= 5; i++) {

    float x = radarRadius * i / 5.0;

    text((i * 2) + "cm", x, -5);
  }

  // ==============================
  // ANGLE LABELS
  // ==============================

  textSize(16);

  for (int a = 0; a <= 180; a += 30) {

    float x = (radarRadius + 25) * cos(radians(a));
    float y = -(radarRadius + 25) * sin(radians(a));

    text(a, x, y);
  }

  // ==============================
  // GREEN SWEEP TRAIL
  // ==============================

  for (int i = 20; i >= 0; i--) {

    float trailAngle =
      angle - direction * i * 1.2;

    float alpha = map(i, 0, 20, 120, 2);

    float x = radarRadius * cos(radians(trailAngle));
    float y = -radarRadius * sin(radians(trailAngle));

    stroke(0, 255, 30, alpha);
    strokeWeight(3);

    line(0, 0, x, y);
  }

  // ==============================
  // MAIN GREEN RADAR BEAM
  // ==============================

  float beamX =
    radarRadius * cos(radians(angle));

  float beamY =
    -radarRadius * sin(radians(angle));

  stroke(0, 255, 50);
  strokeWeight(3);

  line(0, 0, beamX, beamY);

  // ==============================
  // RED RADIAL DETECTION SPOKES
  // ==============================

  for (int a = 0; a <= 180; a++) {

    if (detectedDistance[a] > 0 &&
        detectedDistance[a] <= maxDistance &&
        millis() - detectedTime[a] < 2000) {

      float r = map(
        detectedDistance[a],
        0,
        maxDistance,
        0,
        radarRadius
      );

      float x = r * cos(radians(a));
      float y = -r * sin(radians(a));

      // Red spoke from centre to object
      stroke(255, 0, 0);
      strokeWeight(3);

      line(0, 0, x, y);
    }
  }

  // ==============================
  // RADAR INFORMATION
  // ==============================

  resetMatrix();

  fill(0, 255, 0);
  textAlign(LEFT);

  textSize(20);

  text("ULTRASONIC RADAR", 20, 30);

  textSize(16);

  text("ANGLE: " + angle + " degrees", 20, 60);

  text("DISTANCE: " + distance + " cm", 20, 85);

  text("MAX RANGE: 10 cm", 20, 110);

  text("SWEEP: 30 - 150 degrees", 20, 135);
}

// ==============================
// RECEIVE ARDUINO SERIAL DATA
// ==============================

void serialEvent(Serial myPort) {

  String data = myPort.readStringUntil('\n');

  if (data != null) {

    data = trim(data);

    String[] values = split(data, ',');

    if (values.length == 2) {

      int newAngle = int(values[0]);

      float newDistance = float(values[1]);

      if (newAngle >= 30 && newAngle <= 150) {

        if (newAngle > previousAngle) {
          direction = 1;
        }

        else if (newAngle < previousAngle) {
          direction = -1;
        }

        angle = newAngle;
        previousAngle = newAngle;

        distance = newDistance;

        // Store detected objects
        if (newDistance > 0 &&
            newDistance <= maxDistance) {

          detectedDistance[angle] = newDistance;

          detectedTime[angle] = millis();
        }
      }
    }
  }
}
