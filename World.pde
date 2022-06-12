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
        if (blocks[i][j] == null) continue;
        blocks[i][j].x = i;
        blocks[i][j].y = j;
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
        blocks[i][119 - h].x = i;
        blocks[i][119 - h].y = 119-h;
      }
      blocks[i][119 - maxH] = new Block(Blocks.LEAVES);
      blocks[i][119 - maxH].x = i;
      blocks[i][119 - maxH].y = 119-maxH;
      blocks[i-1][119-maxH] = new Block(Blocks.LEAVES);
      blocks[i-1][119 - maxH].x = i-1;
      blocks[i-1][119 - maxH].y = 119-maxH;
      blocks[i-1][119-maxH + 1] = new Block(Blocks.LEAVES);
      blocks[i-1][119 - maxH + 1].x = i-1;
      blocks[i-1][119 - maxH + 1].y = 119-maxH + 1;
      if (i + 1 < blocks.length) {
        blocks[i+1][119-maxH] = new Block(Blocks.LEAVES);
        blocks[i+1][119-maxH + 1] = new Block(Blocks.LEAVES);
        blocks[i+1][119-maxH].x = i + 1;
        blocks[i+1][119-maxH].y = 119 - maxH;
        blocks[i+1][119-maxH + 1].x = i + 1;
        blocks[i+1][119-maxH + 1].y = 119 - maxH + 1;
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

  public boolean hasPosition(int col, int row) {
    return col >= 0 && col < blocks.length && row >= 0 && row < blocks[0].length;
  }

  public boolean hasBlock(int col, int row) {
    if (!hasPosition(col, row)) return false;
    return blocks[col][row] != null;
  }

  public Block getBlock(int col, int row) {
    if (!hasPosition(col, row)) return null;
    return blocks[col][row];
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
    PVector end = new PVector(mouseX, mouseY);
    PVector start = new PVector(player.pos.x + player.WIDTH / 2, player.pos.y + player.HEIGHT / 2);
    end.sub(start);
    if (end.mag() > 3 * SIZE) {
      end.mult(1 / end.mag() * 3 * SIZE);
    }
    end.add(start);

    int x = (int)end.x / SIZE + (int)screenPos.x;
    int y = (int)end.y / SIZE + (int)screenPos.y;
    if (x >= blocks.length || x < 0 || y >= blocks[0].length || y < 0 ||
      blocks[x][y] == null) {
      return;
    }
    blocks[x][y].hit();
    if (blocks[x][y].health <= 0) {
      blocks[x][y].isDead = true;
      Block tmp = blocks[x][y];
      blocks[x][y] = null;
      if (blocks[x][y].btype == Blocks.DIAMOND) {
        if (inventory.inven[inHand] == null ||
          inventory.inven[inHand].tool == null ||
          inventory.inven[inHand].tool.ttype != PICKAXE ||
          !(inventory.inven[inHand].tool.tmaterial == Type.IRON ||
          inventory.inven[inHand].tool.tmaterial == Type.DIAMOND)) {
          return;
        }
      }
      if (blocks[x][y].btype == Blocks.STONE ||
        blocks[x][y].btype == Blocks.GRANITE ||
        blocks[x][y].btype == Blocks.DIORITE ||
        blocks[x][y].btype == Blocks.COAL) {
        if (inventory.inven[inHand] == null ||
          inventory.inven[inHand].tool == null ||
          inventory.inven[inHand].tool.ttype != PICKAXE) {
          return;
        }
      }
      if (blocks[x][y].btype == Blocks.GOLD) {
        if (inventory.inven[inHand] == null ||
          inventory.inven[inHand].tool == null ||
          inventory.inven[inHand].tool.ttype != PICKAXE ||
          !(inventory.inven[inHand].tool.tmaterial == Type.GOLD ||
          inventory.inven[inHand].tool.tmaterial == Type.IRON ||
          inventory.inven[inHand].tool.tmaterial == Type.DIAMOND)) {
          return;
        }
      }
      if (blocks[x][y].btype == Blocks.IRON) {
        if (inventory.inven[inHand] == null ||
          inventory.inven[inHand].tool == null ||
          inventory.inven[inHand].tool.ttype != PICKAXE ||
          !(inventory.inven[inHand].tool.tmaterial == Type.GOLD ||
          inventory.inven[inHand].tool.tmaterial == Type.STONE ||
          inventory.inven[inHand].tool.tmaterial == Type.IRON ||
          inventory.inven[inHand].tool.tmaterial == Type.DIAMOND)) {
          return;
        }
      }
      deadBlocks.addBlock(tmp);
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

  public void placeBlock() {
    if (inventory.inven[0][inHand] == null || inventory.inven[0][inHand].block == null) {
      return;
    }
    PVector location = new PVector(int(screenPos.x + mouseX / SIZE), int(screenPos.y + mouseY / SIZE));
    if (blocks[(int)location.x][(int)location.y] != null) {
      return;
    }
    if (blocks[(int)location.x + 1][(int)location.y] == null &&
      blocks[(int)location.x - 1][(int)location.y] == null &&
      blocks[(int)location.x][(int)location.y - 1] == null &&
      blocks[(int)location.x][(int)location.y + 1] == null) {
      return;
    }
    blocks[(int)location.x][(int)location.y] = inventory.inven[0][inHand].block;
    inventory.inven[0][inHand].amount--;
  }
}
