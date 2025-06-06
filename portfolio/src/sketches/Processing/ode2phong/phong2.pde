PVector lightPos;
PVector viewPos;
PShape sphere;
boolean freeze = false;
int freezeFrameCount = 0;
int freezeDuration = 120;  // Number of frames to pause (2 seconds at 60 fps)

float lastMaxSpecular = 0;

void setup() {
  size(1920, 1080, P3D);
  lightPos = new PVector(200, 200, 200);
  viewPos = new PVector(width / 2, height / 2, 500);

  sphere = createShape(SPHERE, 100);
  sphere.setStroke(false);
}

void draw() {
  if (freeze) {
    freezeFrameCount++;
    if (freezeFrameCount > freezeDuration) {
      freeze = false;
      freezeFrameCount = 0;
    } else {
      return;  // Skip drawing to freeze frame
    }
  }

  background(0);
  lights();
  translate(width / 2, height / 2, 0);

  rotateY(radians(frameCount * 0.2));
  rotateX(radians(frameCount * 0.2));

  lastMaxSpecular = 0;
  shapeWithPhongLighting(sphere);

  // If highlight intensity is above a threshold, freeze the frame
  if (lastMaxSpecular > 0.95) {  // Adjust threshold as needed
    freeze = true;
    println("Freezing frame at max specular: " + lastMaxSpecular);
  }
}

void shapeWithPhongLighting(PShape shape) {
  int detail = 200;
  float r = 275;
  float shininess = 3;

  for (int i = 0; i < detail; i++) {
    float theta1 = PI * i / detail;
    float theta2 = PI * (i + 1) / detail;

    beginShape(TRIANGLE_STRIP);
    for (int j = 0; j <= detail; j++) {
      float phi = TWO_PI * j / detail;

      for (int k = 0; k <
