PImage src;
PImage img;
int w;
int h;
int hw;
int hh;
float r;

void setup() 
{
    imageMode(CENTER);
    frameRate(90);
    size(900, 800, P2D);
    src = loadImage("img.jpg");
    img = new PImage(src.width, src.height);
    w = img.width;
    h = img.height;
    hw = w / 2;
    hh = h / 2;
    r = (h > w ? h : w) / 3;
}

void draw()
{
    background(255);
	   
    src.loadPixels();
    img.loadPixels();
    
    for (int i = 0; i < img.pixels.length; i++) {
        int x = i % w;
        int y = (i - x) / w;
        
        float d = dist(x, y, mouseX, mouseY);
        //float br = (d > r ? 0 : (r - d) / r);
        float br = (d > r ? 0 : (r - d) / r * 1.25);
        //float br = map(d, 0, r, 1.25, 0);
        
        float r = red(src.pixels[i]) * br;
        float g = green(src.pixels[i]) * br;
        float b = blue(src.pixels[i]) * br;
    
     	img.pixels[i] = color(r, g, b);
    }
    
    img.updatePixels();
	image(img, width / 2, height / 2);
}
