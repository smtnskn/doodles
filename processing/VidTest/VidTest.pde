import processing.video.*;

Capture src;
int w;
int h;
boolean shotTaken = false;
int shotCount = 0;

int batchSize = 1000;
int[][] iArr;
int count = 0;

void setup() 
{    
    frameRate(60);
    size(1280, 720, P2D);

    //printArray(Capture.list());

    src = new Capture(this, 1280, 720);
    w = src.width;
    h = src.height;
    src.start();

    iArr = new int[src.pixels.length / batchSize][batchSize];
    for (int i = 0; i < iArr.length; i++) {
        for (int j = 0; j < batchSize; j++) {
            iArr[i][j] = i * batchSize + j;
        }
    }
    for (int i = 0; i < iArr.length; i++) {
        for (int j = 0; j < batchSize; j++) {
            int temp = iArr[i][j];
            int r1 = (int)random(iArr.length);
            int r2 = (int)random(batchSize);
            iArr[i][j] = iArr[r1][r2];
            iArr[r1][r2] = temp;
        }
    }
}

void draw()
{
    if (!shotTaken) {
        if (src.available()) {
            //src.loadPixels();
            src.read();
            //src.updatePixels();
            shotCount++;
            
            if (shotCount > 5) {
            	shotTaken = true;
            	src.stop();
            }
        }
    } else if (count < iArr.length) {
        for (int i = 0; i < iArr[count].length; i++) {
            int x = iArr[count][i] % w;
            int y = (iArr[count][i] - x) / w;

            stroke(src.get(x, y));
            point(x, y);
        }

        count++;
    }
}
