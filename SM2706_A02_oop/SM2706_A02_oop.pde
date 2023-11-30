import processing.sound.*;
SoundFile song;
Amplitude amp;

float[] history; // store amplitude values

PGraphics skyGraphics;
PGraphics seaGraphics;
float moonX, moonY;
float amt = random(0.05, 0.1); // smoothing

float pTime = 0, cTime; // previous, current timestamp
float time = int(random(8)); // time until first root generation

Branch[] tree = new Branch[0];
PVector[] leaves = new PVector[0];
Root[] roots = new Root[0];
float[] col = new float[0]; // store colors of unlit leaves
int count = 300; // no. of branches
float offx = -180, offy = -130; // offset tree xpos, ypos

void setup() {
  size(960, 540);
  skyGraphics = createGraphics(width, height/2);
  seaGraphics = createGraphics(width, height/2);
  ellipseMode(CENTER);
  
  song = new SoundFile(this, "Audio/1119_Audio.wav");
  song.loop();
  amp = new Amplitude(this);
  amp.input(song);
  // create an empty array of size equals width
  history = new float[width]; 
  
  // create tree root as first point
  PVector x0 = new PVector(width / 2, height);
  PVector y0 = new PVector(width / 2, height - 80);
  Branch root = new Branch(x0, y0); 
  tree = (Branch[]) append(tree, root);
  
  for (int i = 0; i < count; i++) {
    col = (float[]) append(col, random(5, 50));
  }
}

void draw() {
  background(0);
  
  float analyzer = amp.analyze();
  float b = map(analyzer, 0, 1, 5, 10); // blur factor
  
  skyGraphics.beginDraw();
  skyGraphics.colorMode(HSB);
  skyGraphics.background(0);
  
  // draw moon
  moonX = lerp(moonX, mouseX, amt);
  //moonX = width/3*2; // demo recording
  float a = map(moonX, -80, width+80, PI, TWO_PI);
  moonY = (sin(a)*height/2) + height*0.7;
  float d = dist(moonX, moonY, width/2, height/2);
  //print("\n", floor(d)); // check min, max dist
  float dim = map(d, 250, 480, 130, 60); 
  
  // draw moon
  skyGraphics.push();
  skyGraphics.fill(255);
  skyGraphics.circle(moonX, moonY, dim);
  skyGraphics.filter(BLUR, b); // blur driven by amplitude
  skyGraphics.pop();
  
  // draw mountains
  skyGraphics.noStroke();
  skyGraphics.fill(20);
  skyGraphics.beginShape();
  skyGraphics.vertex(0, height/2);
  for (int x = 0; x < width - 1; x++) {
    float xoff = 70;
    float y = 100 + noise(x * 0.01 + xoff) * 60;
    skyGraphics.vertex(x, y);
  }
  skyGraphics.vertex(width, height/2);
  skyGraphics.endShape();
  
  skyGraphics.fill(15);
  skyGraphics.beginShape();
  skyGraphics.vertex(0, height/2);
  for (int x = 0; x < width - 1; x++) {
    float xoff = 50;
    float y = 150 + noise(x * 0.01 + xoff) * 60;
    skyGraphics.vertex(x, y);
  }
  skyGraphics.vertex(width, height/2);
  skyGraphics.endShape();
  
  skyGraphics.fill(0);
  skyGraphics.beginShape();
  skyGraphics.vertex(0, height/2);
  for (int x = 0; x < width - 1; x++) {
    float y = 200 + noise(x * 0.01) * 60;
    skyGraphics.vertex(x, y);
  }
  skyGraphics.vertex(width, height/2);
  skyGraphics.endShape();
  
  skyGraphics.endDraw(); 
  image(skyGraphics, 0, 0);
  
  seaGraphics.beginDraw();
  seaGraphics.colorMode(HSB);
  seaGraphics.background(0);
  
  seaGraphics.push();
  // draw moon reflection
  seaGraphics.fill(255);
  seaGraphics.noStroke();
  seaGraphics.circle(moonX, height/2 - moonY, dim); // flip
  
  // draw mountains reflection
  seaGraphics.fill(20);
  seaGraphics.beginShape();
  seaGraphics.vertex(0, 0);
  for (int x = 0; x < width - 1; x++) {
    float y = 150 + noise(x * 0.01, frameCount * 0.008) * 60;
    seaGraphics.vertex(x, height/2 - y);
  }
  seaGraphics.vertex(width, 0);
  seaGraphics.endShape();
  
  seaGraphics.fill(10);
  seaGraphics.beginShape();
  seaGraphics.vertex(0, 0);
  for (int x = 0; x < width - 1; x++) {
    float xoff = 50;
    float y = 200 + noise(x * 0.01 + xoff, frameCount * 0.008) * 60;
    seaGraphics.vertex(x, height/2 - y);
  }
  seaGraphics.vertex(width, 0);
  seaGraphics.endShape();
  
  seaGraphics.fill(5);
  seaGraphics.beginShape();
  seaGraphics.vertex(0, 0);
  for (int x = 0; x < width - 1; x++) {
    float xoff = 50;
    float y = 250 + noise(x * 0.01 + xoff, frameCount * 0.008) * 60;
    seaGraphics.vertex(x, height/2 - y);
  }
  seaGraphics.vertex(width, 0);
  seaGraphics.endShape();
  seaGraphics.filter(BLUR, b); // blur driven by amplitude
  seaGraphics.pop();
  
  // draw ripples
  for (int i = width-1; i > 0; i--) {
    history[i] = history[i-1];
  }
  // save current amplitude at the last position
  history[0] = analyzer; 
 
  seaGraphics.stroke(255);
  seaGraphics.noFill();

  float ay = 0; // ypos of line being drawn

  for (int i = 0; i < height; i++) {
    if (ay <= height) { 
      ay++;
    } else { // if line reaches bottom of canvas
      ay = 0; // reset
    }
    ay++;
    // growing ripples towards bottom of canvas
    float scale = map(ay, 0, height, 2, 14);
    float x0 = width/3*2;
    if (history[i] != 0) { // draw only where there is audio
      seaGraphics.line(x0 - history[i]*height*scale, i, 
      x0 + history[i]*height*scale, i);  
    }
  }
 
  seaGraphics.filter(BLUR, 1);
  seaGraphics.endDraw();
  image(seaGraphics, 0, height/2);
  
  cTime = millis();
  
  if (cTime - pTime > time*1000) {
    // generate new root
    Root root = new Root(); 
    roots = (Root[]) append(roots, root);
    print("\ntime:", time, ", roots[]:", roots.length); // check
    
    pTime = cTime;
    time = int(random(8)); // new time until next generation
  }
  
  // draw roots
  for (int i = 0; i < roots.length; i++) {
    roots[i].show();
    roots[i].grow();
  }
 
  // draw tree
  tree(offx, offy);
}
