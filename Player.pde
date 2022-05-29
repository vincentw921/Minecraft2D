class Player {
  final float FRICTION = 0.8;
  final PVector GRAVITY = new PVector(0, -0.1);
  final float MAX_HORIZONTAL_VEL = 0.15;
  boolean moving;

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
    if((xacc < 0 && vel.x > 0) || (xacc > 0 && vel.x < 0)) vel.set(vel.x * FRICTION, vel.y);
    moving = true;
  }

  public void run(){
    //vel.add(GRAVITY);
    vel.set(vel.x < 0 ? max(-MAX_HORIZONTAL_VEL, vel.x) : min(MAX_HORIZONTAL_VEL, vel.x), vel.y);
    if(!moving) vel.set(vel.x * FRICTION, vel.y);
    world.screenPos.add(vel);
    //println(vel.mag());
    moving = false;
  }
  
  public void display() {
    int w = 50;
    int h = 150;
    image(img, pos.x - w / 2, pos.y - h / 2, w, h);
  }
}
