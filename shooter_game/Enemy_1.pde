class Enemy_1 extends Enemy{
  float speed = 2;
  int blade_rotation_period = 3;
  PVector current_velocity = new PVector(-speed, 0);    // we set a constant left-facing velocity, which will change when the enemy enters the frame margin, due to the "turn around when within the margin" logic in the update() method
  PVector v_direction = current_velocity, new_v_direction = current_velocity;
  PVector normal = new PVector(0, 0), prev_normal;
  int f_constructed, f_updated, f_started_turning = 0;
  int sprite_id = 0, explosion_sprite_id = 0;
  boolean isWithinMargin = false;
  
  Enemy_1(int x, int y){
    this.x = x;
    this.y = y;
    health = 8;
    
    // By initializing the f_constructed to the current (or a random) frame count, each enemy will have a corresponding blade rotation "phase" (translation: the animation will start from a different sprite). In the case below, if enemies
    // within a level are constructed in different frames (as they should), the resultant visual effect will be a lot more pleasing/detailed/realistic, thus adding a very subtle depth to the gam experience, in an exceedingly simple way.
    f_constructed = _FRAME_COUNTER;
    f_updated = _FRAME_COUNTER;
    
    load_sprites();
  }
  
  void display(){
    // Show the enemy sprite only if it's not destroyed, otherwise the explosion animation will be displayed instead of it
    if (health > 0){
      // check whether the sprite orientation is correct, or if it needs to be flipped
      boolean flip = (current_velocity.x >= 0)? true : false;
      // Calculate the sprite id (in two parts): if flipped, start from the middle of the array (otherwise, from the top), add the corresponding blade "phase" based on the elapsed frames.
      // The division by the rotation period keeps each blade "phase" for a few frames and the modulo contrains the number within the array length (notice that we keep the id within half the array indices, because we select a half based on the flip value).
      sprite_id = int(flip)*sprites.length/2 + (_FRAME_COUNTER - f_constructed) / blade_rotation_period % (sprites.length/2);
      image(sprites[sprite_id], x, y);
    }
    else {
      // Same logic as before, only this time each explosion "phase" is kept for one frame only
      // Note: always a good practice to ensure the index is within bounds, even though we are destroying the object as soon as the explosion animation is over (see garbage_collect() )
      image(explosion_sprites[explosion_sprite_id % explosion_sprites.length], x, y);
      explosion_sprite_id++;
    }
  }
  
  void update(){
    // Update the position, and velocity vector only if it's not destroyed
    if (health > 0){
      // Set the "I must start turning around" margin (in pixels)
      int margin = 80;
      prev_normal = normal;
      // Calculate the normal vector w.r.t. the arena bounds (= frame bounds).
      // This is the perpendicular vector to the bound we are about to cross (when we are within the margin), otherwise it's a zero vector, and it will help us turn around
      normal = new PVector((x > width-margin)? -1 : (x < margin)? 1 : 0, (y > height-margin)? -1 : (y < margin)? 1 : 0);
      
      /*if (normal.mag() == 0 && random(0, 1) < 0.01){
        float angle = random(-PI/3, PI/3);
        normal = v_direction.copy().rotate(angle);
      }*/
      
      // Here we are stopping an ongoing turn to deal with the fact that our "correction" is trying to go into a different (adjacent) margin
      // This works by resetting the math and logic parameters of the next if statement, in order to re-calculate a new direction (hopefully not into the other margin)
      if (normal.mag() > 0 && prev_normal.mag() > 0 && (normal.x != prev_normal.x || normal.y != prev_normal.y)){
        v_direction = current_velocity;
        isWithinMargin = false;
      }
      
      // Now we are actually deciding (randomly chosing) the new direction of motion
      if (normal.mag() > 0){
        // We are deciding only once, per distinct margin violation (not in every frame that the enemy did not yet have time to go back to the arena)
        // Note: if a different margin violation occurs while turning (i.e. we were close to the corner and took the wrong turn), the previous resetting of the parameters will re-trigger this direction control logic 
        if (!isWithinMargin){
          isWithinMargin = true;
          // pick a new angle of motion (but not almost parallel to the margin)
          float angle = random(-0.9*PI/2, 0.9*PI/2);
          // calculate the new direction by rotating the normal vector by the angle (ensuring, although we do not need to, that the magnitude is the constant speed defined above)
          new_v_direction = normal.copy().rotate(angle).setMag(speed);
          f_started_turning = _FRAME_COUNTER;
        }
      }
      // if the normal is a zero vector, that means that the turn is over and we can update the math and logic parameters
      else {
        isWithinMargin = false;
        v_direction = new_v_direction;
      }
      
      // The smooth turn works by linearly interpolating the old velocity vector and the new velocity vector (which we call direction, because they primarily indicate the direction of motion)
      // This interpolation is controlled by an amount (0.0 to 1.0 value) which we MUST ensure is ALWAYS in that interval, otherwise the resultant vector will be a multiplied version of what we wanted (BAD visual effect)
      // That is achieved by the min() function and the intermidiate amounts are, of course, calculated from the frame counters, where we (arbitrarily) set that the turn will take 60 frames to complete
      float lerp_amount = min(1, (_FRAME_COUNTER-f_started_turning)/60.0);
      current_velocity = PVector.lerp(v_direction, new_v_direction, lerp_amount);
      
      // And of course, we update the position
      x += current_velocity.x * (_FRAME_COUNTER - f_updated);
      y += current_velocity.y * (_FRAME_COUNTER - f_updated);
    }
    
    detect_collision();
    garbage_collect();
    
    f_updated = _FRAME_COUNTER;
  }
  
  void detect_collision(){
    // A (very) rudimentary collision detection algorithm. For each bullet, we have a hit if it is within the enemy's sprite and if the sprite's pixel is opaque (a 255 alpha channel value).
    
    int row, col;
    color pixel_color;
    for (Bullet b : bullets){
      col = int(b.p.x - (x - sprites[sprite_id].width/2));
      row = int(b.p.y - (y - sprites[sprite_id].height/2));
      
      if (col >= 0 && col < sprites[sprite_id].width && row >= 0 && row < sprites[sprite_id].height){
        pixel_color = sprites[sprite_id].get(col, row);
        
        if (alpha(pixel_color) == 255 && health > 0){
          health -= b.hit();
        }
      }
    }
  }
  
  void garbage_collect(){
    // The conditions for garbage collection of the object are that it's destroyed and that the explosion animation is over
    if (health <= 0 && explosion_sprite_id >= explosion_sprites.length){
      gc_enemies.add(this);
    }
  }
  
  void load_sprites(){
    sprites = new PImage[4];
    sprites[0] = loadImage("sprites/enemy_1_animation_1.png");
    sprites[1] = loadImage("sprites/enemy_1_animation_2.png");
    
    sprites[2] = flipImageHorizontally(sprites[0]);
    sprites[3] = flipImageHorizontally(sprites[1]);
    
    load_explosion_sprites(35, 35);
  }
}
