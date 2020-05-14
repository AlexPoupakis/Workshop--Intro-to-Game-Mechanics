class MachineGun extends Turret{
  PImage MG_base, MG_head;
  PImage[] blast;
  int f_lastFired = 0;
  PVector CtG1 = new PVector(60-30, 34-22);    // Head's Center-to-Gun vectors. The actual values arise from the head sprite (the bottom gun's end is at 60, 34 pixels and the center is at 30, 22). Due to symmetry, the other vector can be derived by mirroring the first.
  PVector CtG2 = new PVector(CtG1.x, -CtG1.y);
  int reload = 10;    // 10 frames reload period
  float angle = 0;
  
  MachineGun(int x, int y){
    setPosition(x, y);
    
    // We initialize the lastfired frame register in this way because if we set it to zero, the if statement controlling the blast animation will trigger and wrongly display it at the very start.
    f_lastFired = _FRAME_COUNTER-5;
    
    load_sprites();
  }
  
  void display(){
    // Save the matrix transformations and move (0, 0) to the center of the machine gun head (so that we can rotate the head later).
    // Note: the x, y coordinates refer to the bottom center of the machine gun.
    pushMatrix();
    translate(x, y-MG_base.height);
    
    // Draw the base
    image(MG_base, 0, MG_base.height/2);
    
    // Rotate the canvas and place the head.
    // Note: for a concentric rotation of an image, the canvas (0, 0) must be the same as the sprite's center (try changing either of the zeros in the commad below with some other number, say 10, and see what happens in each case).
    rotate(angle);
    image(MG_head, 0, 0);
    
    // Each time the machine gun fires, we add an explosion effect in front of the guns.
    if (_FRAME_COUNTER - f_lastFired <= 4){
      // The sequence of blasts is displayed in the following order: light, light, heavy, heavy, light.
      int blast_sprite_id = (_FRAME_COUNTER - f_lastFired) / 2 % 2;
      
      // We need to calculate the position (center) of the blast sprites. Because the canvas is already rotated (!!!), the desired position will be the center-to-gun vector plus an x-offset (vector with 0 y value) of blast-sprite-width / 2.
      // Note: a) if it is not obvious why the position of the blast sprite is given by this equation, try to understand it without any rotation in mind (i.e. the gun facing only right)
      //       b) the way it is written, we must copy the center-to-gun vectors, otherwise we would be changing their value (B A D).
      PVector pBlast1 = CtG1.copy().add(blast[blast_sprite_id].width/2+1, 0);
      PVector pBlast2 = CtG2.copy().add(blast[blast_sprite_id].width/2+1, 0);
      image(blast[blast_sprite_id], pBlast1.x, pBlast1.y);
      image(blast[blast_sprite_id], pBlast2.x, pBlast2.y);
    }
    
    // Of course, remove the transformations by restoring the previously saved transformation matrix.
    popMatrix();
  }
  
  void update(){
    // Calculate the angle by which the gun must be rotated (always w.r.t. the right direction, not its current angle) in order to face the mouse.
    // Create a vector that points from the head's center to the mouse (remember, the x, y coordinates show the bottom center of the machine gun).
    PVector MG_to_mouse = new PVector(mouseX-x, mouseY-(y-MG_base.height));
    // Define the 0-angle vector, a vector "facing" right.
    PVector ang_norm = new PVector(1, 0);
    // The desired angle of rotation is given by the angle between those two vectors.
    // Note: angleBetween() returns a number in the interval [0, PI). In order to rotate the gun in either direction, we need to multiply that angle by the sign of the head's-center-to -mouse vector's y value. Try removing the sign() and see what happens.
    angle = PVector.angleBetween(MG_to_mouse, ang_norm) * sign(MG_to_mouse.y);
    
    // Here we handle the gun's firing, which happens when we are pressing the left mouse button and the gun has reloaded.
    if (mousePressed && mouseButton == LEFT && _FRAME_COUNTER - f_lastFired > reload){
      // The calculation for the position of the bullets is mathematically simple, but it may be intuitively subtle.
      // The bullets do not know of the rotation of the canvas and all other transformations we make in the animate() method. Therefore, these relations need to be transfered to the bullet's position and velocity.
      // Their position is derived from turning the head's center-to-gun vectors
      PVector pB1 = CtG1.copy().rotate(angle);
      PVector pB2 = CtG2.copy().rotate(angle);
      
      // and then we need to add the resultant vector, not to the plain x, y coordinates, but to the offset x, y coordinates that correspond to the head's center.  The velocity has an arbitrary magnitude of 10 and the angle of the machine gun's head.
      Bullet b1 = new Bullet(x + pB1.x, y-MG_base.height + pB1.y, PVector.fromAngle(angle).mult(10), 1);
      Bullet b2 = new Bullet(x + pB2.x, y-MG_base.height + pB2.y, PVector.fromAngle(angle).mult(10), 1);
      
      // The newly created bullets need to be added to the global projectile list, so that the game loop can address them.
      bullets.add(b1);
      bullets.add(b2);
      
      f_lastFired = _FRAME_COUNTER;
    }
  }
  
  void load_sprites(){
    MG_base = loadImage("sprites/machine_gun_base.png");
    MG_head = loadImage("sprites/machine_gun_head.png");
    blast = new PImage[2];
    blast[0] = loadImage("sprites/machine_gun_blast_light.png");
    blast[1] = loadImage("sprites/machine_gun_blast_heavy.png");
  }
}
