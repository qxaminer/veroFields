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

      for (int k = 0; k < 2; k++) {
        float theta = (k == 0) ? theta1 : theta2;

        float x = r * sin(theta) * cos(phi);
        float y = r * cos(theta);
        float z = r * sin(theta) * sin(phi);

        PVector pos = new PVector(x, y, z);
        PVector normal = pos.copy().normalize();

        PVector lightDir = PVector.sub(lightPos, pos).normalize();
        PVector viewDir = PVector.sub(viewPos, pos).normalize();
        PVector reflectDir = reflect(PVector.mult(lightDir, -1), normal);

        float ambient = 0.1;
        float diffuse = max(PVector.dot(normal, lightDir), 0);
        float specular = pow(max(PVector.dot(viewDir, reflectDir), 0), shininess);

        if (specular > lastMaxSpecular) {
          lastMaxSpecular = specular;
        }

        float intensity = ambient + 0.6 * diffuse + 0.8 * specular;
        intensity = constrain(intensity, 0, 1);
        fill(255 * intensity);

        vertex(x, y, z);
      }
    }
    endShape();
  }
}

PVector reflect(PVector I, PVector N) {
  return PVector.sub(I, PVector.mult(N, 2 * I.dot(N)));
}
