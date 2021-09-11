float t;
int x, y, xStep, yStep;
boolean DOODLE;

void setup()
{
    size(1280, 720, P2D);
    frameRate(60);
    smooth(2);
    background(0);

    stroke(random(255), random(255), random(255));
    strokeWeight(2);
    //fill(255);
    noFill();

    DOODLE = true;
   
    if (DOODLE) {
        x = int(noise(t) * width);
    } else {
        x = 0;
        xStep = 10;
    }

    y = int(noise(t) * height);
}

void draw()
{  
    if (DOODLE) {
        int newX = int(noise(t * 2) * width);
        int newY = int(noise(t) * height);
        strokeWeight(abs(x + y - newX - newY));
        stroke(255 * (x / width), 255 * noise(t * 3), 255 - (255 * (y / height)));
        
        //background(0);
        line(x, y, newX, newY);
        
        x = newX;
        y = newY;
    } else {
        line(x, y, x += xStep * noise(t), (y = int(noise(t) * height)));

        if (x >= width) {
            x = 0;
            stroke(random(255), random(255), random(255));
        }
    }

    t += 0.005;
}
