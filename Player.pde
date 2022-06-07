final PVector GRAVITY = new PVector(0, 0.01);

class Player {
  final float FRICTION = 0.8;
  final float MAX_HORIZONTAL_VEL = 0.15;


  boolean moving;

  final int WIDTH = 50;
  final int HEIGHT = 150;
  PVector vel;
  PVector pos;

  PImage img;

  public Player() {
    this.pos = new PVector(width / 2 - (WIDTH) + SIZE / 2, height / 2 + 25 - (HEIGHT)/ 2);
    this.vel = new PVector();
    img = loadImage("images/player.png");
    moving = false;
  }

  public void moveX(float xacc) {
    vel.add(new PVector(xacc, 0));
    if ((xacc < 0 && vel.x > 0) || (xacc > 0 && vel.x < 0)) vel.set(vel.x * FRICTION, vel.y);
    moving = true;
  }

  public boolean hasGround(float vely) {
    return world.blocks[(int)world.screenPos.x + width / 2 / SIZE][12 + (int)world.screenPos.y] != null &&
      world.blocks[(int)world.screenPos.x + width / 2 / SIZE][12 + (int)world.screenPos.y].playerTouching(pos.x, pos.y + vely, WIDTH, HEIGHT);
  }
  public boolean hasTopBlock(float vely) {
    return world.blocks[(int)world.screenPos.x + width / 2 / SIZE][9 + (int)world.screenPos.y] != null &&
      world.blocks[(int)world.screenPos.x + width / 2 / SIZE][9 + (int)world.screenPos.y].playerTouching(pos.x, pos.y + vely, WIDTH, HEIGHT);
  }
  public boolean notHasLeft(float velx) {
    boolean firstBlock = world.blocks[(int)world.screenPos.x + width / 2 / SIZE - 1][11 + (int)world.screenPos.y] != null;
    boolean secondBlock = world.blocks[(int)world.screenPos.x + width / 2 / SIZE - 1][10 + (int)world.screenPos.y] != null;
    boolean thirdBlock = world.blocks[(int)world.screenPos.x + width / 2 / SIZE - 1][9 + (int)world.screenPos.y] != null;
    return !(firstBlock && world.blocks[(int)world.screenPos.x + width / 2 / SIZE - 1][11 + (int)world.screenPos.y].playerTouching(pos.x + velx, pos.y, WIDTH, HEIGHT))
      && !(secondBlock && world.blocks[(int)world.screenPos.x + width / 2 / SIZE - 1][10 + (int)world.screenPos.y].playerTouching(pos.x + velx, pos.y, WIDTH, HEIGHT))
      && !(thirdBlock && world.blocks[(int)world.screenPos.x + width / 2 / SIZE - 1][9 + (int)world.screenPos.y].playerTouching(pos.x + velx, pos.y, WIDTH, HEIGHT));
  }
  public boolean notHasRight(float velx) {
    boolean firstBlock = world.blocks[(int)world.screenPos.x + width / 2 / SIZE + 1][11 + (int)world.screenPos.y] != null;
    boolean secondBlock = world.blocks[(int)world.screenPos.x + width / 2 / SIZE + 1][10 + (int)world.screenPos.y] != null;
    boolean thirdBlock = world.blocks[(int)world.screenPos.x + width / 2 / SIZE + 1][9 + (int)world.screenPos.y] != null;
    return !(firstBlock && world.blocks[(int)world.screenPos.x + width / 2 / SIZE + 1][11 + (int)world.screenPos.y].playerTouching(pos.x + velx, pos.y, WIDTH, HEIGHT))
      && !(secondBlock && world.blocks[(int)world.screenPos.x + width / 2 / SIZE + 1][10 + (int)world.screenPos.y].playerTouching(pos.x + velx, pos.y, WIDTH, HEIGHT))
      && !(thirdBlock && world.blocks[(int)world.screenPos.x + width / 2 / SIZE + 1][9 + (int)world.screenPos.y].playerTouching(pos.x + velx, pos.y, WIDTH, HEIGHT));
  }
  //public List<Block> getNeighboringBlocks() {
  //}

  //private Block getBlock(int dx, int dy) {
  //PVector pos = new PVector((int)pos.x
  //}

