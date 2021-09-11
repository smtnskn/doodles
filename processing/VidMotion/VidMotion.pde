/*
	Group all changed pixels that touch each other:
 		Create 2 groups of groups: groupsFailed and groupsPassed
 
 		Loop through pixels until a changed one that is not in any group is found.
 		Create group, add pixel to it.
 
 		If x + 1 = changed, add to my group. 
 		If x + 1 = !changed, y + 1;
 		Save x.
 		If x + 1 = changed, add to my group.
 		If x + 1 = !changed, go back to saved x.
 		If x - 1 = changed, add to my group. 
 		If x - 1 = !changed, y + 1;
 
 		If group.length < threshold, add to groupsFailed, else add to groupsPassed.
 
 		Remove pixels that are surrounded on all sides from groups in groupsPassed to get an outline.
 */

import processing.video.*;

Capture video;
PImage img;
float t = 0;
int cx, cy, scale;
color[] prevVideo;

boolean init = false;
boolean incrementTimeInFunc = false;
boolean colorA = true;

void setup()
{
    size(1280, 720);
    frameRate(30);
    smooth(0);

    cx = width / 2;
    cy = height / 2;

    //printArray(Capture.list());

    video = new Capture(this, Capture.list()[9]);
    video.start();

    img = new PImage(width, height);
    img.loadPixels();
}

void captureEvent(Capture video) 
{
    if (init) {
        for (int i = 0; i < video.pixels.length; i++) {
            prevVideo[i] = video.pixels[i];
        }
    }

    video.read();

    if (!init) {
        scale = img.width / video.width;
        prevVideo = new int[video.pixels.length];
        init = true;
    }

    //int ms = millis();
    for (int x = 1; x < video.width - 1; x++) {

        if (!incrementTimeInFunc) {
            t += 0.01;
        }

        for (int y = 1; y < video.height - 1; y++) {
            int posVid = x + y * video.width;

            int rgb1 = rgbTotal( video.pixels[posVid] );
            int rgb2 = rgbTotal( prevVideo[posVid] );
            int diff = rgb1 > rgb2 ? rgb1 - rgb2 : rgb2 - rgb1;
            //float diff = abs(brightness(cCur) - brightness(cPrev));

            int threshold = 50;

            color cImg;
            if (threshold == 0) {
                cImg = ((255 << 24) + (diff << 16) + (diff << 8) + diff); 
                //color(diff);
            } else if (diff < threshold) {
                cImg = (255 << 24); 
                //color(0);
            } else {
                //cImg = colorSine(diff / threshold * 255);
                cImg = colorSine();
                //cImg = color(255);
                //cImg = cCur;
            }

            for (int xx = 0; xx < scale; xx++) {
                for (int yy = 0; yy < scale; yy++) {
                    int posImg = ((x * scale + xx) + (y * scale + yy) * img.width);
                    img.pixels[posImg] = cImg;
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

color colorSine() 
{
    if (incrementTimeInFunc) {
        t += 0.01;
    }

    int r, g, b;
    if (colorA) {
        r = (int)(sin(t) * 127.5 + 127.5);
        g = (int)(cos(t) * 127.5 + 127.5);
        b = (int)(-sin(t) * 127.5 + 127.5);
    } else {
        float sine = sin(t);
        r = (int)(sine * 127.5 + 127.5);
        g = (int)(-sine * 127.5 + 127.5);
        b = (int)(cos(sine) * 127.5 + 127.5);
    }

    return ((255 << 24) | (r << 16) | (g << 8) | b);
}

color colorSine(int alpha) 
{
    if (incrementTimeInFunc) {
        t += 0.01;
    }

    int r, g, b;
    if (colorA) {
        r = (int)(sin(t) * 127.5 + 127.5);
        g = (int)(cos(t) * 127.5 + 127.5);
        b = (int)(-sin(t) * 127.5 + 127.5);
    } else {
        float sine = sin(t);
        r = (int)(sine * 127.5 + 127.5);
        g = (int)(-sine * 127.5 + 127.5);
        b = (int)(cos(sine) * 127.5 + 127.5);
    }
    
    return ((alpha << 24) | (r << 16) | (g << 8) | b);
}
