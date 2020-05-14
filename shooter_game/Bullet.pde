class Bullet{
  PVector v;
  PVector p;
  int len = 5;
  int damage;
  boolean collided;
  int text_dy = 25;
  int f_last_text_update = -1;
  
  Bullet(float x, float y, PVector v, int damage){
    this.p = new PVector(x, y);
    this.v = v;
    this.damage = damage;
    collided = false;
  }
  
  void display(){
    if (collided){
      fill(255, 0, 0);
      text(damage, p.x, p.y);
    }
    else {
      PVector nv = v.normalize(null);
      //stroke(240, 190, 0);
      stroke(255, 0, 0);
      line(p.x, p.y, p.x + len*nv.x, p.y + len*nv.y);
    }
  }
  
  void update(){
    if (!collided){
      p.add(v);
    }
    else if (text_dy > 0 && text_dy < 25){
      p.add(0, -2);
      text_dy -= 2;
      f_last_text_update = _FRAME_COUNTER;
    }
    else if (text_dy == 25){
      p.add(0, -11);
      text_dy -= 11;
    }
    
    garbage_collect();
  }
  
  int hit(){
    int damage_dealt = (!collided)? damage : 0;
    if (!collided){
      collided = true;
    }
    
    return damage_dealt;
  }
  
  void garbage_collect(){
    if (p.x < 0 || p.x > width || p.y < 0 || p.y > height || (f_last_text_update != -1 && _FRAME_COUNTER - f_last_text_update > 10)){
      gc_bullets.add(this);
    }
  }
}
