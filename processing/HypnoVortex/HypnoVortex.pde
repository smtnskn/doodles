float t, rad, ang, weight;

void setup()
{
	size(800, 800, P2D);
	frameRate(60);
	//noSmooth();
	noFill();
	// strokeWeight((weight = 10));

	t = 0.0;
}

void draw()
{
	background(0);
	stroke(255);

	rad = width * 0.55;
	float cx = width / 2;
	float cy = cx;
	float x, y, prevX, prevY;
	x = y = 0;
	ang = atan2(-cx, -cy);

	int i = 0;
	while (rad > 1) {
		prevX = x;
		prevY = y;
		x = cx + sin(ang) * rad;
		y = cy + cos(ang) * rad;

		// strokeWeight(10 + 5 * (sin(t / 2)));
		strokeWeight(10 + 5 * (sin(t)));
		stroke(55 + 200 * sin(t), 55 + 200 * cos(t), 55 + 200 * sin(t / 2));
		line(x - (x - prevX), y - (y - prevY), x, y);

		rad -= 0.20;
		ang -= 0.01;

		// t += 0.005;
		t += 0.0025;
		// t += 0.1;

		i++;
	}
	//println(i);
}