  public void run() {
    if (hasTopBlock(vel.y)) {
      vel.y = 0;
    }
    if (!hasGround(vel.y)) {
      int curNull = (12 + (int)world.screenPos.y);
      while (world.blocks[(int)world.screenPos.x + width / 2 / SIZE][curNull] == null) {
        curNull++;
      }
      vel.set(vel.x, min(vel.y + GRAVITY.y, world.blocks[(int)world.screenPos.x + width / 2 / SIZE][curNull].getYSpeedUntilTouching(pos.x, pos.y, false)));
    }
    if (vel.x < 0) {
      if (!notHasLeft(vel.x)) {
        boolean firstBlock = world.blocks[(int)world.screenPos.x + width / 2 / SIZE - 1][11 + (int)world.screenPos.y] != null;
        boolean secondBlock = world.blocks[(int)world.screenPos.x + width / 2 / SIZE - 1][10 + (int)world.screenPos.y] != null;
        boolean thirdBlock = world.blocks[(int)world.screenPos.x + width / 2 / SIZE - 1][9 + (int)world.screenPos.y] != null;
        float dist = 10000;
        if (firstBlock) {
          dist = world.blocks[(int)world.screenPos.x + width / 2 / SIZE - 1][11 + (int)world.screenPos.y].getXSpeedUntilTouching(pos.x, WIDTH, true);
        } else if (secondBlock) {
          dist = world.blocks[(int)world.screenPos.x + width / 2 / SIZE - 1][10 + (int)world.screenPos.y].getXSpeedUntilTouching(pos.x, WIDTH, true);
        } else if (thirdBlock) {
          dist = world.blocks[(int)world.screenPos.x + width / 2 / SIZE - 1][9 + (int)world.screenPos.y].getXSpeedUntilTouching(pos.x, WIDTH, true);
        }
        vel.set(min(vel.x, dist), vel.y);
      }
    } else {
      if (!notHasRight(vel.y)) {
        boolean firstBlock = world.blocks[(int)world.screenPos.x + width / 2 / SIZE + 1][11 + (int)world.screenPos.y] != null;
        boolean secondBlock = world.blocks[(int)world.screenPos.x + width / 2 / SIZE + 1][10 + (int)world.screenPos.y] != null;
        boolean thirdBlock = world.blocks[(int)world.screenPos.x + width / 2 / SIZE + 1][9 + (int)world.screenPos.y] != null;
        float dist = 10000;
        if (firstBlock) {
          dist = world.blocks[(int)world.screenPos.x + width / 2 / SIZE + 1][11 + (int)world.screenPos.y].getXSpeedUntilTouching(pos.x, WIDTH, true);
        } else if (secondBlock) {
          dist = world.blocks[(int)world.screenPos.x + width / 2 / SIZE + 1][10 + (int)world.screenPos.y].getXSpeedUntilTouching(pos.x, WIDTH, true);
        } else if (thirdBlock) {
          dist = world.blocks[(int)world.screenPos.x + width / 2 / SIZE + 1][9 + (int)world.screenPos.y].getXSpeedUntilTouching(pos.x, WIDTH, true);
        }
        vel.set(min(vel.x, dist), vel.y);
      }
    }
    vel.set(vel.x < 0 ? max(-MAX_HORIZONTAL_VEL, vel.x) : min(MAX_HORIZONTAL_VEL, vel.x), vel.y);
    if (!moving) vel.set(vel.x * FRICTION, vel.y);
    world.screenPos.add(vel);
    if (hasGround(vel.y)) {
      vel.set(vel.x, 0);
    }
    //println(vel.mag());
    moving = false;
  }

  public void display() {
    image(img, pos.x, pos.y, (WIDTH + (50 - WIDTH)), HEIGHT);
    PVector end = new PVector(mouseX, mouseY);
    PVector start = new PVector(pos.x + (WIDTH + (50 - WIDTH)) / 2, pos.y + HEIGHT / 2);
    end.sub(start);
    if (end.mag() > 2 * SIZE) {
      end.mult(1 / end.mag() * 3.2 * SIZE);
    }
    end.add(start);
    strokeWeight(20);
    stroke(color(100, 100, 100, 200));
    line(start.x, start.y, end.x, end.y);
  }
}
