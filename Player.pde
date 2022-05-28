class Player {
  final float FRICTION = 0.5;
  final PVector GRAVITY = new PVector(0, 0.1);
  final float MAXVEL = 2;

  PVector vel;
  PVector pos;
  
  PImage img;

  public Player() {
    this.pos = new PVector(width / 2, height / 2);
    this.vel = new PVector();
    img = loadImage("player.png");
  }
  
  public void moveX(int xacc) {
    vel.add(xacc,0);
    vel.x = min(MAXVEL,vel.x);
    
    world.screenPos.add(vel);
    vel.mult(FRICTION);
    vel.add(GRAVITY);
  }
  
  public void display() {
    int w = 50;
    int h = 100;
    image(img, pos.x - w / 2, pos.y - h / 2, w, h);
  }
}
