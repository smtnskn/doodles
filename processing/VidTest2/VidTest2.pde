import processing.video.*;

Capture video;
PImage img;
int scale;
float t = 0;
int cx, cy;

void setup()
{
    size(1280, 720);
    frameRate(30);
    //smooth(2);
    
    cx = width / 2;
    cy = height / 2;

    //printArray(Capture.list());

    video = new Capture(this, Capture.list()[6]);
    video.start();

    img = new PImage(width, height);
    img.loadPixels();
}

void captureEvent(Capture video) 
{
    video.read();

    scale = img.width / video.width;
    //scale = sin(t += 0.04) * (scale / 2) + scale / 2;

    //int ms1 = millis();
    //for (int i = 0; i < img.pixels.length; i++) {
    //    int x = i % img.width;
    //    int y = (i - x) / width;
    //    img.pixels[i] = video.get(x / scale, y / scale);
    //}
    //ms1 = millis() - ms1;

    //int ms2 = millis();
    //for (int x = 0; x < img.width; x++) {
    //    for (int y = 0; y < img.height; y++) {
    //    	img.pixels[x + y * img.width] = video.get(x / scale, y / scale);
    //    }
    //}
    //ms2 = millis() - ms2;
    
    //int ms3 = millis();
    //for (int x = 0; x < img.width; x++) {
    //    int vx = (x / scale);
    //    for (int y = 0; y < img.height; y++) {
    //          int vy = (y / scale);              
    //          img.pixels[x + y * img.width] = video.pixels[vx + vy * video.width];
    //    }
    //}
    //ms3 = millis() - ms3;

    //int ms4 = millis();
    int posVid = 0;
    for (int x = 0; x < video.width; x++) {
        for (int y = 0; y < video.height; y++) {
            //if (y % 4 == 0) {
            	posVid = x + y * video.width;
            //}
            //int posImg = (x * scale + y * scale * img.width);
			
            for (int xx = 0; xx < scale; xx++) {
                for (int yy = 0; yy < scale; yy++) {
                    int posImg = ((x * scale + xx) + (y * scale + yy) * img.width);
                    img.pixels[posImg] = video.pixels[posVid];
                }
            }

            //img.pixels[posImg] = video.pixels[posVid];
        }
    }
    //ms4 = millis() - ms4;

    //println(ms1 + "  " + ms2 + "  " + ms3 + "  " + ms4);
	//println(ms3 + "  " + ms4);

	//for (int i = 0; i < img.pixels.length - 1; i++) {
 //   	int n = max(0, min(img.pixels.length - 1, (i + (int)random(-8, 8))));
 //   	color c = img.pixels[n];
 //   	img.pixels[i] = img.pixels[n];
 //   	img.pixels[n] = c;
	//}

    img.updatePixels();
}

void draw()
{
    //int ms = millis();
 
 	imageMode(CENTER);   
    image(img, cx, cy);
    imageMode(CORNER);
    image(video, 0, 0);
    
    //println(millis() - ms);
}
