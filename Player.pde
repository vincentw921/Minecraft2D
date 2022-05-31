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
    this.pos = new PVector(width / 2 - 25, height / 2 + 25);
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
  public boolean hasLeft() {
    return world.blocks[(int)world.screenPos.x + width / 2 / SIZE - 1][10 + (int)world.screenPos.y] != null 
          && world.blocks[(int)world.screenPos.x + width / 2 / SIZE - 1][9 + (int)world.screenPos.y] != null
          && world.blocks[(int)world.screenPos.x + width / 2 / SIZE - 1][8 + (int)world.screenPos.y] != null;
  }
  public boolean hasRight() {
    return world.blocks[(int)world.screenPos.x + width / 2 / SIZE + 1][13 + (int)world.screenPos.y] != null 
          && world.blocks[(int)world.screenPos.x + width / 2 / SIZE + 1][14 + (int)world.screenPos.y] != null
          && world.blocks[(int)world.screenPos.x + width / 2 / SIZE + 1][15 + (int)world.screenPos.y] != null;
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
    image(img, pos.x - WIDTH / 2, pos.y - HEIGHT / 2, WIDTH, HEIGHT);
  }
}
