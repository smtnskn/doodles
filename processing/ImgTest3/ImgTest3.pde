PImage src;
int w;
int h;

int batchSize = 500;
int[][] iArr;
int count = 0;

void setup() 
{    
    frameRate(60);
    size(800, 800, P2D);
    src = loadImage("img.jpg");
    w = src.width;
    h = src.height;

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
    if (count < iArr.length) {
        for (int i = 0; i < iArr[count].length; i++) {
            int x = iArr[count][i] % w;
            int y = (iArr[count][i] - x) / w;
    
            stroke(src.get(x, y));
            point(x, y);
        }

        count++;
    }
}
