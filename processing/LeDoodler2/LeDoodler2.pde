float xTime, yTime, timeStepX, timeStepY;
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
    //strokeCap(PROJECT);
    //fill(255);
    noFill();

    DOODLE = true;

    xTime = random(10) + random(10);
    yTime = random(100) + random(100);

    if (DOODLE) {
        x = int(noise(xTime) * width);
    } else {
        x = 0;
        xStep = 10;
    }

    y = int(noise(yTime) * height);

    timeStepX = 0.004 + 0.002 * random(1);
    timeStepY = 0.004 + 0.002 * random(1);
}

void draw()
{
    if (DOODLE) {
        int newX = int(noise(xTime) * width);
        int newY = int(noise(yTime) * height);
        strokeWeight(max(1, abs(x + y - newX - newY) * 2));
        stroke(127.5 + 127.5 * sin(xTime), 255 * noise(xTime), 255 * noise(yTime));

        //background(0);
        line(x, y, newX, newY);

        x = newX;
        y = newY;
    } else {
        line(x, y, x += xStep * noise(xTime), (y = int(noise(yTime) * height)));

        if (x >= width) {
            x = 0;
            stroke(random(255), random(255), random(255));
        }
    }

    xTime += timeStepX;
    yTime += timeStepY;
}
