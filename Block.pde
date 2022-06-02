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

  float x, y;

  public Block(Blocks btype) {
    this.btype = btype;
    this.c = color(btype.col[0], btype.col[1], btype.col[2]);
    this.car = btype.col;
    this.health = btype.health;
    this.x = 0;
    this.y = 0;
  }

  public Block(int[] c, float health) {
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
    this.x = x * SIZE;
    this.y = y * SIZE;
    stroke(0);
    strokeWeight(1);
    fill(c);
    square(x * SIZE, y * SIZE, SIZE);
  }
  public void display(float x, float y, int size) {
    this.x = x * size;
    this.y = y * size;
    stroke(0);
    strokeWeight(1);
    fill(c);
    square(x * size, y * size, size);
  }
  public boolean touching(float x, float y, float otherx, float othery) {
    return otherx > x && otherx < x + SIZE
      && othery > y && othery < y + SIZE;
  }

  public void hit() {
    if (btype == Blocks.BEDROCK) {
      return;
    }
    this.health -= 50;
  }
}
