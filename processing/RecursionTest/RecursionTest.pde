boolean drawn;

void setup() {
    size(1280, 720, P2D);
    smooth(2);

    drawn = false;
}

void draw() {   
    if (!drawn) {
        background(20);
        stroke(255);
        noFill();

		float ms = millis();
        drawCircle(width / 2, height / 2, height / 1.15, 0, 8);
		//drawCircleIter(width / 2, height / 2, height / 1.15);
		println(millis() - ms);

        drawn = true;
    }
}


void drawCircle(float x, float y, float radius, float depth, float weight) {
    //strokeWeight(1);
    strokeWeight(weight / (depth + 1));
    stroke(255 - (255 / 10 * depth));
    ellipse(x, y, radius, radius);

    if (radius > 4) {
        depth += 1;
        float hRad = radius / 2;

        drawCircle(x + hRad, y, hRad, depth, weight);
        drawCircle(x - hRad, y, hRad, depth, weight);
    }
}

void drawCircleIter(float x, float y, float radius) {
    float[] pos = { x, y };
    float[] nextPos;
    float nextRadius;
    do {
        nextPos = new float[pos.length << 1];  
        nextRadius = radius / 2;
        
        for (int i = 0, j = 0; i < pos.length; i += 2, j += 4) {
            x = pos[i];
            y = pos[i + 1];
            
            nextPos[j] = x - nextRadius;
            nextPos[j + 1] = y;
            nextPos[j + 2] = x + nextRadius;
            nextPos[j + 3] = y;

            ellipse(x, y, radius, radius);
        }
        radius /= 2;
        pos = nextPos;
    } while (radius > 2);
}
