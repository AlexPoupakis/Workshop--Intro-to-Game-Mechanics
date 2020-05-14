class Enemy_2 extends Enemy{
  float hv = 1.5;
  int blade_rotation_period = 5;
  int f_constructed, f_updated, f_destroyed = -1;
  float angle_of_fall = 0;
  
  Enemy_2(int x, int y){
    this.x = x;
    this.y = y;
    health = 15;
    f_constructed = _FRAME_COUNTER - _FRAMES_PAUSED;
    f_updated = _FRAME_COUNTER - _FRAMES_PAUSED;
    
    load_sprites();
  }
  
  void display(){
    // We select an id with the same logic as for Enemy_1 (notice now how we constrain the number within the entire array, rather than half the array
    sprite_id = (_FRAME_COUNTER - f_constructed) / blade_rotation_period % sprites.length;
    
    // Save the current transformation matrix, set (0, 0) as the sprite center and rotate the canvas by the angle of fall (so that the sprite looks rotated)
    pushMatrix();
    translate(x, y);
    rotate(angle_of_fall);
    
    image(sprites[sprite_id], 0, 0);
    
    // If the enemy is destroyed, we first show the explosion animation and then repeatedly show the smoke animation (until the enemy is out of frame, where we garbage collect it)
    if (health <= 0){
      if (explosion_sprite_id < explosion_sprites.length){
        // We do not necessarily need to constrain the value within the array bounds, because of the if statement and the fact that the increment follows the array access (and not the other way around)
        image(explosion_sprites[explosion_sprite_id], 0, 0);
        // The explosion is quite detailed so we skip every other frame (change it 1, or 3 to see the effect and how it is perceived differently)
        explosion_sprite_id+=2;
      }
      else {
        // Now we display the smoke, looping through the animation
        image(smoke_sprites[smoke_sprite_id % smoke_sprites.length], 0, 0);
        smoke_sprite_id++;
      }
    }
    
    // Undo the transformation matrix changes we made in this method and restore the previously saved transformations
    popMatrix();
  }
  
  void update(int _frame_counter){
    // The motion here is exceedingly simple, we have a constant horizontal speed (retained even when falling), a positive frame counter difference and we are moving from right to left, so we decrease the x value
    x -= hv*(_frame_counter-f_updated);
    
    // If the enemy is destroyed, we need to also update the y value and the angle of fall
    if (health <= 0){
      // This weird piece of code ensures that the f_destroyed is assigned a value only once, and then retains that value
      f_destroyed = (f_destroyed == -1)? _frame_counter : f_destroyed;
      // The y equation is some black magic voodoo that we came up with by considering that a) the free fall equation of height is quadratic in nature and b) there always exists a terminal velocity (which we set to 12)
      // With y = -1/2 * a * t² in mind, here a = 4, t is some scaled down (divided by 20) frame difference, and as soon as this equation exceeds the terminal velocity, it is replaced by 12 (also y increases because we are going from top to bottom)
      y += min(12, 2 * pow((_frame_counter - f_destroyed)/20.0, 2));
      
      // The angle of fall is defined w.r.t. the y-axis velocity of fall. We derive the angle by linearly mapping the dy value (number between 0 and 12) to the angle interval (from 0 to 60 degrees)
      angle_of_fall = map(min(12, 2 * pow((_frame_counter - f_destroyed)/20.0, 2)), 0, 12, 0, -PI/3);
    }
    
    garbage_collect();
    
    f_updated = _frame_counter;
  }
  
  int receive_hit(int damage, int row, int col){
    health -= damage;
    return damage;
  }
  
  /*void detect_collision(){
    // Same as in Enemy_1 but in a more compact form (if col, row is outside of the image, get() returns zero).
    int row, col;
    color pixel_color;
    for (Bullet b : bullets){
      col = int(b.p.x - (x - sprites[sprite_id].width/2));
      row = int(b.p.y - (y - sprites[sprite_id].height/2));
      pixel_color = sprites[sprite_id].get(col, row);
      
      if (alpha(pixel_color) == 255 && health > 0){
        health -= b.hit();
      }
    }
  }*/
  
  void garbage_collect(){
    // When the object exits the frame from the left or the bottom (and is entirely out of the frame), we garbage collect it
    if (x < -sprites[0].width || y > height + sprites[0].height){
      gc_enemies.add(this);
    }
  }
  
  void load_sprites(){
    sprites = new PImage[2];
    sprites[0] = loadImage("sprites/enemy_2_animation_1.png");
    sprites[1] = loadImage("sprites/enemy_2_animation_2.png");
    
    load_explosion_sprites();
    load_smoke_sprites();
  }
}
