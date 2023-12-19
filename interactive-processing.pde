float rad = 0;
float time = -600;
PImage textureImage;
PImage textureA;
PImage blackTex;
PImage textureLeaf;
PImage brick;
float carRotation = 0;

int rows = 0; // rows of trees
int cols =0; // columns of trees
float spacing = 70; // space between trees

int speed = 3;

void setup() {
  textureImage = loadImage("texture.jpg");
  textureA = loadImage("ground.jpg");
  textureLeaf = loadImage("leaf.jpg");
  blackTex = loadImage("blackTex.jpg");
  brick = loadImage("brick.jpg");
  size(400, 400, P3D);
  noStroke();
}

void draw() {
  
  time = time + speed;
  speed= speed%10;
  if (time >= 600) time = -600;
  camera(100, 100, 80, 0, 0, 0, 0, 0, -1);
  
  // rotate camera if the mouse is pressed.
  if (mousePressed && mouseButton == RIGHT) {
    rad = rad + 2;
    camera(sin(rad * PI / 180) * 100, cos(rad * PI / 180) * 100, 80, 0, 0, 0, 0, 0, -1);
  }

  lights();
  directionalLight(255, 255, 255, 1, 0.6, -1); //lightning
  background(135, 206, 235);   // sky blue
  
  if (keyPressed && key == ' ') {
    speed++;
  }
  
  car();
  translate(0, time <= 600 ? time * 2 : (time - 600) * 2, 0); // moving forward
  
  //road
  pushMatrix();
  translate(0, 0, 0.1); // move above the ground
  fill(128, 128, 128);
  beginShape(QUADS);
  vertex(-40, -4000, 0, 0, 0);
  vertex(40, -4000, 0, 1, 0);
  vertex(40, 4000, 0, 1, 1);
  vertex(-40, 4000, 0, 0, 1);
  endShape();
  popMatrix();
  
  // trees 
  
  for (int i = -25; i < rows; i++) {
    for (int j = -25; j < cols; j++) {
      pushMatrix();
      translate(j * spacing, i * spacing, 0);
      forest();
      popMatrix();
    }
  }
  for (int i = 10; i > rows; i--) {
    for (int j = 10; j > cols; j--) {
      pushMatrix();
      translate(j * spacing, i * spacing, 0);
      forest();
      popMatrix();
    }
  }
  
  //2 houses
  pushMatrix();
  translate(70, 0, 0);
  house();
  popMatrix();
  pushMatrix();
  translate(-70, 70, 0);
  house();
  popMatrix();

  // ground
  beginShape(QUADS);
  texture(textureA); 
  vertex(-3000, -3000, 0);
  vertex(-3000, 3000, 0);
  vertex(3000, 3000, 0);
  vertex(3000, -3000, 0);
  endShape();
}

void forest() {
  pushMatrix();
  translate(0, 0, 40);
  
  // apply texture on pyramid
  pyramid(10, textureLeaf);
  translate(0, 0, -10);
  pyramid(15, textureLeaf);
  translate(0, 0, -10);
  pyramid(20, textureLeaf);
  translate(0, 0, -10);
  rotateX(PI / 2);
  fill(164,116,73);
  drawCylinder(5, 15);
  popMatrix();
}

void car() {
  
  pushMatrix();
  translate(0, 0, 20);
  drawBox(15, 30, 10, textureImage);
  pushMatrix();
  translate(0, 20, -7);
  rotateZ(PI / 2);
  fill(0);
  drawCylinder(5, 35);
  popMatrix();
  pushMatrix();
  translate(0, -20, -7);
  rotateZ(PI / 2);
  drawCylinder(5, 35);
  popMatrix();
  popMatrix();
}



void house() {
  pushMatrix();
  translate(0, 0, 10);
  texture(brick);
  drawBox(20, 30, 10, brick);
  translate(0, 0, 10);
  
  pyramid(30, blackTex);
  popMatrix();
}

void pyramid(float size, PImage textureImage) {
  pushMatrix();
  scale(size);
  beginShape(TRIANGLES);
  
  texture(textureImage);
  vertex(0, 0, 1, 0, 0);
  vertex(-1, -1, 0, 0, textureImage.height);
  vertex(1, -1, 0, textureImage.width, textureImage.height);

  texture(textureImage);
  vertex(0, 0, 1, textureImage.width / 2, 0);
  vertex(1, -1, 0, textureImage.width, textureImage.height);
  vertex(1, 1, 0, textureImage.width, 0);

  texture(textureImage);
  vertex(0, 0, 1, textureImage.width / 2, 0);
  vertex(1, 1, 0, textureImage.width, 0);
  vertex(-1, 1, 0, 0, 0);

  texture(textureImage);
  vertex(0, 0, 1, textureImage.width / 2, textureImage.height);
  vertex(-1, 1, 0, 0, 0);
  vertex(-1, -1, 0, 0, textureImage.height);
  endShape();
  beginShape(QUADS);
  texture(textureImage);
  vertex(-1, -1, 0, 0, textureImage.height);
  vertex(1, -1, 0, textureImage.width, textureImage.height);
  vertex(1, 1, 0, textureImage.width, 0);
  vertex(-1, 1, 0, 0, 0);
  endShape();
  popMatrix();
}

void drawCylinder(float radius, float height) {
  int detail = 36;
  float angleIncrement = TWO_PI / detail;

  // top 
  beginShape();
  for (int i = 0; i < detail; i++) {
    float angle = i * angleIncrement;
    float x = cos(angle) * radius;
    float z = sin(angle) * radius;
    vertex(x, -height/2, z);
  }
  endShape(CLOSE);

  // bottom
  beginShape();
  for (int i = 0; i < detail; i++) {
    float angle = i * angleIncrement;
    float x = cos(angle) * radius;
    float z = sin(angle) * radius;
    vertex(x, height/2, z);
  }
  endShape(CLOSE);

  // side
  beginShape(TRIANGLE_STRIP);
  for (int i = 0; i <= detail; i++) {
    float angle = i * angleIncrement;
    float x = cos(angle) * radius;
    float z = sin(angle) * radius;
    vertex(x, -height/2, z);
    vertex(x, height/2, z);
  }
  endShape(CLOSE);
}





void drawBox(float w, float h, float d, PImage textureImage) {
  // front
  beginShape(QUADS);

  texture(textureImage);
  vertex(-w, -h, d, 0, 0);
  vertex(w, -h, d, 256, 0);
  vertex(w, h, d, 256, 256);
  vertex(-w, h, d, 0, 256);

  // back
  vertex(w, -h, -d, 0, 0);
  vertex(-w, -h, -d, 256, 0);
  vertex(-w, h, -d, 256, 256);
  vertex(w, h, -d, 0, 256);

  vertex(-w, -h, -d, 0, 0);
  vertex(-w, -h, d, 256, 0);
  vertex(-w, h, d, 256, 256);
  vertex(-w, h, -d, 0, 256);

  vertex(w, -h, d, 0, 0);
  vertex(w, -h, -d, 256, 0);
  vertex(w, h, -d, 256, 256);
  vertex(w, h, d, 0, 256);

  // top
  vertex(-w, -h, -d, 0, 0);
  vertex(w, -h, -d, 256, 0);
  vertex(w, -h, d, 256, 256);
  vertex(-w, -h, d, 0, 256);

  // bottom
  vertex(-w, h, d, 0, 0);
  vertex(w, h, d, 256, 0);
  vertex(w, h, -d, 256, 256);
  vertex(-w, h, -d, 0, 256);
  endShape();
}
