int ms1;
int ms2;

void setup(){
	PImage img = loadImage("img.jpg");
   	int repeat = 10000000;
    
    ms1 = millis();
    for (int r = 0; r < repeat; r++){
    	for (int x = 0; x < img.width; x++){
     		for (int y = 0; y < img.height; y++){
     			int i = x + y * img.width;
       		}
     	}
	}
    ms1 = millis() - ms1;
      
	ms2 = millis();
   	for (int r = 0; r < repeat; r++){
    	for (int i = 0; i < img.width * img.height; i++){
      		int x = i % img.width;
      		int y = (i - x) / img.width;
    	}
	}
	ms2 = millis() - ms2;
      
	println(ms1 + "  " + ms2);
}
