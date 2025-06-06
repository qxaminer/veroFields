PVector lightPos;
PVector viewPos;
PShape sphere;
float rotationAngle = 0;
boolean freezeRotation = false;

void setup() {
  size(1920, 1080, P3D);
  lightPos = new PVector(200, 200, 200);
  viewPos = new PVector(width / 2, height / 2, 500);
  sphere = createShape(SPHERE, 100);
  sphere.setStroke(false);
}

void draw() {
  background(0);
  lights();
  translate(width / 2, height / 2, 0);
  if (!freezeRotation) {
    rotationAngle += 0.2;
  }
  rotateY(radians(rotationAngle));
  rotateX(radians(rotationAngle));
  // Draw custom Phong-lit sphere and reverse cone at specular highlight
  shapeWithPhongLighting(sphere);
}

void shapeWithPhongLighting(PShape shape) {
  int detail = 100;
  float r = 275;
  float shininess = 3;
  float maxSpecular = 0;
  PVector maxSpecularPos = null;
  PVector maxNormal = null;
  
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
        float intensity = ambient + 0.6 * diffuse + 0.8 * specular;
        intensity = constrain(intensity, 0, 1);
        fill(255 * intensity);
        
        if (specular > maxSpecular) {
          maxSpecular = specular;
          maxSpecularPos = pos.copy();
          maxNormal = normal.copy();
        }
        vertex(x, y, z);
      }
    }
    endShape();
  }
  
  // Check if highlight is centered and freeze
  if (maxSpecularPos != null) {
    PVector screenPos = modelToScreen(maxSpecularPos);
    float dx = abs(screenPos.x - width / 2);
    float dy = abs(screenPos.y - height / 2);
    if (dx < 10 && dy < 10 && maxSpecular > 0.5) {
      freezeRotation = true;
    }
    // Draw reversed cone at highlight
    drawHighlightCone(maxSpecularPos, maxNormal);
  }
}

void drawHighlightCone(PVector position, PVector normal) {
  pushMatrix();
  translate(position.x, position.y, position.z);
  
  // Align cone with normal using quaternion-style rotation
  PVector up = new PVector(0, -1, 0); // cone default points down
  PVector axis = up.cross(normal, null);
  
  if (axis.mag() > 0.001) { // Check if vectors aren't parallel
    axis.normalize();
    float angle = acos(constrain(up.dot(normal), -1, 1));
    
    // Convert axis-angle to rotation matrix approach
    rotateX(axis.x * angle);
    rotateY(axis.y * angle);  
    rotateZ(axis.z * angle);
  }
  
  fill(255, 255, 100);
  noStroke();
  
  // Create custom cone since Processing doesn't have cone()
  drawCone(0, -20, 10, 20);  // reversed cone (tip at surface)
  
  popMatrix();
}

void drawCone(float x, float y, float baseRadius, float height) {
  int sides = 16;
  
  // Draw cone base
  beginShape(TRIANGLES);
  for (int i = 0; i < sides; i++) {
    float angle1 = TWO_PI * i / sides;
    float angle2 = TWO_PI * (i + 1) / sides;
    
    // Base triangle
    vertex(x, y + height, 0); // center of base
    vertex(x + cos(angle1) * baseRadius, y + height, sin(angle1) * baseRadius);
    vertex(x + cos(angle2) * baseRadius, y + height, sin(angle2) * baseRadius);
    
    // Side triangle
    vertex(x, y, 0); // tip
    vertex(x + cos(angle2) * baseRadius, y + height, sin(angle2) * baseRadius);
    vertex(x + cos(angle1) * baseRadius, y + height, sin(angle1) * baseRadius);
  }
  endShape();
}

PVector reflect(PVector I, PVector N) {
  return PVector.sub(I, PVector.mult(N, 2 * I.dot(N)));
}

PVector modelToScreen(PVector model) {
  PMatrix3D currMatrix = getMatrix(new PMatrix3D());
  float[] mv = new float[16];
  currMatrix.get(mv);
  float[] v = new float[4];
  v[0] = model.x;
  v[1] = model.y;
  v[2] = model.z;
  v[3] = 1;
  
  float x = mv[0] * v[0] + mv[1] * v[1] + mv[2] * v[2] + mv[3];
  float y = mv[4] * v[0] + mv[5] * v[1] + mv[6] * v[2] + mv[7];
  float z = mv[8] * v[0] + mv[9] * v[1] + mv[10] * v[2] + mv[11];
  float w = mv[12] * v[0] + mv[13] * v[1] + mv[14] * v[2] + mv[15];
  
  if (w != 0.0) {
    x /= w;
    y /= w;
    z /= w;
  }
  
  return new PVector(screenX(x, y, z), screenY(x, y, z));
}
