String s;
PFont f;

void setup()
{
    size(600, 400, P2D);
    smooth(2);
    background(0);

    s = "To be, or not to be...";
    f = createFont("Georgia", 48);
    
    textFont(f);
    textSize(48);
}

void draw()
{  
    textAlign(CENTER, TOP);
    text(s, width * 0.50, height * 0.25);

	textAlign(CENTER, BOTTOM);
    text(s, width * 0.50, height * 0.75);
}
