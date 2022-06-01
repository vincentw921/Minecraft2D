class Button {
  PImage button;
  float x, y, r;
  boolean selected;

  Button(String image, float x, float y, float r) {
    button = loadImage(image);
    button.resize(int(2 * r), int(2 * r));
    this.x = x;
    this.y = y;
    this.r = r;
    selected = false;
  }

  void display() {
    stroke(120);
    strokeWeight(1);
    fill(255);
    circle(x, y, r*2);
    image(button, x - r, y - r);
    if (selected) {
      noStroke();
      fill(0, 0, 0, 120);
      circle(x, y, r*2);
    }
  }

  void checkHeld() {
    if (dist(mouseX, mouseY, x, y) <= r && mousePressed) selected = !selected;
  } 
}
