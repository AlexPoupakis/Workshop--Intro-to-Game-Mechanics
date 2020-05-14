class Bullet{
  PVector v;
  PVector p;
  int bullet_length = 5;
  int damage;
  int damage_dealt;
  boolean collided, text_display_completed = false;
  int text_dy = 25;
  int f_updated, f_last_text_update = -1;
  
  Bullet(float x, float y, PVector v, int damage){
    this.p = new PVector(x, y);
    this.v = v;
    this.damage = damage;
    collided = false;
    
    f_updated = _FRAME_COUNTER - _FRAMES_PAUSED;
  }
  
  void display(){
    // If the bullet has collided, display the damage dealt as text
    if (collided){
      fill(255, 0, 0);
      text(damage_dealt, p.x, p.y);
    }
    // otherwise, display the actual bullet.
    else {
      // Create a vector, of magnitude bullet_length and of the same direction as the velocity, representing the bullet
      PVector bl = v.copy().setMag(bullet_length);
      stroke(255, 0, 0);
      // Display the bl vector from the point p.
      line(p.x, p.y, p.x + bl.x, p.y + bl.y);
    }
  }
  
  void update(int _frame_counter){
    // Here the vector p assumes two roles. Until the bullet collides, it represents its position, while after it collides, it represents the position of the text showing how much damage was dealt.
    
    if (!collided){
      // While the bullet has not collided, we increase its position by the constant velocity v and run the collision detection algorithm.
      p.add(v.copy().mult(_frame_counter - f_updated));
      detect_collision();
    }
    // If the bullet collided, and we have not yet displayed the text, we offset its position upwards by some amount.
    else if (text_dy == 25){
      p.add(0, -11);
      text_dy -= 11;
    }
    // If we are displaying the text, slightly decrease its position (within some bounds) to create that rising effect.
    else if (text_dy > 0 && text_dy < 25){
      p.add(0, -2);
      text_dy -= 2;
      f_last_text_update = _frame_counter;
    }
    
    // This is where we decide if we are done displaying the text. The conditions are (respectively) that we must have displayed the text at least once and that it has remained on its highest point for at least 8 frames.
    if (f_last_text_update != -1 && _frame_counter - f_last_text_update >= 8){
      text_display_completed = true;
    }
    
    garbage_collect();
    
    f_updated = _frame_counter;
  }
  
  int hit(){
    int damage_dealt = (!collided)? damage : 0;
    if (!collided){
      collided = true;
    }
    
    return damage_dealt;
  }
  
  void detect_collision(){
    // A (very) rudimentary collision detection algorithm. For each bullet, we have a hit if it is within the enemy's sprite and if the sprite's pixel is opaque (a 255 alpha channel value).
    int row, col;
    color pixel_color;
    for (Enemy e : enemies){
      col = int(p.x - (e.x - e.sprites[e.sprite_id].width/2));
      row = int(p.y - (e.y - e.sprites[e.sprite_id].height/2));
      
      if (col >= 0 && col < e.sprites[e.sprite_id].width && row >= 0 && row < e.sprites[e.sprite_id].height){
        pixel_color = e.sprites[e.sprite_id].get(col, row);
        
        if (alpha(pixel_color) == 255 && e.health > 0){
          damage_dealt = e.receive_hit(this.hit(), row, col);
        }
      }
    }
  }
  
  void garbage_collect(){
    if (p.x < 0 || p.x > width || p.y < 0 || p.y > height || text_display_completed){
      gc_bullets.add(this);
    }
  }
}
