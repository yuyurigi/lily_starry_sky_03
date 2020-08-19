import java.util.Calendar;

int num = 0;
int maxnum = 2000;
int dimborder = 20; //縁の太さ
int time = 0;

Star[] stars;

  color[] colorArray = { //color( 251, 203, 110 ), //黄色寄りオレンジ
                         color( 246, 172, 110 ), //オレンジ
                         color( 250, 210, 219 ), //ピンク
                         //color( 242, 188, 215 ), //ピンク
                         color( 170, 216, 199 ), 
                         color( 0, 149, 168 ),
                         color( 229, 228, 96 ), 
                         color( 248, 240, 157 ),
                         color( 247, 248, 246 ), 
                       color( 9, 94, 129)};

PShape moonSvg; //月のsvg画像
PShape starSvg; //星のsvg画像

// background image
PImage backImage;
PImage backImage2;

color backColor = color(53, 68, 89); //背景色
color borderColor = color(243, 243, 243); //縁の色
// MAIN -----------------------------------------------------------

void setup() {
  size(800, 800);
  frameRate(30);

  // create stars
  stars = new Star[maxnum];

  moonSvg = loadShape("moon.svg");
  starSvg = loadShape("star.svg");
  moonSvg.disableStyle();
  starSvg.disableStyle();
  shapeMode(CENTER);
  backImage = loadImage("lily.png");
  backImage2 = loadImage("lily2.png");

  resetAll();
}

void draw() {
  for (int n=0; n<num; n++) {
    stars[n].draw();
  }

  if (time == 700) {
    makeNewStar();
    makeNewStar();
    makeNewStar();
    makeNewStar();
  }

  time++;

  if (time == 3000) {
    saveFrame(timestamp()+"_####.png");
    resetAll();
  }
}

void mousePressed() {
  resetAll();
}

void resetAll() {      
  // stop drawing
  num=0;
  time = 0;

  background(backColor);
  image(backImage, 0, 0); //リリィ
  drawWhiteBorder();

  makeNewStar();
}


void makeNewStar() {

  if (time < 700) { 
    if (num<1) {
      stars[num] = new Star();
      num++;
    }
  } else {
    if (num<2) {
      stars[num] = new Star();
      num++;
    }
  }
}

void drawWhiteBorder() {
  fill(borderColor);
  noStroke();
  rect(0, 0, width, dimborder); //縁
  rect(0, 0, dimborder, height); //縁
  rect(0, height-dimborder, width, dimborder); //縁
  rect(width-dimborder, 0, dimborder, height); //縁
}

void keyReleased() {
  if (key == 's' || key == 'S')saveFrame(timestamp()+"_####.png");
}


String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
