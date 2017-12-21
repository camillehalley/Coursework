float theta;   
//Tree branches now spiral out
void setup() {
  fullScreen();
}

void draw() {
  background(128, 255, 255);
  frameRate(30);
  stroke(236, 242, 249);
  IntList location = new IntList();
  int x = int(mouseX);
  int y = int(mouseY);
  location.append(x);
  location.append(y); 
  float a = 30;
  theta = radians(a);
  line(y,x,x,x);
  // Start branching
  translate((width/3),height/5);
  
  //various branch sizes give very different effects
  branch(400); //gives an eerie ice cave effect
  //branch(150); //shows basic tree structure
  //branch(10); //simplistic 
  
  
  
 // uncomment to save image on click
 //if(mousePressed){ 
 //  float varNum = random(0, 700);
 //  save("tree.jpg");
 //  //save(str(varNum) + ".jpg");
 //}
}

void branch(float h) {
  // Each branch will be 2/3rds the size of the previous one
  h *= 0.66;
  if (h > 2) {
    // right branch
    pushMatrix();    
    rotate(theta);   
    line(mouseX, mouseY, 0, -h);  // Draw the branch
    translate(0, -h); // Move to the end of the branch
    branch(h);       // recursion
    popMatrix();     
    // left branch
    pushMatrix();
    rotate(-theta);
    line(0, 0, 0, -h);
    translate(0, -h);
    branch(h);
    popMatrix();
  }
}