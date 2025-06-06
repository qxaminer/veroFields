PVector lightPos;
PVector viewPos;

float rotationAngle = 0;
boolean freezeRotation = false;

void setup() {
  size(800, 800, P3D);
  lightPos = new PVector(200, 200, 200);
  viewPos = new PVector(0, 0, 500); // from camera, relative to center
}

void draw() {
  background(0);
  lights();
  translate(width/2, height/2, 0);

  if (!freezeRotation) {
    rotationAngle += 0.5;
  }

  rotateY(radians(rotationAngle));
  rotateX(radians(rotationAngle));

  // Render sphere + track specular highlight
  PVector[] highlight = drawPhongSphere(100, 250);
  if (highlight != null) {
    PVector highlightPos = highlight[0];
    PVector normalAtHighlight = highlight[1];

    // Check if specular point is centered on screen
    PVector screen = modelToScreen(highlightPos);
    float dx = abs(screen.x - width/2);
    float dy = abs(screen.y - height/2);
    if (dx < 10 && dy < 10) {
      freezeRotation = true;
    }

    drawHighlightCone(highlightPos, normalAtHighlight, 12, 30);
  }
}

PVector[] drawPhongSphere(int detail, float r) {
  float shininess = 5;
  float maxSpecular = 0;
  PVector maxPos = null;
  PVector maxNormal = null;

  for (int i = 0; i < detail; i++) {
    float theta1 = PI * i / detail;
    float theta2 = PI * (i+1) / detail;

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
    return new PVector[] { maxPos, maxNormal };
  } else {
    return null;
  }
}

void drawHighlightCone(PVector base, PVector normal, float radius, float height) {
  pushMatrix();
  translate(base.x, base.y, base.z);

  // Rotate to align cone with surface normal
  PVector axis = new PVector(0, -1, 0);
  PVector rotAxis = axis.cross(normal);
  float angle = acos(axis.dot(normal));
  if (rotAxis.mag() > 0.0001) {
    rotate(angle, rotAxis.x, rotAxis.y, rotAxis.z);
  }

  fill(255, 255, 0);
  noStroke();

  beginShape(TRIANGLE_FAN);
  vertex(0, 0, 0); // tip of cone (surface point)
  int sides = 20;
  for (int i = 0; i <= sides; i++) {
    float a = TWO_PI * i / sides;
    float x = cos(a) * radius;
    float z = sin(a) * radius;
    vertex(x, height, z);
  }
  endShape();

  popMatrix();
}

PVector reflect(PVector I, PVector N) {
  return PVector.sub(I, PVector.mult(N, 2 * I.dot(N)));
}

PVector modelToScreen(PVector model) {
  PVector p = model(model.x, model.y, model.z);
  return new PVector(screenX(p.x, p.y, p.z), screenY(p.x, p.y, p.z));
}
