boolean drawn;

void setup()
{
    size(1280, 640, P2D);
    background(0);
    stroke(255);

    drawn = false;
}

void draw()
{
    if (!drawn) {
        branch(width / 2, height, height / 2);

        drawn = true;
    }
}


void branch(float x, float y, float h)
{
    if (h > 1) {
        line(x, y, x - 2 * h, 0);
        line(x, y, x + 2 * h, 0);
        
        branch(x - h, y - h, h / 2);
        branch(x + h, y - h, h / 2);
    }
}
