// These are the parent classes for different game objects. We could (should) have an abstract class Projectile to group bullets, rockets etc.
// The platform should be an abstract class, from which different level-specific platforms could be created (with more than one anchors and turrets).
// There should also be a Level or Campaign abstract class, a Wave class to handle each wave of enemies and so on.
// These are left to you to add, since you now have a working understanding of the basics of 2D games.

abstract class Turret{
  int x, y;
  
  void setPosition(int x, int y){
    this.x = x;
    this.y = y;
  }
  
  abstract void display();
  abstract void update(int _frame_counter);
}



abstract class Enemy{
  float x, y;
  int health;
  PImage[] sprites;
  PImage[] explosion_sprites;
  PImage[] smoke_sprites;
  int sprite_id = 0, explosion_sprite_id = 0, smoke_sprite_id = 0;
  
  abstract void display();
  abstract void update(int _frame_counter);
  abstract void garbage_collect();
 
  // This method accepts the damage by a projectile, deals with it accordingly and returns the actual damage dealt to the enemy.
  // It is important to have such a method, instead of simply decreasing the health in the collision detection algorithm, because this way we can factor in buffs, shields, critical areas, etc. for each enemy individually.
  // The row and col arguments refer to the sprite's specific pixel, where the enemy was hit. We do not use these arguments in this implementation, but if you consider armored and weaker areas (variable hit points), they will come in handy.
  abstract int receive_hit(int damage, int row, int col);
  
  // These methods (some) accept a resize factor (width, height in pixels) for the final sprites
  void load_explosion_sprites(){
    load_explosion_sprites(50, 50);
  }
  
  void load_explosion_sprites(int w, int h){
    explosion_sprites = load_all_sprites_in_folder("sprites/explosion/", w, h);
  }
  
  void load_smoke_sprites(){
    load_smoke_sprites(50, 50);
  }
  
  void load_smoke_sprites(int w, int h){
    smoke_sprites = load_all_sprites_in_folder("sprites/smoke/", w, h);
  }
}
