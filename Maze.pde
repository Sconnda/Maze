int size = 25;
int blocks = 0;
float thickness = 2;
int total = 0;
int runs = 1;
ArrayList<PVector> draw = new ArrayList<PVector>();
PVector initial = new PVector(0, 0);
boolean mainGen = false;
boolean mazeGen = false;
ArrayList<ArrayList> paths = new ArrayList<ArrayList>();
ArrayList<PVector> mainPath = new ArrayList<PVector>();
boolean [][] maze = new boolean[size][];
boolean [][] progress = new boolean[size][];

void setup() {
  size(700, 700);
  rectMode(CENTER);
  mainPath.add(new PVector(0, 0));
  for (int i = 0; i < size; i++) {
    maze[i] = new boolean[size];
    for (int j = 0; j < size; j++) {
      maze[i][j] = false;
    }
  }
  for (int i = 0; i < size; i++) {
    progress[i] = new boolean[size];
    for (int j = 0; j < size; j++) {
      progress[i][j] = false;
    }
  }
  paths.add(new ArrayList<PVector>());
  draw.add(new PVector(0.5*width/size, 0.5*height/size));
  maze[0][0] = true;
  frameRate(100);
}

void draw() {
  background(0);
  while (!mazeGen) {
    mazeGen();
  }
  //else {
  //reset();
  //}
  for (int i = 0; i < mainPath.size(); i++) {
    PVector loc = mainPath.get(i);
    noStroke();
    fill(255);
    rect((loc.x+0.5)*width/size, (loc.y+0.5)*height/size, width/size-thickness, height/size-thickness);
  }
  for (int j = 0; j < paths.size(); j++) {
    ArrayList<PVector> path = paths.get(j);
    for (int i = 0; i < path.size(); i++) {
      PVector loc = path.get(i);
      noStroke();
      fill(255);
      rect((loc.x+0.5)*width/size, (loc.y+0.5)*height/size, width/size-thickness, width/size-thickness);
    }
  }
  for (int j = 0; j < paths.size(); j++) {
    ArrayList<PVector> path = paths.get(j);
    for (int i = 0; i < path.size()-1; i++) {
      PVector loc = path.get(i);
      stroke(255);
      strokeWeight(width/size-thickness);
      line((loc.x+0.5)*width/size, (loc.y+0.5)*height/size, (path.get(i+1).x+0.5)*width/size, (path.get(i+1).y+0.5)*height/size);
    }
  }
  for (int i = 0; i < mainPath.size()-1; i++) {
    PVector loc = mainPath.get(i);
    stroke(255);
    strokeWeight(width/size-thickness);
    line((loc.x+0.5)*width/size, (loc.y+0.5)*height/size, (mainPath.get(i+1).x+0.5)*width/size, (mainPath.get(i+1).y+0.5)*height/size);
  }
  if (draw.size() == 0) {
    noStroke();
    fill(255, 200);
    rect(width/2, 50, width, 50);
    fill(0, 128, 0);
    textAlign(CENTER);
    textSize(25);
    text("Draw a line from the top left to bottom right", width/2, 50);
  }
  stroke(0);
  strokeWeight(2*thickness);
  noFill();
  rect(width/2,height/2,width,height);
  if (mazeGen) {
    if (mousePressed) {
      if (draw.size() == 0) {
        if (floor(mouseX*size/width)%size == 0 && floor(mouseY*size/height)%size == 0) {
          draw.add(new PVector(mouseX, mouseY));
        }
      } else {
        boolean clear = true;
        if (mouseX >= draw.get(draw.size()-1).x) {
          for (float i = draw.get(draw.size()-1).x; i <= mouseX; i++) {
            if (mouseY >= draw.get(draw.size()-1).y) {
              for (float j = draw.get(draw.size()-1).y; j <= mouseY; j++) {
                if (get(round(i), round(j)) != color(255)) {
                  clear = false;
                }
              }
            } else {
              for (float j = draw.get(draw.size()-1).y; j >= mouseY; j--) {
                if (get(round(i), round(j)) != color(255)) {
                  clear = false;
                }
              }
            }
          }
        } else {
          for (float i = draw.get(draw.size()-1).x; i >= mouseX; i--) {
            if (mouseY >= draw.get(draw.size()-1).y) {
              for (float j = draw.get(draw.size()-1).y; j <= mouseY; j++) {
                if (get(round(i), round(j)) != color(255)) {
                  clear = false;
                }
              }
            } else {
              for (float j = draw.get(draw.size()-1).y; j >= mouseY; j--) {
                if (get(round(i), round(j)) != color(255)) {
                  clear = false;
                }
              }
            }
          }
        }
        if (clear) {
          draw.add(new PVector(mouseX, mouseY));
        }
      }
    }
  }
  if (keyPressed) {
    if (keyCode == UP) {
      PVector loc = draw.get(draw.size()-1);
      PVector loc2 = new PVector(width*(floor(loc.x*size/width)+0.5)/size, height*(floor(loc.y*size/height)-0.5)/size);
      boolean clear = true;

      for (float i = loc.x; i <= loc2.x; i++) {
        if (loc2.y >= loc.y) {
          for (float j = loc.y; j <= loc2.y; j++) {
            if (get(round(i), round(j)) == color(0)) {
              clear = false;
            }
          }
        } else {
          for (float j = loc.y; j >= loc2.y; j--) {
            if (get(round(i), round(j)) == color(0)) {
              clear = false;
            }
          }
        }
      }

      if (!clear) {
        loc2.x = width*(floor(loc.x*size/width)+0.5)/size;
        loc2.y = height*(floor(loc.y*size/height)+0.5)/size;
      }
      draw.add(loc2);
    } else if (keyCode == DOWN) {
      PVector loc = draw.get(draw.size()-1);
      PVector loc2 = new PVector(width*(floor(loc.x*size/width)+0.5)/size, height*(floor(loc.y*size/height)+1.5)/size);
      boolean clear = true;

      for (float i = loc.x; i <= loc2.x; i++) {
        if (loc2.y >= loc.y) {
          for (float j = loc.y; j <= loc2.y; j++) {
            if (get(round(i), round(j)) == color(0)) {
              clear = false;
            }
          }
        } else {
          for (float j = loc.y; j >= loc2.y; j--) {
            if (get(round(i), round(j)) == color(0)) {
              clear = false;
            }
          }
        }
      }

      if (!clear) {
        loc2.x = width*(floor(loc.x*size/width)+0.5)/size;
        loc2.y = height*(floor(loc.y*size/height)+0.5)/size;
      }
      draw.add(loc2);
      if (loc.x*size/width >= size-1 && loc.y*size/height >= size-1) {
        reset();
        draw.add(new PVector(0.5*width/size, 0.5*height/size));
      }
    } else if (keyCode == RIGHT) {
      PVector loc = draw.get(draw.size()-1);
      PVector loc2 = new PVector(width*(floor(loc.x*size/width)+1.5)/size, height*(floor(loc.y*size/height)+0.5)/size);
      boolean clear = true;

      for (float i = loc.x; i <= loc2.x; i++) {
        if (loc2.y >= loc.y) {
          for (float j = loc.y; j <= loc2.y; j++) {
            if (get(round(i), round(j)) == color(0)) {
              clear = false;
            }
          }
        } else {
          for (float j = loc.y; j >= loc2.y; j--) {
            if (get(round(i), round(j)) == color(0)) {
              clear = false;
            }
          }
        }
      }

      if (!clear) {
        loc2.x = width*(floor(loc.x*size/width)+0.5)/size;
        loc2.y = height*(floor(loc.y*size/height)+0.5)/size;
      }
      draw.add(loc2);
      if (loc.x*size/width >= size-1 && loc.y*size/height >= size-1) {
        reset();
        draw.add(new PVector(0.5*size, 0.5*size));
      }
    } else if (keyCode == LEFT) {
      PVector loc = draw.get(draw.size()-1);
      PVector loc2 = new PVector(width*(floor(loc.x*size/width)-0.5)/size, height*(floor(loc.y*size/height)+0.5)/size);
      boolean clear = true;

      for (float i = loc.x; i >= loc2.x; i--) {
        if (loc2.y >= loc.y) {
          for (float j = loc.y; j <= loc2.y; j++) {
            if (get(round(i), round(j)) == color(0)) {
              clear = false;
            }
          }
        } else {
          for (float j = loc.y; j >= loc2.y; j--) {
            if (get(round(i), round(j)) == color(0)) {
              clear = false;
            }
          }
        }
      }

      if (!clear) {
        loc2.x = width*(floor(loc.x*size/width)+0.5)/size;
        loc2.y = height*(floor(loc.y*size/height)+0.5)/size;
      }
      draw.add(loc2);
    }
  }
  for (int i = 0; i < draw.size(); i++) {
    PVector loc = draw.get(i);
    float t = (width/size-thickness)/2;
    fill(255, 0, 0);
    if (i < draw.size()-1) {
      PVector loc2 = draw.get(i+1);
      stroke(255, 0, 0);
      strokeWeight(t);
      line(loc.x, loc.y, loc2.x, loc2.y);
    } else {
      fill(255, 128, 128);
    }
    noStroke();
    ellipse(loc.x, loc.y, t, t);
  }
}

