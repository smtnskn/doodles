void setup() {
    size(800, 800, P2D);
    frameRate(30);
    noStroke();
    //smooth(0);
}

float t = 0;

void draw() {
    int 	step = width / 5;	// 50
    float 	cMid = 255 / 2;

    background(0);

    for	(int x = 0; x < width; x += step) {    
        for (int y = 0; y < height; y += step) {
            float r = cMid + cMid * sin(x 	  + y 	  + t * 2);
            float g = cMid + cMid * sin(x 	  + y 	  + t);	// y * 2
            float b = cMid + cMid * cos(x * 2 + y 	  + t);

            //strokeWeight(step / 10);
            //stroke(r, g, b, 155);
            fill(r, g, b);

            //rect(x, y, step, step);

            float br = brightness(color(r, g, b));

            //float size = (step / 2 + ((br / 255) * step / 2));
            //float posMod = (step - size) / 2;
            //rect(x + posMod, y + posMod, size, size);

            float brMod = (br / 255) * step / 3;
            float size = (step / 3) * 2 + brMod;
            float posMod = (step - size) / 2;
            rect(x + posMod, y + posMod, size, size, posMod * 3); //step - (size / step) * step);
        }
    }

    t += 0.04;
}
