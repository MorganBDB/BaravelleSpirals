// Morgan Brooke-deBock
// May 9 2023
// Program to generate Baravelle spirals

ArrayList<PVector[]> shapes = new ArrayList<PVector[]>();

void setup() {
  size(1024, 1024);
  background(255);
  shapes.add(generateNgon(5, 0, 0, 0));
}

void draw() {

  if (shapes.size() <= 50) {
    PVector[] newShape = getNextShape(shapes.get(shapes.size() - 1));
    shapes.add(newShape);
  }

  for (int i = 0; i < shapes.size() - 1; i++) {
    drawShape(shapes.get(i));
    //drawAllSpirals(shapes.get(i), shapes.get(i+1));
    //drawAlternationSpirals(shapes.get(i), shapes.get(i+1));
    drawSpiral(shapes.get(i), shapes.get(i+1));
  }
}


PVector[] getNextShape(PVector[] verts) {
  /*
    This function takes as input an array of PVectors. The PVectors correspond to the vertices of a polygon.
    The functions takes this polygon and calculates the vertex coordinates of a new polygon nested inside the original.
    
    The vertices of the new polygon are located at the midpoints of the sides of the original polygon.
    
    The function saves all of these new vertices as an array and returns them in an array.
  */
  
  PVector[] newVerts = new PVector[verts.length];

  // Calculate the first n-1 vertices of the new shape
  for (int i = 0; i < (verts.length - 1); i++) {
    float x1 = verts[i].x;
    float y1 = verts[i].y;
    float x2 = verts[i+1].x;
    float y2 = verts[i+1].y;

    float newX = (x1 + x2) / 2;
    float newY = (y1 + y2) / 2;
    newVerts[i] = new PVector(newX, newY);
  }

  // Calculate the final vertex of the new shape
  float lastX = verts[verts.length - 1].x;
  float lastY = verts[verts.length - 1].y;
  float firstX = verts[0].x;
  float firstY = verts[0].y;

  float finalX = (firstX + lastX) / 2;
  float finalY = (firstY + lastY) / 2;

  newVerts[newVerts.length - 1] = new PVector(finalX, finalY);

  return newVerts;
}

void drawShape(PVector[] verts) {
  /*
    Function takes as input an array of PVectors and uses them to draw a polygon to the screen.
    Each PVector stores the coordinates of one of the vertices of the polygon.
  */
  noFill();
  stroke(0);
  strokeWeight(0.1);

  beginShape();
  for (int i = 0; i < verts.length; i++) {
    vertex(verts[i].x, verts[i].y);
  }

  endShape(CLOSE);
}

void drawSpiral(PVector[] s1, PVector[] s2) {
  /*
  This functions draws one segment of the Baravelle spiral.
  It takes as input two polygons that are nested in sequence. S1 is the outer polygon and S2 is the inner polygon.
  The function connects two adjacent vertice of S2 and the middle vertex of S1 to form a triangle. This triangle is
  one segment of the baravelle spiral.
  */
  colorMode(RGB);
  noStroke();
  fill(255, 0, 0);
  beginShape();
  vertex(s1[0].x, s1[0].y);
  vertex(s2[0].x, s2[0].y);
  vertex(s2[s2.length - 1].x, s2[s2.length - 1].y);
  endShape();
}

void drawAllSpirals(PVector[] s1, PVector[] s2) {
  /*
  This functions draws all segments of a single layer of the Baravelle spiral.
  It takes as input two polygons that are nested in sequence. S1 is the outer polygon and S2 is the inner polygon.
  The function connects two adjacent vertice of S2 and the middle vertex of S1 to form a triangle. This triangle is
  one segment of the baravelle spiral.
  */
  colorMode(HSB, 360, 100, 100);
  noStroke();
  for (int i = 1; i < s1.length; i++) {
    float c = map(i, 1, s1.length, 0, 360);
    fill(c, 100, 100);
    beginShape();
    vertex(s1[i].x, s1[i].y);
    vertex(s2[i].x, s2[i].y);
    vertex(s2[i-1].x, s2[i-1].y);
    endShape();

    float finalC = map(s1.length, 0, s1.length, 0, 360);
    fill(0, 0, 0);
    beginShape();
    vertex(s1[0].x, s1[0].y);
    vertex(s2[0].x, s2[0].y);
    vertex(s2[s2.length - 1].x, s2[s2.length - 1].y);
    endShape();
  }
}

void drawAlternationSpirals(PVector[] s1, PVector[] s2) {
  colorMode(RGB);
  noStroke();
  for (int i = 1; i < s1.length; i++) {
    if (i % 2 == 0) {
      fill(255);
    } else {
      fill(0);
    }
    beginShape();
    vertex(s1[i].x, s1[i].y);
    vertex(s2[i].x, s2[i].y);
    vertex(s2[i-1].x, s2[i-1].y);
    endShape();

    if (s1.length % 2 == 0) {
      fill(255);
    } else {
      fill(0);
    }
    beginShape();
    vertex(s1[0].x, s1[0].y);
    vertex(s2[0].x, s2[0].y);
    vertex(s2[s2.length - 1].x, s2[s2.length - 1].y);
    endShape();
  }
}


PVector[] generateNgon(int n, float InitialAngle, float Xoff, float Yoff) {
  // Function to return an array of AttractorPoint objects arrange in a regular ngon

  float R = height/2 - (height * 0.05); // Set the radius to be 95% the height of the canvas
  float midx = width/2 + Xoff;          // place the center point of shape at the center of the canvas
  float midy = height/2 + Yoff;
  float angle_increment = TWO_PI/n;
  PVector[] points = new PVector[n];

  for (int i = 0; i < n; i++) {
    float x = midx + (R * cos(InitialAngle + (angle_increment * i)));
    float y = midy + (R * sin(InitialAngle + (angle_increment * i)));
    PVector point = new PVector(x, y);
    points[i] = point;
  }

  return points;
}
