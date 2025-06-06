PVector modelToScreen(PVector model) {
  PMatrix3D currMatrix = getMatrix(new PMatrix3D());
  float[] mv = new float[16];
  currMatrix.get(mv);
  float[] v = new float[4];
  v[0] = model.x;
  v[1] = model.y;
  v[2] = model.z;
  v[3] = 1;

  float x = mv[0]*v[0] + mv[1]*v[1] + mv[2]*v[2] + mv[3];
  float y = mv[4]*v[0] + mv[5]*v[1] + mv[6]*v[2] + mv[7];
  float z = mv[8]*v[0] + mv[9]*v[1] + mv[10]*v[2] + mv[11];
  float w = mv[12]*v[0] + mv[13]*v[1] + mv[14]*v[2] + mv[15];

  if (w != 0.0) {
    x /= w;
    y /= w;
    z /= w;
  }

  return new PVector(screenX(x, y, z), screenY(x, y, z));
}
