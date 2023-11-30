class Root {
  float beginx, beginy, endx, endy;
  int min_l, max_l, curr, len;
  
  Root() {
    beginx = random(width);
    beginy = random(height/2, height);
    endx = beginx;
    endy = beginy;
    min_l = 20;
    max_l = 40;
    
    curr = 0; // current length
    len = int(random(min_l, max_l)); // assign random length
    
  }
  
  void show() {
    stroke(255);
    line(beginx, beginy, endx, endy);
  }
  
  void grow() {
    int choice = int(random(2));
   
    if (curr < len) {
      endy--;
      if (choice == 0) {
      endx++;
    } else if (choice == 1) {
      endx--;
    } 
      curr++;
    }
 
    endy = constrain(endy, height/2 - max_l, height);
    endx = constrain(endx, 0, width);
  }
}
