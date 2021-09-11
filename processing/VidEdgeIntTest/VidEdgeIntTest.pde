/*
 Make temporal, only count values that have been above threshold for more than 1 frames
 */

import processing.video.*;

Capture video;
PImage img;

float t = 0;
int cx, cy;
int vpLen, vW, vH;
int scale;
boolean init = false;

void setup()
{
    size(1280, 720);
    frameRate(30);
    smooth(0);

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

    if (!init) {
        scale = img.width / video.width;
        vpLen = video.pixels.length;
        vW = video.width;
        vH = video.height;
        
        init = true;
    }

    //int ms = millis();
    color c;
    int[] br = new int[10];
    for (int x = 1; x < vW - 1; x++) {
        for (int y = 1; y < vH - 1; y++) {
            int posVid = x + y * vW;

            br[0] = rgbTotal(video.pixels[posVid]);
            br[1] = abs(br[0] - rgbTotal( video.pixels[posVid - 1]) );
            br[2] = abs(br[0] - rgbTotal( video.pixels[posVid + 1]) );
            br[3] = abs(br[0] - rgbTotal( video.pixels[max(0, min(vpLen - 1, posVid + vW))] ));
            br[4] = abs(br[0] - rgbTotal( video.pixels[max(0, min(vpLen - 1, posVid - vW))] ));
            //br[5] = abs(br[0] - rgbTotal( video.pixels[max(0, min(vpLen - 1, posVid - 1 + vW))] ));
            //br[6] = abs(br[0] - rgbTotal( video.pixels[max(0, min(vpLen - 1, posVid - 1 - vW))] ));
            //br[7] = abs(br[0] - rgbTotal( video.pixels[max(0, min(vpLen - 1, posVid + 1 + vW))] ));
            //br[8] = abs(br[0] - rgbTotal( video.pixels[max(0, min(vpLen - 1, posVid + 1 - vW))] ));

            //br[9] = br[1];
            //br[9] = (br[1] + br[2] + br[3] + br[4]) / 4;
            //br[9] = (br[1] + br[2] + br[3] + br[4] + br[5] + br[6] + br[7] + br[8]) / 8;
            
            br[9] = br[1];
            for (int i = 2; i < 5; i++) {
                if (br[i] > br[9]) {
                    br[9] = br[i];
                }
            }
            //for (int i = 2; i < 9; i++) {
            //    if (br[i] > br[9]) {
            //        br[9] = br[i];
            //    }
            //}
            
            int threshold = 35;

            if (threshold == 0) {
                c = ((255 << 24) + (br[9] << 16) + (br[9] << 8) + br[9]); 
                //color(br[9]);
            } else if (br[9] < threshold) {
                c = ((255 << 24) + (255 << 16) + (255 << 8) + 255);
                //c = color(255);
            } else {
                c = (255 << 24);
                //c = color(0);
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

    img.updatePixels();
}

void draw()
{
    //int ms = millis();

    imageMode(CENTER);   
    image(img, cx, cy);
    //imageMode(CORNER);
    //image(video, 0, 0);

    //println(millis() - ms);
}

int rgbTotal(color c) 
{
    return (((c >> 16) & 0xFF) + ((c >> 8) & 0xFF) + (c & 0xFF));
}
