// *** Adapted from 3-D galaxy by Michael Flinn ***  // 


ArrayList particles = new ArrayList();
ArrayList planets = new ArrayList();
ArrayList farPlanets = new ArrayList();
ArrayList starPlanets = new ArrayList();
float zDiff = random(-0.06, 0.06);
float xyDiff = random(-70, 70);


void setup(){
  fullScreen(P3D);
  noFill();
  frameRate(20);
}

void draw(){
  background(0);
  translate(width/2, height/2);
  rotateX(radians(1+mouseY/3));
  rotateY(radians(1+mouseX/3));
  if(planets.size() < 4){
     planets.add(new Planet(new PVector(sin(radians(xyDiff+frameCount*int(random(30))))*1.5, zDiff, cos(radians(xyDiff+frameCount*int(random(10))))*1.5), new PVector(int(random(-400, 400)), int(random(-400, 400)), int(random(-400, 400))), 1, color(int(random(255)), int(random(255)), int(random(255))), int(random(100))));
  }
  if(farPlanets.size() < 5){
         farPlanets.add(new Planet(new PVector(sin(radians(xyDiff+frameCount*int(random(30))))*1.5, zDiff, cos(radians(xyDiff+frameCount*int(random(10))))*1.5), new PVector(int(random(-400, 400)), int(random(-400, 400)), int(random(-500,500))), 2, color(int(random(255)), int(random(255)), int(random(255))), int(random(20))));

  }
  if(starPlanets.size() < 100){
         starPlanets.add(new Planet(new PVector(sin(radians(xyDiff+frameCount*int(random(30))))*1.5, zDiff, cos(radians(xyDiff+frameCount*int(random(10))))*1.5), new PVector(int(random(-400, 400)), int(random(-400, 400)), int(random(-500,500))), 2, color(255), int(random(2))));

  }
  
  for(int i = 0; i < 10; i++){
    float zDiff = random(-0.06, 0.06);
    float xyDiff = random(-70, 70);
    /* Use when it isn't in javascript mode */
    //float xyDiff = noise(i+frameCount)*150;
    //original
    particles.add(new Particle(new PVector(sin(radians(xyDiff+frameCount*4))*1.5, zDiff, cos(radians(xyDiff+frameCount*4))*1.5), 1));
    particles.add(new Particle(new PVector(-sin(radians(xyDiff+frameCount*4))*1.5, zDiff, -cos(radians(xyDiff+frameCount*4))*1.5), 1));
    //type II
    particles.add(new Particle(new PVector(sin(radians(xyDiff+frameCount*4))*1.5, zDiff, cos(radians(xyDiff+frameCount*4))*1.5), 2));
    particles.add(new Particle(new PVector(-sin(radians(xyDiff+frameCount*4))*1.5, zDiff, -cos(radians(xyDiff+frameCount*4))*1.5), 2));
    //type III
    particles.add(new Particle(new PVector(sin(radians(xyDiff+frameCount*4))*1.5, zDiff, cos(radians(xyDiff+frameCount*4))*1.5), 3));
    particles.add(new Particle(new PVector(-sin(radians(xyDiff+frameCount*4))*1.5, zDiff, -cos(radians(xyDiff+frameCount*4))*1.5), 3));
    

  }
    

  for(int i = 0; i < particles.size(); i++){
    Particle p = (Particle) particles.get(i);
    pushMatrix();
    p.draw();
    popMatrix();
    p.move(); 
  }
  
  for(int i = 0; i < planets.size(); i++){
    Planet p = (Planet) planets.get(i);
    pushMatrix();
    p.draw();
    popMatrix();
    p.move(); 
  }
  
  for(int i = 0; i < farPlanets.size(); i++){
    Planet p = (Planet) farPlanets.get(i);
    pushMatrix();
    p.draw();
    popMatrix();
    p.move(); 
  }
  
   for(int i = 0; i < starPlanets.size(); i++){
    Planet p = (Planet) starPlanets.get(i);
    pushMatrix();
    p.draw();
    popMatrix();
    p.move(); 
  }
}

class Particle {
  PVector loc, vel;
  int type;
  float life = random(100, 170);
  float maxLife = life;
  Particle(PVector vel, int type){
    this.type = type;
    if(type == 1){
    loc = new PVector(-100, -300, 0);}
     if(type == 2){
    loc = new PVector(200, 100, 200);}
     if(type == 3){
    loc = new PVector(-200, 400, 100);}
    this.vel = vel;
  }
  
  void draw(){
    translate(loc.x, loc.y, loc.z);
    float gAndA = map(life, 0, maxLife, 0, 255);
    if(type ==1){
    stroke(map(life, 0, maxLife, 150, 255), gAndA, map(life, 0, maxLife, 255, 0), gAndA);
    strokeWeight(map(life, 0, maxLife, 5, 1));}
    if(type ==2){
    stroke(map(life, 0, maxLife, 40, 210), gAndA, map(life, 0, maxLife, 210, 30), gAndA);
    strokeWeight(map(life, 0, maxLife, 5, 1));}
    if(type ==3){
    stroke(map(life, 0, maxLife, 200, 55), gAndA, map(life, 0, maxLife, 255, 90), gAndA);
    strokeWeight(map(life, 0, maxLife, 5, 1));}
    point(0, 0, 0);
    life--;
    if(life <= 0){
      particles.remove(this); 
    }
  }
  
  void move(){
    loc.add(vel); 
  }
}

class Planet {
  PVector loc, vel;
  color l;
  int type, size;
  float life = random(700, 1000);
  float maxLife = life;
  Planet(PVector vel, PVector loc, int type, color l, int size){
    this.type = type;
    this.size = size;
    this.loc = loc;
    this.l = l;
    this.vel = vel;
  }
  
  void draw(){
    translate(loc.x, loc.y, loc.z);
    stroke(this.l);
    pushMatrix();
    sphere(size);
    popMatrix();
    life--;
    if(life <= 0){
      if(type == 1){
      planets.remove(this); }
      if(type == 2){
        farPlanets.remove(this);}
    }
  }
  
  void move(){
    loc.add(vel); 
  }
}