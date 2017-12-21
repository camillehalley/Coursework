import java.io.File;
import java.util.*;
import java.lang.*;
void setup() {
  size(400, 400);// expand size as desired, program runs increasingly slower as size increases
  background(0);
  //fullScreen();
}
void draw(){
    loadPixels();
    float i = 0.0;
    int imgx = width; 
    int imgy = height;
    float n = 0.0;
    float smallOrBig = random(2);//randomly decide if we want many or few circles 
    if(int(smallOrBig) == 1){n = random(3,5);}
    else{n = random(5, 10);} // generate final # of circles
    int c = int(n);
    float a = PI * 2.0 / c;
    float r = sin(a) / sin((PI - a) / 2.0) / 2.0; 
    //radius of main circles
    float h = sqrt(1.0 - r * r);
    float xa = -h; float xb = h; float ya = -h; float yb = h;
    FloatList cx = new FloatList();
    FloatList cy = new FloatList();
    int centerCirc = int(1-r);
    FloatList cr = new FloatList();
    cr.append(centerCirc);
    
for(float q=0; q<=n; q++){ //add main circles
    cx.append(cos(a * q));
    cy.append(sin(a * q));
    cr.append(r);}
int maxIt = 64; // of iterations;
for(int ky = 0; ky <imgy; ky++){
    for(int kx = 0; kx< imgx; kx++){
        float x = float(kx) / (imgx - 1) * (xb - xa) + xa;
        float y = float(ky) / (imgy - 1) * (yb - ya) + ya;
        Deque<FloatList> deque = new LinkedList<FloatList>();  
        FloatList toAdd = new FloatList();
        toAdd.append(x); toAdd.append(y); toAdd.append(0.0);
        deque.addFirst(toAdd);
        while(deque.size() > 0){ // iterate through all points
            FloatList xyi = deque.pop();
            x = xyi.get(0);
            y = xyi.get(1);
            i = xyi.get(2);  
            for(int k =0; k <= (n); k++){
                float dx = x - cx.get(k); 
                float dy = y - cy.get(k);
                double temp = Math.hypot(dx, dy);
                float d = (float) temp;
                //float d = temp.float();
                if(d <= cr.get(k)){
                    dx = (dx / d); 
                    dy = (dy / d);
                    float dnew = cr.get(k)*cr.get(k) / d;
                    float xnew = dnew * dx + cx.get(k);
                    float ynew = dnew * dy + cy.get(k);
                    if((xnew >= xa) && (xnew <= xb) && (ynew >= ya) && (ynew <= yb)){
                        if(i + 1 == maxIt){ break;}
                        FloatList toAdd2 = new FloatList();
                        toAdd2.append(xnew);
                        toAdd2.append(ynew);
                        toAdd2.append(i+1);
                        deque.addFirst(toAdd2);
                      }}
      }}
          stroke(int(i % 16 * 16), int(i % 8 * 32), int(i % 4 * 64));
          point(kx,ky); 
    }}
    //save("circles.png"); //uncomment to save image

}