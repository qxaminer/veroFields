void drawRect(color _fillCol) {
  //use stuff
  fill(_fillCol);
  stroke(strokeCol);
  strokeWeight(5);
  rect(x, y, w, h);
  x = x + spdX;
  x += spdX;
  y += spdY;
}

//don't hide local so tracking values gets easier.  Prog world is split
