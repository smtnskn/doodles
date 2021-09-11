float t, dir;
int x, y;

void setup()
{
    size(1280, 720, P2D);
    
    x = int(width * random(1));
    y = int(height * random(1));
    dir = random(1) * TAU; 
    
    t = 0;
}

void draw()
{
    background(0);
    
    float r = random(-1, 1);
    dir += (r * PI / 15);
    dir = dir % TAU;
    
    float wingDir = dir + PI / 2;
    
    int step = 5; //int(10 - 10 * abs(r));
    
    x += step * sin(dir);
    y += step * cos(dir);
    
    x = min(width, max(0, x));
    y = min(height, max(0, y));
    
    fill(255);
    noStroke();
    
    int rad = 20;
    ellipse(x, y, rad, rad);
    
    stroke(255);
    strokeWeight(2);
    line(x + 30 * sin(wingDir), y + 30 * cos(wingDir), x + 30 * sin(wingDir - PI), y + 30 * cos(wingDir - PI));
    line(x, y, x + 30 * sin(dir), y + 30 * cos(dir));
}
