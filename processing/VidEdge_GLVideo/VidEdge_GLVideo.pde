/*
 Make temporal, only count values that have been above threshold for more than 1 frames
*/

//import processing.video.*;
import gohai.glvideo.*;

//Capture video;
GLCapture video;
PImage img;
int scale;
float t = 0;
int cx, cy;

void setup()
{
    size(1280, 720, P2D);
    frameRate(30);
    //smooth(2);

    cx = width / 2;
    cy = height / 2;

    //printArray(Capture.list());

    //video = new Capture(this, Capture.list()[6]);
    video = new GLCapture(this);
    video.start();

    img = new PImage(width, height);
    img.loadPixels();
}

//void captureEvent(Capture video) 
void captureEvent(GLCapture video)
{
    video.read();

    scale = img.width / video.width;
    //scale = sin(t += 0.04) * (scale / 2) + scale / 2;

    //int ms = millis();
    color c;
    float[] br = new float[10];
    for (int x = 1; x < video.width - 1; x++) {
        for (int y = 1; y < video.height - 1; y++) {
            int posVid = x + y * video.width;

            br[0] = brightness(video.pixels[posVid]);
            br[1] = abs(br[0] - brightness(video.pixels[posVid - 1]));
            br[2] = abs(br[0] - brightness(video.pixels[posVid + 1]));
            br[3] = abs(br[0] - brightness(video.pixels[max(0, min(video.pixels.length - 1, posVid + video.width))]));
            br[4] = abs(br[0] - brightness(video.pixels[max(0, min(video.pixels.length - 1, posVid - video.width))]));
            //br[5] = abs(br[0] - brightness(video.pixels[max(0, min(video.pixels.length - 1, posVid - 1 + video.width))]));
            //br[6] = abs(br[0] - brightness(video.pixels[max(0, min(video.pixels.length - 1, posVid - 1 - video.width))]));
            //br[7] = abs(br[0] - brightness(video.pixels[max(0, min(video.pixels.length - 1, posVid + 1 + video.width))]));
            //br[8] = abs(br[0] - brightness(video.pixels[max(0, min(video.pixels.length - 1, posVid + 1 - video.width))]));

            //br[9] = br[3];
            //br[9] = (br[1] + br[2] + br[3] + br[4]) / 4;
            //br[9] = (br[1] + br[2] + br[3] + br[4] + br[5] + br[6] + br[7] + br[8]) / 8;
            br[9] = br[1];
            for (int i = 2; i < 5; i++) {
                if (br[i] > br[9]) {
                    br[9] = br[i];
                }
            }
            int threshold = 15;

            if (threshold == 0) {
                c = color(br[9] * 1.5);
            } else if (br[9] < threshold) {
                c = color(255);
            } else {
                c = color(0);
            }

            for (int xx = 0; xx < scale; xx++) {
                for (int yy = 0; yy < scale; yy++) {
                    int posImg = ((x * scale + xx) + (y * scale + yy) * img.width);
                    img.pixels[posImg] = c;
                }
            }
        }
    }
    //ms = millis() - ms;

    //println(ms);

    //for (int i = 0; i < img.pixels.length - 1; i++) {
    //       int n = max(0, min(img.pixels.length - 1, (i + (int)random(-8, 8))));
    //       color c = img.pixels[n];
    //       img.pixels[i] = img.pixels[n];
    //       img.pixels[n] = c;
    //}

    img.updatePixels();
}

void draw()
{
    //int ms = millis();

    //imageMode(CENTER);   
    //image(img, cx, cy);
    if (video.available()) {
        video.read();
    }
    imageMode(CORNER);
    image(video, 0, 0);

    //println(millis() - ms);
}
