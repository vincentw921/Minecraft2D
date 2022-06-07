public enum Blocks {
  TREE(new int[] {97, 59, 22}, 50),
    LEAVES(new int[] {12, 174, 91}, 50),
    WOOD(new int[] {150, 111, 51}, 50),
    GRASS(new int[] {86, 125, 70}, 50),
    DIRT(new int[] {155, 118, 83}, 50),
    SAND(new int[] {225, 217, 199}, 50),
    STONE(new int[] {136, 140, 141}, 50),
    DIORITE(new int[] {157, 191, 177}, 50),
    GRANITE(new int[] {164, 135, 126}, 50),
    IRON(new int[] {161, 157, 148}, 50),
    COAL(new int[] {43, 45, 47}, 50),
    GOLD(new int[] {212, 175, 55}, 50),
    DIAMOND(new int[] {185, 242, 255}, 50),
    BEDROCK(new int[] {0, 0, 0}, 10000);

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

  int x, y;

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
      square(this.x, this.y, SIZE_DEAD);
    }
    stroke(0);
    strokeWeight(1);
    fill(c);
    square(x * SIZE, y * SIZE, SIZE);
  }
  public void display(float x, float y, int size) {
    stroke(0);
    strokeWeight(1);
    fill(c);
    square(x * size, y * size, size);
  }
  
  public void display(int size) {
    float bx = x - world.screenPos.x + (int)world.screenPos.x;
    float by = y - world.screenPos.y + (int)world.screenPos.y;
    stroke(0);
    strokeWeight(1);
    fill(c);
    square(bx, by, size);
  }
  
  public boolean touching(float x, float y) {
    float bx = x - world.screenPos.x + (int)world.screenPos.x;
    float by = y - world.screenPos.y + (int)world.screenPos.y;
    return x >= bx - 1 && x <= bx + SIZE + 1
      && y >= by - 1 && y <= by + SIZE + 1;
  }
  
  public PVector getPosition() {
    float bx = x - world.screenPos.x + (int)world.screenPos.x;
    float by = y - world.screenPos.y + (int)world.screenPos.y;
    
    return new PVector(bx, by);
  } 

  public boolean playerTouching(float x, float y, float w, float h) {
    return touching(x, y) || touching(x + w, y) || touching(x, y + h) || touching (x + w, y + h) || touching(x,y + h/3) || touching(x + w, y + h/3) || touching(x, y + 2 * h / 3) || touching(x + w, y + 2 * h / 3)
     || touching(x, y + 7 * h / 10) || touching(x + w, y + 7 * h / 10) || touching(x, y + 8 * h / 10) || touching(x + w, y + 8 * h / 10);
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
