void tree(float x0, float y0){
  push();
  translate(x0, y0);
  // add branches to tree
  for (int i = 0; i < count; i++) {
    if (!tree[i].finished) {
      tree = (Branch[]) append(tree, tree[i].branchR());
      tree = (Branch[]) append(tree, tree[i].branchL());
    }
    tree[i].finished = true;
  }
  
  for (int i = 0; i < tree.length; i++) {
    if (!tree[i].finished) {
      PVector leaf = tree[i].end;
      leaves = (PVector[]) append(leaves, leaf);
    }
  }
  
  for (int i = 0; i < tree.length; i++) {
    tree[i].show();
    //tree[i].reflect();
    //tree[i].jitter();
  }
  
  for (int i = 0; i < 300; i++) {
    float sz = 6;
    float d = dist(moonX - x0, moonY - y0, leaves[i].x, leaves[i].y);
    //print("\n", floor(d)); // check min, max dist
    
    float c = col[i] + map(d, 300, 700, 150, 0); // brighten closer leaves
    fill(c);  
    noStroke();
    circle(leaves[i].x, leaves[i].y, sz);
    //circle(leaves[i].x, height-leaves[i].y + 480, sz); // reflect
  }
  pop();
}
