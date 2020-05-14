class Platform{
  int x, y;
  PImage platform;
  PVector anchor;
  int anchor_offset_Y = 10;    // Arises from the platform sprite. (try setting it to 0)
  Turret turret;
  
  Platform(int x, int y){
    this.x = x;
    this.y = y;
    platform = loadImage("sprites/platform.png");
    anchor = new PVector(129, 0);    // Also arises from the platform sprite.
  }
  
  void setTurret(Turret t){
    turret = t;
    turret.setPosition(x + int(anchor.x), y + int(anchor.y) + anchor_offset_Y);
  }
  
  void display(){
    imageMode(CORNER);
    image(platform, x, y);
    imageMode(CENTER);
    
    turret.display();
  }
  
  void update(int _frame_counter){
    turret.update(_frame_counter);
  }
}
