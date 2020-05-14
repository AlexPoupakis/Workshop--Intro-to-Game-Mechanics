int _FRAME_COUNTER = 0;
boolean game_paused = false, pause_key_released = true;

// Lists holding all the bullets and enemies.
ArrayList<Bullet> bullets = new ArrayList<Bullet>();
ArrayList<Enemy> enemies = new ArrayList<Enemy>();

// Lists holding all the bullets and enemies about to be garbage collected.
ArrayList<Bullet> gc_bullets = new ArrayList<Bullet>();
ArrayList<Enemy> gc_enemies = new ArrayList<Enemy>();

// Array of images for the parallax effect and their respective "depths". (01_ground.png is excluded because it looks weird in this context)
PImage[] parallax_background;
int[] parallax_translation_percentage = {0, 5, 20, 50, 20, 30, 45, 65, 90, 120};

Platform platform;

void setup(){
  size(800, 700);
  
  // Uncomment the line below to slow down the entire game and see the frame sequences in detail.
  //frameRate(10);
  
  platform = new Platform(0, 300);
  MachineGun MG = new MachineGun(0, 0);
  platform.setTurret(MG);
  
  Enemy_1 E1 = new Enemy_1(width+20, height/2);
  enemies.add(E1);
  E1 = new Enemy_1(width+80, 250);
  enemies.add(E1);
  
  Enemy_2 E2 = new Enemy_2(width+50, 50);
  enemies.add(E2);
  E2 = new Enemy_2(width+120, 100);
  enemies.add(E2);
  
  imageMode(CENTER);
  rectMode(CENTER);
  
  parallax_background = load_parallax_background_images();
}

void draw(){
  if (keyPressed && (key == 'p') && pause_key_released){
    game_paused = !game_paused;
    pause_key_released = false;
  }
  else if (!keyPressed){
    pause_key_released = true;
  }
  
  if (!game_paused){
    // UPDATE STEP
    platform.update();
    
    for (Enemy e : enemies){
      e.update();
    }
    remove_garbage_collected_items(enemies, gc_enemies);
    
    for (Bullet b : bullets){
      b.update();
    }
    remove_garbage_collected_items(bullets, gc_bullets);
  }
  
  
  // DISPLAY / RENDER STEP
  background(150);
  display_parallax_background();
  
  platform.display();
  for (Enemy e : enemies){
    e.display();
  }
  for (Bullet b : bullets){
    b.display();
  }
  
  if (game_paused){
    noStroke();
    fill(150, 50);
    rect(width/2, height/2, width, height);
    fill(255, 0, 0);
    textAlign(CENTER);
    textSize(18);
    text("GAME PAUSED", width/2, height/2 - 50);
  }
  
  
  // Show the frame rate and mouse x, y position on the top left.
  fill(0);
  textAlign(LEFT, BASELINE);
  textSize(11);
  text(nf(frameRate, 0, 2), 10, 15);
  text(mouseX+", "+mouseY, 10, 30);
  _FRAME_COUNTER++;
}


void remove_garbage_collected_items(ArrayList<?> list, ArrayList<?> gc_list){
  for (Object obj : gc_list){
    list.remove(obj);
  }
  gc_list.clear();
}


void display_parallax_background(){
  // Save current matrix and set middle of the screen as (0, 0).
  pushMatrix();
  translate(width/2, height/2);
  
  // Calculate (scaled down) the mouse offset from the middle of the screen. These values will be used to control the parallax effect.
  int mouseOffsetX = (width/2-mouseX)/15;
  int mouseOffsetY = (height/2-mouseY)/15;
  
  // For each image (from the back to the front), use the mouse offsets and its parallax translation percentage to calculate its actual (in pixels) offset from the middle of the screen.
  float offX = 0, offY = 0;
  int i=0;
  for (PImage img : parallax_background){
    offX = mouseOffsetX * parallax_translation_percentage[i]/100.0;
    offY = mouseOffsetY * parallax_translation_percentage[i]/100.0;
    image(img, int(offX), int(offY));
    i++;
  }
  
  // Restore transformation matrix
  popMatrix();
}




// ===== NON GAME-RELATED UTILITY FUNCTIONS =====
// ==============================================

int sign(float x){
  return (x >= 0)? 1 : -1;
}

PImage flipImageHorizontally(PImage img){
  PImage flippedImage = createImage(img.width, img.height, ARGB);
  flippedImage.loadPixels();
  img.loadPixels();
  
  for (int col=0; col < img.width; col++){
    for (int row=0; row < img.height; row++){
      flippedImage.pixels[row*img.width + (img.width-col-1)] = img.pixels[row*img.width + col];
    }
  }
  return flippedImage;
}

PImage[] load_parallax_background_images(){
  String folderpath = "background/";
  java.io.File folder = new java.io.File(dataPath(folderpath));
  String[] filenames = folder.list();
  
  PImage[] pack = new PImage[10];
  int id=1;
  for (int i = 0; i < filenames.length; i++) {
    if (filenames[i].startsWith("01"))  continue;
    if (filenames[i].toLowerCase().endsWith(".png")){
      pack[pack.length-id] = loadImage(folderpath+filenames[i]);
      pack[pack.length-id].resize(int(1.1*width), int(1.1*height));
      id++;
    }
  }
  return pack;
}

PImage[] load_all_sprites_in_folder(String folderpath, int resizedWidth, int resizedHeight){
  java.io.File folder = new java.io.File(dataPath(folderpath));
  String[] filenames = folder.list();
  PImage[] sprites = new PImage[filenames.length];
  
  for (int i=0; i<filenames.length; i++){
    sprites[i] = loadImage(folderpath+filenames[i]);
    sprites[i].resize(resizedWidth, resizedHeight);
  }
  return sprites;
}
