import processing.video.*;

Capture video;
PImage img;
int scale;

void setup()
{
    size(1280, 720, P2D);
    frameRate(30);
    //smooth(2);

    //printArray(Capture.list());

    video = new Capture(this, Capture.list()[9]);
    video.start();
	video.loadPixels();

    img = new PImage(width, height);
    img.loadPixels();
}

void captureEvent(Capture video) 
{
    video.read();
    video.updatePixels();

    scale = img.width / video.width;

    for (int x = 0; x < video.width; x++) {
        for (int y = 0; y < video.height; y++) {
            int posVid = x + y * video.width;
            //int posImg = x * scale + y * scale * img.width;

            for (int xx = 0; xx < scale; xx++) {
                for (int yy = 0; yy < scale; yy++) {
                    int posImg = (x * scale + xx) + (y * scale + yy) * img.width;
                	img.pixels[posImg] = video.pixels[posVid];
                }
            }

            //img.pixels[posImg] = video.pixels[posVid];
        }
    }

    img.updatePixels();
}

void draw()
{
    //int ms = millis();
    
    image(img, 0, 0);
    image(video, 0, 0);
    
    //println(millis() - ms);
}
