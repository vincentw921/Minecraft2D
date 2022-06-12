public enum Blocks {
  TREE(new int[] {97, 59, 22}, 250 * 20),
    LEAVES(new int[] {12, 174, 91}, 150 * 20),
    WOOD(new int[] {150, 111, 51}, 250 * 20),
    GRASS(new int[] {86, 125, 70}, 150 * 20),
    DIRT(new int[] {155, 118, 83}, 150 * 20),
    SAND(new int[] {225, 217, 199}, 150 * 20),
    STONE(new int[] {136, 140, 141}, 500 *20),
    DIORITE(new int[] {157, 191, 177}, 500 * 20),
    GRANITE(new int[] {164, 135, 126}, 500 * 20),
    IRON(new int[] {161, 157, 148}, 750 * 20),
    COAL(new int[] {43, 45, 47}, 750 * 20),
    GOLD(new int[] {212, 175, 55}, 750 * 20),
    DIAMOND(new int[] {185, 242, 255}, 750 * 20),
    BEDROCK(new int[] {0, 0, 0}, Integer.MAX_VALUE);

  int[] col;
  float health;
  private Blocks(int[] col, float health) {
    this.col = col;
    this.health = health;
  }
}

final int SIZE = 50;
final int SIZE_DEAD = 10;

class Block {
  boolean isDead;
  float deadTimer = 100 * 60 * 30;

  Blocks btype;
  color c;
  int[] car;
  float health;

  float x, y;

  public Block(Blocks btype) {
    this.btype = btype;
    this.c = color(btype.col[0], btype.col[1], btype.col[2]);
    this.car = btype.col;
    this.health = btype.health;
    this.x = 0;
    this.y = 0;
  }

  public Block(int[] c, float health, int posX, int posY) {
    this.x = posX;
    this.y = posY;
    this.c = color(c[0], c[1], c[2]);
    this.car = c;
    this.health = health;
  }

  public void display(float x, float y) {
    if (isDead) {
      deadTimer--;
      stroke(0);
      strokeWeight(1);
      fill(c);
      square(this.x * SIZE, this.y * SIZE, SIZE_DEAD);
    }
    stroke(0);
    strokeWeight(1);
    fill(c);
    square(x * SIZE, y * SIZE, SIZE);
  }
  public void decreaseY() {
    if (world.blocks[(int)x][(int)y] == null) {
      y += 0.01;
    }
  }
  public void display(float x, float y, int size) {
    stroke(0);
    strokeWeight(1);
    fill(c);
    square(x, y, size);
  }
  
  public void display(int size) {
    float bx = x - world.screenPos.x;
    float by = y - world.screenPos.y;
    stroke(0);
    strokeWeight(1);
    fill(c);
    square(bx * 50 + 50 / 2 - 10, by * 50 - 20, size);
  }
  
  public boolean touching(float x, float y) {
    float bx = x - world.screenPos.x + (int)world.screenPos.x;
    float by = y - world.screenPos.y + (int)world.screenPos.y;
    return x >= bx - 1 && x <= bx + SIZE + 1
      && y >= by - 1 && y <= by + SIZE + 1;
  }
  public boolean touching(float x, float y, float SIZE) {
    float bx = (this.x - world.screenPos.x) * 50 + 50 / 2 - 10;
    float by = (this.y - world.screenPos.y) * 50;
    return x >= bx - 1 && x <= bx + SIZE + 1
      && y >= by - 1 && y <= by + SIZE + 1;
  }
  
  public PVector getPosition() {
    float bx = x - world.screenPos.x + (int)world.screenPos.x;
    float by = y - world.screenPos.y + (int)world.screenPos.y;
    
    return new PVector(bx, by);
  } 
  
  public boolean playerTouchingDead(float x, float y, float w, float h) {
    for (int i = 0; i < w; i++) {
      for (int j = 0; j < h; j++) {
        if (touching(x + i, y + j, 20)) {
          return true;
        }
      }
    }
    return false;
  }

  public boolean playerTouching(float x, float y, float w, float h) {
    for (int i = 0; i < w; i++) {
      for (int j = 0; j < h; j++) {
        if (touching(x + i, y + j)) {
          return true;
        }
      }
    }
    return false;
  }
  public float getXSpeedUntilTouching(float x, float w, boolean movingLeft) {
    float bx = x - world.screenPos.x + (int)world.screenPos.x;
    if (movingLeft) {
      return x - bx + SIZE;
    } else {
      return bx - (x + w);
    }
  }
  
  public float getYSpeedUntilTouching(float y, float h, boolean movingUp) {
    float by = y - world.screenPos.y + (int)world.screenPos.y;
    if (y + h > by) {
      movingUp = true;
    }
    if (movingUp) {
      return y - by + SIZE;
    } else {
      return by - (y + h);
    }
  }

  public void hit() {
    if (btype == Blocks.BEDROCK) {
      return;
    }
    this.health -= 50;
  }
}
