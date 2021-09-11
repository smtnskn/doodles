//int ms1;
//int ms2;
//int repeat = 1;
float t = 0;

void setup() {
    loadPixels();
    size(600, 600, P2D);
    frameRate(24);
    
    /*
    ms1 = millis();
    for (int r = 0; r < repeat; r++) {
    	for (int x = 0; x < width; x++) {
     		for (int y = 0; y < height; y++) {
         		color c = color(sin(x) * 127.5 + 127.5, 
         						sin(y) * 127.5 + 127.5,
         						sin(x * y) * 127.5 + 127.5);
     			pixels[x + y * width] = c;
       		}
     	}
	}
    ms1 = millis() - ms1;
      
	ms2 = millis();
   	for (int r = 0; r < repeat; r++) {
    
    	for (int i = 0; i < pixels.length; i++) {
      		int x = i % width;
      		int y = (i - x) / width;
      
      		int n = 1000;
      		color c = color(sin(i / n) * 127.5 + 127.5, 
                            -sin(i / n) * 127.5 + 127.5,
                            cos(i / n) * 127.5 + 127.5);
			pixels[i] = c;
    	}
	}
	ms2 = millis() - ms2;

	updatePixels();
      
	println(ms1 + "  " + ms2);
	*/
}

void draw() {
	for (int i = 0; i < pixels.length; i++) {
    	if (i % 10 == 0) {
        	float n = i / t;
            color c = color(sin(n) * 127.5 + 127.5, 
                            -sin(n) * 127.5 + 127.5,
                            cos(n) * 127.5 + 127.5);
            pixels[i] = c;
    	} else {
        	pixels[i] = pixels[i - 1];
    	}
    
    //    int x = i % width;
    //    int y = (i - x) / width;
    //    color c = color(x / 2, y / 2, sin(t) * 127.5 + 127.5);	
    //    pixels[i] = c;
    }
    
    //t += 0.02;
    t += 0.000001;
    
    updatePixels();
}
