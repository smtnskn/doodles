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
        //strokeWeight(2);
        noFill();
        
        float ms = millis();
        drawCircle(width / 2, height / 2, height / 2, 8, 0);
        //drawCircleIter(width / 2, height / 2, height / 2, 8);
        println(millis() - ms);
        
        drawn = true;
    }
}

void drawCircle(float x, float y, float radius, int minRadius, int depth) {
    if (radius > minRadius) {
        stroke(255 - (255 / 20 * depth));
    	ellipse(x, y, radius, radius);
        
        depth += 1;
        float hRad = radius / 2;

        drawCircle(x + hRad, y, hRad, minRadius, depth);
        drawCircle(x - hRad, y, hRad, minRadius, depth);
        drawCircle(x, y + hRad, hRad, minRadius, depth);
        drawCircle(x, y - hRad, hRad, minRadius, depth);
    }
}

void drawCircleIter(float x, float y, float radius, int minRadius) {
    float[] pos = { x, y };
    float[] nextPos;
    float nextRadius;
    do {
        nextPos = new float[pos.length << 2];  
        nextRadius = radius / 2;
        for (int i = 0, j = 0; i < pos.length; i += 2, j += 8) {
            x = pos[i];
            y = pos[i + 1];
            
            nextPos[j] = x - nextRadius;
            nextPos[j + 1] = y;
            nextPos[j + 2] = x + nextRadius;
            nextPos[j + 3] = y;
            nextPos[j + 4] = x;
            nextPos[j + 5] = y - nextRadius;
            nextPos[j + 6] = x;
            nextPos[j + 7] = y + nextRadius;           

            ellipse(x, y, radius, radius);
        }
        radius = nextRadius;
        pos = nextPos;
    } while (radius > minRadius);
}
