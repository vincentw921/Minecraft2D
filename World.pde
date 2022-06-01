class World {
  PVector screenPos;
  final int WORLD_WIDTH = 10000;
  final int WORLD_HEIGHT = 256;
  Block[][] blocks;

  public World() {
    this.screenPos = new PVector(WORLD_WIDTH / 2, 108);
    this.blocks = new Block[WORLD_WIDTH][WORLD_HEIGHT];

    for (int i = 0; i < blocks.length; i++) {
      for (int j = 0; j < blocks[0].length; j++) {
        blocks[i][j] = generateBlock(j);
      }
    }
    int prevTree = 3;
    for (int i = 0; i < blocks.length; i++) {
      if (i == WORLD_WIDTH / 2 - 1 || i == WORLD_WIDTH / 2 || i == WORLD_WIDTH / 2 + 1) {
        continue;
      }
      if (random(1) > 0.1 || prevTree > 0) {
        prevTree--;
        continue;
      }
      prevTree = 3;
      int maxH = (int)random(3, 8);
      for (int h = 0; h < maxH; h++) {
        blocks[i][119 - h] = new Block(Blocks.TREE);
      }
      blocks[i][119 - maxH] = new Block(Blocks.LEAVES);
      blocks[i-1][119-maxH] = new Block(Blocks.LEAVES);
      blocks[i-1][119-maxH + 1] = new Block(Blocks.LEAVES);
      if (i + 1 < blocks.length) {
        blocks[i+1][119-maxH] = new Block(Blocks.LEAVES);
        blocks[i+1][119-maxH + 1] = new Block(Blocks.LEAVES);
      }
    }

    for (int i = 0; i < blocks.length; i++) {
      blocks[i][0] = new Block(Blocks.BEDROCK);
      blocks[i][blocks[0].length - 1] = new Block(Blocks.BEDROCK);
    }
    for (int j = 0; j < blocks[0].length; j++) {
      blocks[0][j] = new Block(Blocks.BEDROCK);
      blocks[blocks.length - 1][j] = new Block(Blocks.BEDROCK);
    }
  }

  public void display() {
    float ox = screenPos.x;
    float oy = screenPos.y;
    for (int i = 0; i < width / SIZE + 1; i++) {
      for (int j = 0; j < height / SIZE + 1; j++) {
        if ((int)ox + i >= blocks.length || (int)oy + j >= blocks[0].length
          || (int)ox + i < 0 || (int)oy + j < 0) {
          continue;
        }
        if (blocks[(int)ox + i][(int)oy + j] == null) {
          continue;
        }
        blocks[(int)ox + i][(int)oy + j].display(i - ox + (int)ox, j - oy + (int)oy);
      }
    }
  }


  public void checkHit() {
    int x = (int)mouseX / SIZE + (int)screenPos.x;
    int y = (int)mouseY / SIZE + (int)screenPos.y;
    if (x > blocks.length || x < 0 || y > blocks[0].length || y < 0 ||
      blocks[x][y] == null) {
      return;
    }
    blocks[x][y].hit();
    if (blocks[x][y].health <= 0) {
      blocks[x][y] = null;
    }
  }
  
  private Block generateBlock(int h) {
    if (h < 120) {
      return null;
    } else if (h >= 120 && h <= 125) {
      if (h == 120) {
        return new Block(Blocks.GRASS);
      } else {
        return new Block(Blocks.DIRT);
      }
    } else if (h > 125 && h < 150) {
      float val = random(1);
      if (val > 0.5) {
        return new Block(Blocks.STONE);
      } else if (val > 0.25) {
        return new Block(Blocks.GRANITE);
      } else if (val > 0.1) {
        return new Block(Blocks.DIORITE);
      } else if (val > 0.05) {
        return new Block(Blocks.COAL);
      } else {
        return new Block(Blocks.IRON);
      }
    } else if (h >= 150 && h < 200) {
      float val = random(1);
      if (val > 0.5) {
        return new Block(Blocks.STONE);
      } else if (val > 0.25) {
        return new Block(Blocks.GRANITE);
      } else if (val > 0.15) {
        return new Block(Blocks.DIORITE);
      } else if (val > 0.1) {
        return new Block(Blocks.COAL);
      } else if (val > 0.5) {
        return new Block(Blocks.IRON);
      } else {
        return new Block(Blocks.GOLD);
      }
    } else {
      float val = random(1);
      if (val > 0.5) {
        return new Block(Blocks.STONE);
      } else if (val > 0.35) {
        return new Block(Blocks.GRANITE);
      } else if (val > 0.2) {
        return new Block(Blocks.DIORITE);
      } else if (val > 0.15) {
        return new Block(Blocks.GOLD);
      } else if (val > 0.1) {
        return new Block(Blocks.IRON);
      } else if (val > 0.05) {
        return new Block(Blocks.COAL);
      } else {
        return new Block(Blocks.DIAMOND);
      }
    }
  }
}
