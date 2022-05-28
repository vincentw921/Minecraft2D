public enum Biome {
  SAND,
    GRASS,
    TREES;
}

class World {
  PVector screenPos;
  final int WORLD_WIDTH = 10000;
  final int WORLD_HEIGHT = 256;
  Block[][] blocks;
  Biome[] biome;

  public World() {
    this.screenPos = new PVector(WORLD_WIDTH / 2, 119);
    this.blocks = new Block[WORLD_WIDTH][WORLD_HEIGHT];
    int loc = 0;
    biome = new Biome[WORLD_WIDTH];
    while (loc < biome.length) {
      int add = (int)random(50, min(200, biome.length - loc));
      Biome b = Biome.values()[(int)random(Biome.values().length)];
      for (int i = loc; i < add; i++) {
        biome[i] = b;
      }
      loc += add;
    }

    for (int i = 0; i < blocks.length; i++) {
      for (int j = 0; j < blocks[0].length; j++) {
        blocks[i][j] = generateBlock(j, i);
      }
    }
    for (int i = 0; i < biome.length; i++) {
      if (biome[i] == Biome.TREES) {
        if (random(1) > 0.3) {
          continue;
        }
        for (int h = 0; h < random(3,8); h++) {
          blocks[i][119 - h] = new Block(Blocks.TREE);
        }
      }
    }
  }
  
  public void display() {
    int ox = (int)(screenPos.x);
    int oy = (int)(screenPos.y);
    for (int i = 0; i < width / SIZE + 1; i++) {
      for (int j = 0; j < height / SIZE + 1; j++) {
        if (blocks[ox + i][oy + j] == null) {
          continue;
        }
        blocks[ox + i][oy + j].display(i,j);
      }
    }
  }

  private Block generateBlock(int h, int w) {
    if (h < 120) {
      return null;
    } else if (h >= 120 && h <= 130 && (biome[w] == Biome.GRASS || biome[w] == Biome.TREES)) {
      if (h == 120) {
        return new Block(Blocks.GRASS);
      } else {
        return new Block(Blocks.DIRT);
      }
    } else if (h >= 120 && h <= 130 && biome[w] == Biome.SAND) {
      return new Block(Blocks.SAND);
    } else if (h > 130 && h < 60) {
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
    } else if (h >= 60 && h < 35) {
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
