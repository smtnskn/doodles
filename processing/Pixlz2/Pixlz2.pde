void setup() {
    size(800, 800);
    noSmooth();

    loadPixels();
}
void draw() {
    int cx = width / 2;
    int cy = height / 2;
    for (int x = 0; x < width; x++) {
        for (int y = 0; y < height; y++) {
            int c = int((255.0 / width) * sqrt((x - cx) * (x - cx) + (y - cy) * (y - cy)));
            pixels[x + y * width] = ((255 << 24) | (c << 16) | (c << 8) | c);
        }
    }
    
    updatePixels();
}
