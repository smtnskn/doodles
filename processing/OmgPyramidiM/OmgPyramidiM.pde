float t;

void setup()
{
    size(1280, 720, P3D);
    //pixelDensity(displayDensity());
    background(0);
    //stroke(255);
    noStroke();
}

void draw()
{
    background(0);

    pushMatrix();

    translate(width * 0.22, height / 2);
    scale(1.25);
    rotateX(t % TAU);
    //rotateY(sin(t) * PI);
    //rotateZ(sin(t) * PI * 3);

    DrawTheThing(
    	height / 2.75,
    	color(255, 0,   0),
    	color(0,   255, 0),
    	color(0,   0,   255)
    );

    popMatrix();
    pushMatrix();

    translate(width * 0.50, height / 2);
    scale(1);
    //rotateX(sin(t) * PI);
    rotateY(t % TAU);
    //rotateZ(sin(t) * PI * 3);

    DrawTheThing(
        height / 2.75,
        color(255, 0,   0),
        color(0,   255, 0),
        color(0,   0,   255)
    );

    popMatrix();
    pushMatrix();

    translate(width * 0.78, height / 2);
    scale(0.75);
    //rotateX(sin(t) * PI);
    //rotateY(sin(t) * PI);
    rotateZ(sin(t * 3) * PI);

    DrawTheThing(
        height / 2.75,
        color(255, 0,   0),
        color(0,   255, 0),
        color(0,   0,   255)
    );

	popMatrix();

    t += 0.02;

}

void DrawTheThing(float edgeLen, color c1, color c2, color c3)
{
    float halfEdge = edgeLen / 2;
    float sideApo = edgeLen * tan(60);
    float sideH = halfEdge * sqrt(3);

    float h = (edgeLen * sqrt(6)) / 3;

	beginShape(TRIANGLES);

    // Base
    //float r, g, b;

    //r = red(c1) - (red(c1) - red(c2)) / 2;
    //g = green(c1) - (green(c1) - green(c2)) / 2;
    //b = blue(c1) - (blue(c1) - blue(c2)) / 2;
    //fill(r, b, g);
    fill(c1 | c2);
    vertex(-halfEdge, -sideApo, 0);

    //r = red(c1) - (red(c1) - red(c3)) / 2;
    //g = green(c1) - (green(c1) - green(c3)) / 2;
    //b = blue(c1) - (blue(c1) - blue(c3)) / 2;
    //fill(r, g, b);
    fill(c1 | c3);
    vertex(halfEdge, -sideApo, 0);

    //r = red(c2) - (red(c2) - red(c3)) / 2;
    //g = green(c2) - (green(c2) - green(c3)) / 2;
    //b = blue(c2) - (blue(c2) - blue(c3)) / 2;
    //fill(r, g, b);
    fill(c2 | c3);
    vertex(0, -sideApo + sideH, 0);

    // Top
    fill(c1);
    vertex(-halfEdge, -sideApo, 0);
    vertex(halfEdge, -sideApo, 0);
    vertex(0, 0, h);

    // Left
    fill(c2);
    vertex(-halfEdge, -sideApo, 0);
    vertex(0, -sideApo + sideH, 0);
    vertex(0, 0, h);

    // Right
    fill(c3);
    vertex(0, -sideApo + sideH, 0);
    vertex(halfEdge, -sideApo, 0);
    vertex(0, 0, h);

    endShape();
}
