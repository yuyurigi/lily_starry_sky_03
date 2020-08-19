// space filling box
class Star {

  int x;
  int y;
  int d, d2;
  color myc, myc2;
  float ro;
  boolean okToDraw;
  boolean chaste = true;
  int shapeRandom, colorRandom, colorAlphaRandom, mnPoints;
  color[] colorData;

  Star() {
    // random initial conditions
    selfinit();
  }

  void selfinit() {
    okToDraw = false;    
    x = int(dimborder+random(width-dimborder*2));
    y = int(dimborder+random(height-dimborder*2));
    d = 0;
    d2 = int(random(20, 50)); //丸のサイズの最大値
    myc = get(x, y);
    myc2 = readBackground(x, y);
    shapeRandom = int(random(4)); //形のランダム値
    colorRandom = int(random(colorArray.length)); //塗り色のランダム値
    colorAlphaRandom = int(random(150, 255)); //透明度のランダム値
    ro = random(TWO_PI);
    mnPoints = 5 + (int)random(1, 5);
  }


  void draw() {
    expand();

    if (okToDraw) {

      if (d>15) { //星のサイズの最小値（１５以下は描かれない）
        if (time < 700) {
          star(x, y, d);
        } else {
          switch(shapeRandom) {
          case 0 :
            if (d<d2) {
              maru(x, y, d);
            }
            break;
          case 1 :
            moon(x, y, d);
            break;
          case 2:
            twinkle(x, y, d, mnPoints);
            break;
          case 3:
            star(x, y, d);
            break;
          }
        }
      }
    }
  }

  void expand() {
    int obstructions = 0;

    //キャラの上に図形を描かないようにする
    int check = 0;

    if (myc2 == color(0, 0, 0)) {
      check += 1;
    }

    if (check == 0) {
      obstructions += 1;
    } else {

      // assume expansion is ok
      d+=2;

      // look for obstructions around perimeter at width d
      //int obstructions = 0;
      colorData = new color[360];
      for (int ang=0; ang<360; ang++) {
        float rad = radians(ang);
        float x2 = int(x + ( (d/2+2) * cos(rad)));
        float y2 = int(y + ( (d/2+2) * sin(rad)));
        colorData[ang] = checkPixel(int(x2), int(y2));
      }

      for (int l=0; l<colorData.length-1; l++) {
        if (colorData[l] != colorData[l+1]) {
          obstructions += 1;
        }
      }
    }

    if (obstructions>0) {
      // reset
      selfinit();    
      if (chaste) {
        makeNewStar();
        chaste = false;
      }
    } else {
      okToDraw = true;
    }
  }

  color checkPixel(int x, int y) {
    color c = get(x, y);
    return c;
  }

  color readBackground(int x, int y) {
    // translate into ba image dimensions
    int ax = int(x * (backImage2.width*1.0)/width);
    int ay = int(y * (backImage2.height*1.0)/height);

    color c = backImage2.pixels[ay*backImage2.width+ax];
    return c;
  }

  void moon(float x, float y, int num) {
    float size = float(num)*0.8;

    pushMatrix();
    translate(x, y);
    rotate(ro);
    fill(myc);
    noStroke();
    ellipse(0, 0, num, num);
    noStroke();
    fill(colorArray[colorRandom], colorAlphaRandom);
    scale(.01*size);
    shape(moonSvg, 0, 0);
    popMatrix();
  }

  void star(int x, int y, int radius) {
    float size = float(radius)*0.9;
    pushMatrix();
    translate(x, y);
    rotate(ro);
    fill(myc);
    noStroke();
    ellipse(0, 0, radius, radius);

    fill(colorArray[colorRandom], colorAlphaRandom);
    noStroke();
    scale(.01*size);
    shape(starSvg, 0, 0);

    popMatrix();
  }

  void twinkle(int x, int y, int rad, int nPoints) {
    pushMatrix();
    translate(x, y);
    rotate(ro);
    float angle = TWO_PI / nPoints;
    float angle2 = angle / 2;
    float origAngle = 0.0;
    float rad1 = rad/2*0.95;
    float rad2 = rad1/4;
    beginShape();
    fill(myc);
    noStroke();
    ellipse(0, 0, rad, rad);

    fill(colorArray[colorRandom], colorAlphaRandom);
    stroke(colorArray[colorRandom], colorAlphaRandom);
    strokeWeight(1);
    strokeJoin(ROUND);
    for (int i = 0; i < nPoints; i++)
    {
      float y1 = rad1 * sin(origAngle);
      float x1 = rad1 * cos(origAngle);
      float y2 = rad2 * sin(origAngle + angle2);
      float x2 = rad2 * cos(origAngle + angle2);
      vertex(x1, y1);
      vertex(x2, y2);
      origAngle += angle;
    }
    endShape(CLOSE);
    popMatrix();
  }

  void maru(int x, int y, int rad) {
    fill(myc);
    noStroke();
    ellipse(x, y, rad, rad);

    fill(colorArray[colorRandom], colorAlphaRandom);
    noStroke();
    ellipse(x, y, rad*0.5, rad*0.5);
  }
}
