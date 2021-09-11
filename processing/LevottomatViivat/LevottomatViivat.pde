void settings() {
	size( (int)(displayWidth  / 1.25),
		  (int)(displayHeight / 1.25),
		  P2D );
	smooth(2);
}

void setup() {
    //size(600, 600);  
	//background(0);
	stroke(255);
}  

float theta_x = 0;
float theta_y = 0;
float delta_x = 0.04;
float delta_y = delta_x / 3;
float spd_up = delta_x;
float rand_x = 0;
float rand_y = 0;
float randDist = 4;
float lineRandDist = 2;

void draw() {
    if (mousePressed) {
        theta_x += spd_up;
        theta_y += spd_up * 2;
    }
    
    float cx = (width  / 2) + (rand_x += random(-randDist, randDist)) + 100 * sin(theta_x);
    float cy = (height / 2) + (rand_y += random(-randDist, randDist)) + 100 * cos(theta_x);
    //float cx = mouseX;
    //float cy = mouseY;
    float mult_x = sin(theta_x += delta_x);
    float mult_y = cos(theta_y += delta_y);
    float x_mod = mult_x * 200;
    float y_mod = mult_y * 100;
    
    background(	127.5 *  mult_x + 127.5 * -mult_y,
    			127.5 			+ 127.5 *  mult_y,
    			127.5 * -mult_x + 127.5 *  mult_y );
    
    strokeWeight(2);
    
    float lineRandX = random(-lineRandDist, lineRandDist);
    float lineRandY = random(-lineRandDist, lineRandDist);
    
    line( cx - x_mod + lineRandX,
    	cy + y_mod + lineRandY,
    	cx + x_mod - lineRandX, 
    	cy - y_mod - lineRandY );
    
    lineRandX = random(-lineRandDist, lineRandDist);
    lineRandY = random(-lineRandDist, lineRandDist);
    
    line( cx - y_mod + lineRandX,
    	cy + x_mod + lineRandY, 
    	cx + y_mod - lineRandX,
    	cy - x_mod - lineRandY );
    
    //fill(150);
    //strokeWeight(3);
    //ellipse(cx, cy, 150, 150);
    
    //noFill();
    //strokeWeight(3);
    //ellipse(cx, cy, 10, 10);
}
