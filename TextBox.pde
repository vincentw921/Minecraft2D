void displayTextBox(int x, int y) {
  fill(100);
  imageMode(CORNER);
  rect(x,y,800,500,100);
  textAlign(CENTER);
  textSize(300);
  fill(255);
  text(saveAs, x + 800 / 2, y + 500 / 2);
}
