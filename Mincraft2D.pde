World world;
Player player;

void setup(){
  size(1000, 1000);
  world = new World();
  player = new Player();
}
void draw(){
  world.display();
}