void mazeGen() {
  if (!mainGen) {
    PVector start = mainPath.get(mainPath.size()-1);
    int x = round(start.x);
    int y = round(start.y);
    if (x == size-1 && y == size-1) {
      mainGen = true;
      int z = -1;
      int t = -1;
      for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
          if (!maze[i][j]) {
            z = i;
            t = j;
            i = size;
            j = size;
          }
        }
      }
      if (z == -1) {
        mazeGen = true;
      } else {
        paths.add(new ArrayList<PVector>());
        paths.get(paths.size()-1).add(new PVector(z, t));
        progress[z][t] = true;
        initial.set(z, t);
      }
    } else {
      boolean nup = false;
      boolean nright = false;
      boolean ndown = false;
      boolean nleft = false;
      if (y == 0) {
        nup = true;
      } else if (maze[x][y-1]) {
        nup = true;
      }
      if (x == size-1) {
        nright = true;
      } else if (maze[x+1][y]) {
        nright = true;
      }
      if (y == size-1) {
        ndown = true;
      } else if (maze[x][y+1]) {
        ndown = true;
      }
      if (x == 0) {
        nleft = true;
      } else if (maze[x-1][y]) {
        nleft = true;
      }
      if (nup && nright && ndown && nleft) {
        blocks++;
        for (int i = mainPath.size()-1; i > 0; i--) {
          mainPath.remove(i);
        }
        for (int i = 0; i < size; i++) {
          for (int j = 0; j < size; j++) {
            maze[i][j] = false;
          }
        }
        maze[0][0] = true;
      } else {
        int dir = round(random(1, 4));
        while ((dir == 1 && nup) || (dir == 2 && nright) || (dir == 3 && ndown) || (dir == 4 && nleft)) {
          dir = round(random(1, 4));
        }
        if (dir == 1) {
          mainPath.add(new PVector(x, y-1));
          maze[x][y-1] = true;
        } else if (dir == 2) {
          mainPath.add(new PVector(x+1, y));
          maze[x+1][y] = true;
        } else if (dir == 3) {
          mainPath.add(new PVector(x, y+1));
          maze[x][y+1] = true;
        } else if (dir == 4) {
          mainPath.add(new PVector(x-1, y));
          maze[x-1][y] = true;
        }
      }
    }
  } else {
    ArrayList<PVector> path = paths.get(paths.size()-1);
    PVector start = path.get(path.size()-1);
    int x = round(start.x);
    int y = round(start.y);
    if (maze[x][y]) {
      int z = -1;
      int t = -1;
      for (int i = 0; i < path.size()-1; i++) {
        maze[round(path.get(i).x)][round(path.get(i).y)] = true;
      }
      for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
          progress[i][j] = false;
        }
      }
      for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
          if (!maze[i][j]) {
            z = i;
            t = j;
            i = size;
            j = size;
          }
        }
      }
      if (z == -1) {
        mazeGen = true;
        for (int i = 0; i < size; i++) {
          for (int j = 0; j < size; j++) {
            maze[i][j] = false;
            progress[i][j] = false;
          }
        }
      } else {
        paths.add(new ArrayList<PVector>());
        paths.get(paths.size()-1).add(new PVector(z, t));
        progress[z][t] = true;
        initial.set(z, t);
      }
    } else {
      boolean nup = false;
      boolean nright = false;
      boolean ndown = false;
      boolean nleft = false;
      if (y == 0) {
        nup = true;
      } else if (progress[x][y-1]) {
        nup = true;
      }
      if (x == size-1) {
        nright = true;
      } else if (progress[x+1][y]) {
        nright = true;
      }
      if (y == size-1) {
        ndown = true;
      } else if (progress[x][y+1]) {
        ndown = true;
      }
      if (x == 0) {
        nleft = true;
      } else if (progress[x-1][y]) {
        nleft = true;
      }
      if (nup && nright && ndown && nleft) {
        blocks++;
        for (int i = path.size()-1; i > 0; i--) {
          path.remove(i);
        }
        for (int i = 0; i < size; i++) {
          for (int j = 0; j < size; j++) {
            progress[i][j] = false;
          }
        }
        progress[round(initial.x)][round(initial.y)] = true;
      } else {
        int dir = round(random(1, 4));
        while ((dir == 1 && nup) || (dir == 2 && nright) || (dir == 3 && ndown) || (dir == 4 && nleft)) {
          dir = round(random(1, 4));
        }
        if (dir == 1) {
          path.add(new PVector(x, y-1));
          progress[x][y-1] = true;
        } else if (dir == 2) {
          path.add(new PVector(x+1, y));
          progress[x+1][y] = true;
        } else if (dir == 3) {
          path.add(new PVector(x, y+1));
          progress[x][y+1] = true;
        } else if (dir == 4) {
          path.add(new PVector(x-1, y));
          progress[x-1][y] = true;
        }
      }
    }
  }
}

void reset() {
  for (int i = mainPath.size()-1; i > 0; i--) {
    mainPath.remove(i);
  }
  for (int i = paths.size()-1; i > 0; i--) {
    paths.remove(i);
  }
  for (int i = paths.get(0).size()-1; i >= 0; i--) {
    paths.get(0).remove(i);
  }
  for (int i = 0; i < size; i++) {
    for (int j = 0; j < size; j++) {
      maze[i][j] = false;
      progress[i][j] = false;
    }
  }
  initial.set(0, 0);
  maze[0][0] = true;
  mainGen = false;
  mazeGen = false;
  total += blocks;
  println(total/runs);
  blocks = 0;
  runs++;
  for (int i = draw.size()-1; i >= 0; i--) {
    draw.remove(i);
  }
}

void mouseReleased() {
  if (mazeGen) {
    if (draw.size() > 0) {
      float x = draw.get(draw.size()-1).x;
      float y = draw.get(draw.size()-1).y;
      if (floor(x*size/width)%size == size-1 && floor(y*size/height)%size == size-1) {
        reset();
      }
    }
  }
}