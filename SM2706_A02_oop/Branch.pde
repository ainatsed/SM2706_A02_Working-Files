// Modified from Fractal Trees - Object Oriented by Daniel Shiffman
// https://thecodingtrain.com/challenges/15-object-oriented-fractal-trees

class Branch {
  PVector begin;
  PVector end;
  boolean finished = false;
  
  Branch(PVector x0, PVector y0){
    begin = x0;
    end = y0; 
  }

  Branch branchR() {
    PVector dir =  PVector.sub(end, begin);
    dir.rotate(PI / 6);
    dir.mult(0.67);
    PVector newEnd = PVector.add(end, dir);
    Branch b = new Branch(end, newEnd);
    return b;
  }

  Branch branchL() {
    PVector dir = PVector.sub(end, begin);
    dir.rotate(-PI / 3);
    dir.mult(0.67);
    PVector newEnd = PVector.add(end, dir);
    Branch b = new Branch(end, newEnd);
    return b;
  }
    
  void show() {
    float len = dist(begin.x, begin.y, end.x, end.y); // length of branch
    //print("\n", floor(len)); // check min, max length
    
    strokeWeight(map(len, 0, 100, 1, 35)); // thicken longer branches
    stroke(250);
    line(begin.x, begin.y, end.x, end.y);
  }
  
  void reflect() {
    float len = dist(begin.x, begin.y, end.x, end.y); // length of branch
    //print("\n", floor(len)); // check min, max length
    
    strokeWeight(map(len, 0, 100, 1, 30)); // thicken longer branches
    stroke(0);
    line(begin.x, height-begin.y + 480, end.x, height-end.y + 480);
  }
  
  void jitter() {
    end.x += random(-0.1, 0.1);
    end.y += random(-0.1, 0.1);
  }
}
