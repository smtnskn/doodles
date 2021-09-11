int cx, cy;
float x, y;
float x2, y2;
int rad, rad2;

float time, time2;
float timeStep, timeStep2;

float theta, theta2;
float delta, delta2;
float unsync;

PGraphics pg;

void setup()
{
    size(1280, 720, P2D);
    frameRate(60);
	background(0);

    pg = createGraphics(width, height);

    cx = width / 2;
    cy = height / 2;

    rad = width / 8;
    rad2 = rad;

    theta = random(TAU);
    theta2 = random(TAU);
    delta = 0.01;
    delta2 = 4 * delta;
    unsync = 1; //1.1;

    x = cx + rad * sin(theta);
    y = cy + rad * cos(theta);

    x2 = x + rad2 * sin(theta2);
    y2 = y + rad2 * cos(theta2);
}

void draw()
{
    theta = (theta + delta) % TAU;
    theta2 = (theta2 + delta2 * unsync) % TAU;

    pg.beginDraw();

    pg.background(0, 35);
    pg.noStroke();
    pg.fill(0, 0, 255);
    pg.ellipse(x, y, 3, 3);

    pg.stroke(255);
    pg.strokeWeight(height / 125);
    pg.noFill();
    pg.line(x2, y2,
        (x2 = (x = cx + rad * sin(theta)) + rad2 * sin(theta2)),
        (y2 = (y = cy + rad * cos(theta)) + rad2 * cos(theta2)));

    pg.endDraw();

    image(pg, 0, 0);
}
