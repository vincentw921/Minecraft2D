class Inventory {
  final int rows = 5;
  final int cols = 6;
  final int invenWidth = width - 300;
  final int invenHeight = 5 * invenWidth / 6;
  Item[][] inven;
  color border;
  color inside;

  public Inventory() {
    border = color(150);
    inside = color(200, 200, 200, 200);
    inven = new Item[rows][cols];
  }

  public void display() {
    fill(inside);
    stroke(border);
    strokeWeight(6);
    int leftX = (width - invenWidth) / 2;
    int rightX = width - leftX;
    int topY = (height - invenHeight) / 2;
    int bottomY = height - topY;
    rect(leftX, topY, invenWidth, invenHeight, 23);

    stroke(border);
    strokeWeight(3);
    int cellWidth = (rightX - leftX) / (cols + 1);
    int cellHeight = (bottomY - topY) / (rows + 1);
    for (int r = 1; r < rows + 1; r++) {
      for (int c = 1; c < cols + 1; c++) {
        //vertical line
        line(leftX + c * cellWidth, topY, leftX + c * cellWidth, bottomY);
        //horizontal line
        line(leftX, topY + r * cellHeight, rightX, topY + r * cellHeight);
        if (inven[r-1][c-1] == null) {
          continue;
        }
        inven[r-1][c-1].display(leftX + c * cellWidth, topY + r * cellHeight, (bottomY - topY) / rows);
      }
    }
  }

  public void addItem(Item item) {
    int curItem;
    for (curItem = 0; curItem <= inven.length; curItem++) {
      if (curItem >= inven.length) {
        return;
      }
      if (inven[curItem % cols][curItem / cols] == null) {
        break;
      }
    }
    if (item.block == null) {
      inven[curItem % cols][curItem / cols] = item;
    } else {
      for (int items = 0; items < curItem; items++) {
        if (inven[items % cols][items / cols].block != null
          && inven[items % cols][items / cols].block.btype == item.block.btype
          && inven[items % cols][items / cols].amount <= 64) {
          inven[items % cols][items / cols].amount++;
        }
      }
    }
  }

  public void remove(int pos) {
    inven[pos % cols][pos / cols] = null;
  }

  public void move(int pos, int otherPos) {
    Item temp = null;
    if (inven[otherPos % cols][otherPos / cols] != null) {
      temp = inven[otherPos % cols][otherPos / cols];
    }
    inven[otherPos % cols][otherPos / cols] = inven[pos % cols][pos / cols];
    inven[pos % cols][pos / cols] = temp;
  }
}
