class Player {
  final float FRICTION = 0.8;
  final PVector GRAVITY = new PVector(0, 0.01);
  final float MAX_HORIZONTAL_VEL = 0.15;


  boolean moving;

  final int WIDTH = 50;
  final int HEIGHT = 150;
  PVector vel;
  PVector pos;

  PImage img;

  public Player() {
    this.pos = new PVector(width / 2 - WIDTH / 2, height / 2 + 25 - HEIGHT / 2);
    this.vel = new PVector();
    img = loadImage("images/player.png");
    moving = false;
  }

  public void moveX(float xacc) {
    vel.add(new PVector(xacc, 0));
    if ((xacc < 0 && vel.x > 0) || (xacc > 0 && vel.x < 0)) vel.set(vel.x * FRICTION, vel.y);
    moving = true;
  }
  
  public boolean hasGround() {
    return world.blocks[(int)world.screenPos.x + width / 2 / SIZE][12 + (int)world.screenPos.y] != null;
  }
  public boolean notHasLeft() {
    return world.blocks[(int)world.screenPos.x + width / 2 / SIZE - 1][11 + (int)world.screenPos.y] == null 
          && world.blocks[(int)world.screenPos.x + width / 2 / SIZE - 1][10 + (int)world.screenPos.y] == null
          && world.blocks[(int)world.screenPos.x + width / 2 / SIZE - 1][9 + (int)world.screenPos.y] == null;
  }
  public boolean notHasRight() {
    return world.blocks[(int)world.screenPos.x + width / 2 / SIZE + 1][11 + (int)world.screenPos.y] == null 
          && world.blocks[(int)world.screenPos.x + width / 2 / SIZE + 1][10 + (int)world.screenPos.y] == null
          && world.blocks[(int)world.screenPos.x + width / 2 / SIZE + 1][9 + (int)world.screenPos.y] == null;
  }

  public void run() {
    if (!hasGround()) {
      vel.add(GRAVITY);
    }
    int curNull = (12 + (int)world.screenPos.y);
    while (world.blocks[(int)world.screenPos.x + width / 2 / SIZE][curNull] == null) {
      curNull++;
    }
    curNull--;
    vel.set(vel.x, min(vel.y, abs(11 + (int)world.screenPos.y - curNull)));
    vel.set(vel.x < 0 ? max(-MAX_HORIZONTAL_VEL, vel.x) : min(MAX_HORIZONTAL_VEL, vel.x), vel.y);
    if (!moving) vel.set(vel.x * FRICTION, vel.y);
    world.screenPos.add(vel);
    //println(vel.mag());
    moving = false;
  }

  public void display() {
    image(img, pos.x, pos.y, WIDTH, HEIGHT);
    PVector end = new PVector(mouseX, mouseY);
    PVector start = new PVector(pos.x + WIDTH / 2, pos.y + HEIGHT / 2);
    end.sub(start);
    if (end.mag() > 2 * SIZE) {
      end.mult(1 / end.mag() * 2 * SIZE);
    }
    end.add(start);
    strokeWeight(20);
    stroke(color(100,100,100,200));
    line(start.x, start.y, end.x, end.y);
  }
}
