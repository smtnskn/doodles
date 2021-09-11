float
	t, t2,
	rad,
	ang,
	weight,
	x, y,
	prevX, prevY,
	cx, cy,
	step,
	maxWidth,
	widthConst,
	widthVar,
	radStep;
int
	steps;
boolean
	OUTWARD,
	SILLY_METHOD;

void setup()
{
	size(800, 800, P2D);
	frameRate(60);
	//noSmooth();
	noFill();
	// strokeCap(SQUARE);

	cx = width / 2;
	cy = height / 2;
	t = t2 = 0.0;

	steps = 60;
	step = TAU / steps;
	maxWidth = 18;
	widthConst = maxWidth / 10 * 6;
	widthVar = maxWidth / 10 * 4;
	radStep = maxWidth / steps * 6;

	OUTWARD = true;
	SILLY_METHOD = false;
}

void draw()
{
	background(0);

	translate(cx, cy);
	rotate(t2 * 0.60);
	translate(-cx, -cy);

	int i = 0;
	// int ms = millis();

	// OUTWARD //
	if (OUTWARD) {
		rad = dist(0, 0, cx, cy);
		x = y = prevX = prevY = 0;
		ang = atan2(-cx, -cy);

		if (SILLY_METHOD) {
			while (rad > 1) {  // better to expand from [cx, cy], ばか
				if (i % 8 == 0) {
					prevX = x;
					prevY = y;
				}

				x = cx + sin(ang) * rad;
				y = cy + cos(ang) * rad;

				if (i % 8 == 7) {
					strokeWeight(10 + 7 * (sin(t)));
					// stroke(55 + 200 * sin(t));
					// stroke(127 + 127 * sin(t), 127 + 127 * cos(t), 127 + 127 * sin(t / 2));
					stroke(55 + 200 * sin(t), 55 + 200 * cos(t), 55 + 200 * sin(t / 2));
					line(prevX, prevY, x, y);
				}

				rad -= 0.15;
				ang -= 0.01;
				t += 0.015;

				i++;
			}
		} else {
			while (rad > 1) {
				prevX = x;
				prevY = y;

				x = cx + sin(ang) * rad;
				y = cy + cos(ang) * rad;

				strokeWeight(widthConst + widthVar * (sin(t)));
				// stroke(55 + 200 * sin(t));
				// stroke(127 + 127 * sin(t), 127 + 127 * cos(t), 127 + 127 * sin(t / 2));
				stroke(55 + 200 * sin(t), 55 + 200 * cos(t), 55 + 200 * sin(t / 2));
				line(prevX, prevY, x, y);

				rad -= radStep;
				ang -= step;
				t += 0.125;

				i++;
			}
		}

	// INWARD
	} else {
		rad = 1;
		x = y = prevX = prevY = cx;
		ang = 0;

		if (SILLY_METHOD) {
			while (rad < dist(0, 0, cx, cy)) {
				if (i % 8 == 0) {
					prevX = x;
					prevY = y;
				}

				x = cx + sin(ang) * rad;
				y = cy + cos(ang) * rad;

				if (i % 8 == 7) {
					strokeWeight(10 + 7 * (sin(t)));
					// stroke(55 + 200 * sin(t));
					// stroke(127 + 127 * sin(t), 127 + 127 * cos(t), 127 + 127 * sin(t / 2));
					stroke(55 + 200 * sin(t), 55 + 200 * cos(t), 55 + 200 * sin(t / 2));
					line(prevX, prevY, x, y);
				}

				rad += 0.15;
				ang -= 0.01;
				t += 0.015;

				i++;
			}
		} else {
			while (rad < dist(0, 0, cx, cy)) {
				prevX = x;
				prevY = y;

				x = cx + sin(ang) * rad;
				y = cy + cos(ang) * rad;

				strokeWeight(widthConst + widthVar * (sin(t)));
				// stroke(55 + 200 * sin(t));
				// stroke(127 + 127 * sin(t), 127 + 127 * cos(t), 127 + 127 * sin(t / 2));
				stroke(55 + 200 * sin(t), 55 + 200 * cos(t), 55 + 200 * sin(t / 2));
				line(prevX, prevY, x, y);

				rad += radStep;
				ang -= step;
				t += 0.125;

				i++;
			}
		}
	}

	t = (t2 += 0.25);

	// println(t);
	// println(i);
	// println(millis() - ms);
}