PImage img;

void setup() 
{
	size(800, 800);
	img = loadImage("img.jpg");
}

void draw()
{
    background(0);
    //imageMode(CENTER);
	//image(img, 0, 0);
	
	for (int x = 0; x < img.width; x++) {
		for (int y = 0; y < img.height; y++) {
    		if (brightness(img.pixels[x + y * img.width]) > 50) {
    			stroke(255);
    		} else {
        		stroke (0);
        	}
        	//stroke(img.get(x, y));
    		point(x, y);
		}
	}
}
