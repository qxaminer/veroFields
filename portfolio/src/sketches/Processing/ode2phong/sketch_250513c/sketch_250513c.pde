PVector lightPos;
PVector viewPos;

float rotationAngle = 0;
boolean freezeRotation = false;

void setup() {
  size(800, 800, P3D);
  lightPos = new PVector(200, 200, 200);
  viewPos = new PVector(0, 0, 500); // relative to sphere center
}

void draw() {
  background(0);
  lights();
  translate(width / 2, height / 2, 0);

  if (!freezeRotation) {
    rotationAngle += 0.5;
  }

  rotateY(radians(rotationAngle));
  rotateX(radians(rotationAngle));

  drawPhongSphere(100, 275);
}

void drawPhongSphere(int detail, float radius) {
  float shininess = 5;
  float maxSpecular = 0;
  PVector maxPos = null;
  PVector maxNormal = null;

  for (int i = 0; i < detail; i++) {
    float theta1 = PI * i / detail;
    float theta2 = PI * (i + 1) / detail;

    beginShape(TRIANGLE_STRIP);
    for (int j = 0; j <= detail; j++) {
      float phi = TWO_PI * j / detail;

      for (int k = 0; k < 2; k++) {
        float theta = (k == 0) ? theta1 : theta2;

        float x = radius * sin(theta) * cos(phi);
        float y = radius * cos(theta);
        float z = radius * sin(theta) * sin(phi);

        PVector pos = new PVector(x, y, z);
        PVector normal = pos.copy().normalize();

        PVector lightDir = PVector.sub(lightPos, pos).normalize();
        PVector viewDir = PVector.sub(viewPos, pos).normalize();
        PVector reflectDir = reflect(PVector.mult(lightDir, -1), normal);

        float ambient = 0.1;
        float diffuse = max(PVector.dot(normal, lightDir), 0);
        float specular = pow(max(PVector.dot(viewDir, reflectDir), 0), shininess);

        float intensity = ambient + 0.6 * diffuse + 0.8 * specular;
        intensity = constrain(intensity, 0, 1);
        fill(255 * intensity);

        if (specular > maxSpecular) {
          maxSpecular = specular;
          maxPos = pos.copy();
          maxNormal = normal.copy();
        }

        vertex(x, y, z);
      }
    }
    endShape();
  }

  if (maxPos != null) {
    PVector screenPos = modelToScreen(maxPos);
    float dx = abs(screenPos.x - width / 2);
    float dy = abs(screenPos.y - height / 2);
    if (dx < 10 && dy < 10 && maxSpecular > 0.5) {
      freezeRotation = true;
    }

    drawConeAt(maxPos, maxNormal, 10, 30);
  }
}

void drawConeAt(PVector base, PVector normal, float radius, float height) {
  pushMatrix();
  translate(base.x, base.y, base.z);

  // Rotate to align cone with normal
  PVector axis = new PVector(0, -1, 0); // cone points down
  PVector rotAxis = axis.cross(normal);
  float angle = acos(axis.dot(normal));
  if (rotAxis.mag() > 0.0001) {
    rotate(angle, rotAxis.x, rotAxis.y, rotAxis.z);
  }

  fill(255, 255, 0);
  noStroke();
  int sides = 24;
  beginShape(TRIANGLE_FAN);
  vertex(0, 0, 0); // tip at base point
  for (int i = 0; i <= sides; i++) {
    float angleStep = TWO_PI * i / sides;
    float x = cos(angleStep) * radius;
    float z = sin(angleStep) * radius;
    vertex(x, height, z); // base circle
  }
  endShape();
  popMatrix();
}

PVector reflect(PVector I, PVector N) {
  return PVector.sub(I, PVector.mult(N, 2 * I.dot(N)));
}

PVector modelToScreen(PVector model) {
  PVector projected = model.copy();
  projected = model(projected.x, projected.y, projected.z);
  return new PVector(screenX(projected.x, projected.y, projected.z),
                     screenY(projected.x, projected.y, projected.z));
}
