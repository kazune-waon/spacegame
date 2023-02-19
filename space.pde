class Player { 
float x, y, speed;
int shield;
boolean invincibleStatus; 
float invincibleStartTime;

Player() { 
resetSpaceship();
}

void resetSpaceship() { 
x = 50; 
y = height / 2; 
speed = 10;
shield = 10; 
invincibleStatus = false; 
}
// 宇宙船
void drawSpaceship() { 
// 宇宙船を描く
pushMatrix();
translate(x, y);
stroke(0);
if ( invincibleStatus == true ) { 
fill(80, 80, 255);
} else {
fill(200);

}
triangle(0, 0, 60, 20, 3, 20);
fill(50);
rect(0, 10, 20, 6);
popMatrix(); 

for ( int i = 0; i < shield; i++ ) {
fill(100, 255, 100);
rect(width / 2 + 12 * i, 10, 10, 20);
}
}

void updateSpaceship() {
if (up == true && y-speed > 0 ) y -= speed;
if (down == true && y+speed + 20 < height) y += speed;
if (left == true && x-speed > 0 ) x -= speed;
if (right == true && x+speed + 60 < width ) x += speed;
if ( invincibleStatus == true
&& invincibleStartTime + invincibleTime < millis() ) { 

invincibleStatus = false; 
}
}

boolean hit(float tx, float ty, float tSize) {
float r = tSize / 3.5; // 当たり判定
if (x < tx + r && tx - r < x + 60 &&
y < ty + r && ty - r < y + 20) {
if ( invincibleStatus == false ) {

shield--;
if (shield < 0) status = 4;
}

return true;
} else {
return false;
}
}
// ----- 宇宙船にアイテムに接触したかどうかの判定 <item>
boolean contact(float tx, float ty, float tSize) {
float r = tSize / 3.5; 
if (x < tx + r && tx - r < x + 60 &&
y < ty + r && ty - r < y + 20) {
return true;
} else {
return false;
}
}
}

void keyPressed() {
if (key == CODED) {
if (keyCode == UP ) up = true;
if (keyCode == DOWN ) down = true;
if (keyCode == LEFT ) left = true;
if (keyCode == RIGHT ) right = true;
}
}

void keyReleased() {
if (key == CODED) {
if (keyCode == UP ) up = false;
if (keyCode == DOWN ) down = false;
if (keyCode == LEFT ) left = false;
if (keyCode == RIGHT ) right = false;
}

}

class Meteorite {
float x, y, speed, size; 
boolean crashed;


Meteorite() {
resetMeteorite();
}

void resetMeteorite() {
x = random(width, 2 * width); 
y = random(height); 
speed = random(2, 20); 
size = random(10, 30); 
crashed = false; 
}

void drawMeteorite() { 
stroke(0);
fill(255, 121, 91);
ellipse(x, y, size, size);
if ( crashed == true ) {
noStroke();
fill(255, 255, 0, 100);
ellipse(x+random(-20, 20), y+random(-20, 20), size, size);
ellipse(x+random(-20, 20), y+random(-20, 20), size, size);
}
}


void updateMeteorite() {
x -= speed; 
if ( x < -size ) resetMeteorite(); 

if ( crashed == false ) { 
crashed = player.hit(x, y, size); 
} else { 
if ( size > 0 ) { 
size -= 4; 
} else {
resetMeteorite();
}
}
}
}

class Item {
float x, y, speed, size=10; 
int colorR, colorG, colorB; 
boolean contacted; 
boolean appeared;
int counterToErase; 

Item() {
resetItem();
}

void resetItem() {

x = random(width, 2 * width);

y = random(height); 
speed = random(2, 20); 
contacted = false;
appeared = false; 

counterToErase = 5;

}

void drawItem() {
if ( contacted == false ) {
stroke(0);
fill(colorR, colorG, colorB); 

ellipse(x, y, size, size); 
} else { 
noStroke();
fill(0, 255, 255, 100);
ellipse(x, y, 6 * (5-counterToErase), 6 * (5-counterToErase));
}
}

void getItem() {
//何もしない
}

boolean updateItem() { 
x -= speed; 
if ( x < -size ) {
resetItem();
return false; 
}
if ( contacted == false ) { 
contacted = player.contact(x, y, size);
if ( contacted == true ) {
getItem();
}
return true; 
} else {
if ( counterToErase > 0 ) { 
counterToErase--;
return true; 
} else { 
resetItem(); 
return false;
}
}
}
}
//回復
class Item_1 extends Item {
Item_1() { 
super.colorR = 93;
super.colorG = 255;
super.colorB = 160;
}

// --- アイテムの取得(接触した際の処理)
@Override
void getItem() {
player.shield++; 
}
}

//無敵
class Item_2 extends Item {
Item_2() { 
super.colorR = 78;
super.colorG = 210;
super.colorB = 255;
}

@Override
void getItem() {
player.invincibleStatus = true; 
player.invincibleStartTime = millis(); 
}
}
// 全消滅
class Item_3 extends Item {
Item_3() { 
super.colorR = 255;
super.colorG = 105;
super.colorB = 197;
}

@Override
void getItem() {
background(255, 100, 100); 
for (int i = 0; i <mMax; i++ ) meteor[i].resetMeteorite(); 
}
}

class Back {
float[] x, y, speed;
int sN;

Back() {
sN = 100; 
x = new float[sN]; 
y = new float[sN];
speed = new float[sN];
for (int i = 0; i < sN; i++ ) {
x[i] = random( width );
y[i] = random( height );
speed[i] = random(1);
}
}

void drawStars() { 
background(170, 132, 232); 
noStroke();
fill(255);
for ( int i = 0; i < sN; i++ ) {
ellipse( x[i], y[i], 2, 2 );
}
}


void updateStars() {
for (int i=0; i < sN; i++ ) {
x[i] -= speed[i];
if ( x[i] < -2 ) x[i] += width;
}
}
}
//////
boolean up, down, left, right; 
Back back; 
Player player;
Meteorite[] meteor; 
int mMax = 50;
int mN = 0; 
Item[] items; 
int iMax = 3;

float r; 

int status = 1;

float travelTime = 60000; 
float startTime;
float invincibleTime = 5000; 

void setup() {
size(600, 300); 

frameRate(15); 
noCursor(); 
player = new Player();
meteor = new Meteorite[mMax];

for (int i = 0; i < mMax; i++) {
meteor[i] = new Meteorite(); 
}
items = new Item[iMax];
back = new Back(); 
}

void draw() {
if ( status == 1 ) opening();
else if ( status == 2 ) gamePlay(); 
else if ( status == 3 ) gameClear(); 
else if ( status == 4 ) gameOver(); 
}

void pressSpaceKey() {
if ( keyPressed == true && key == ' ' ) {
player.resetSpaceship();

for (int i = 0; i <mMax; i++ ) meteor[i].resetMeteorite();

for (int i = 0; i <iMax; i++ ) items[i] = null; 
startTime = millis();
status = 2; 
}
}

void opening() {
back.updateStars(); 
back.drawStars(); 
player.updateSpaceship(); 
player.drawSpaceship();


fill(255, 255, 0);
textSize(30);
textAlign(CENTER, CENTER);
text( "SPACE TRAVELER", width/2, height/2 );
text( "PRESS SPACE KEY TO START", width/2, height/2+50 );
pressSpaceKey(); 
}

void gamePlay() {
back.updateStars();
back.drawStars(); 
player.updateSpaceship(); 
player.drawSpaceship();
for (int i = 0; i < mN; i++ ) { 
meteor[i].updateMeteorite();
meteor[i].drawMeteorite();
}
// アイテムに関する処理
for (int i = 0; i < iMax; i++ ) { 

if ( items[i] != null ) {

if ( items[i].updateItem() ) {
items[i].drawItem();
} else {
items[i] = null; 
}
} else {
r = random(400);

println( "r: ", r );
if ( r < 2 ) { // 200 分の 1 
items[i] = new Item_1();
} else if ( r < 3 ) { // 400 分の 1
items[i] = new Item_2();
} else if ( r < 4 ) { // 400 分の 1
items[i] = new Item_3();
}
}
}

float elapsedTime = millis() - startTime; 
if ( elapsedTime >= travelTime ) status = 3; 


fill(100, 255, 100);
textSize(20);
textAlign(RIGHT, TOP);
int remain = (int)(travelTime - elapsedTime) / 1000;
text(remain, width - 50, 10);

mN = (int)(mMax * elapsedTime / travelTime);
}

void gameClear() {

fill(255, 255, 0, 10);
textSize(30);
textAlign(CENTER, CENTER);
text( "GAME CLEAR", width/2, height/2);
text( "YOUR SCORE="+player.shield, width/2, height/2+50);
text( "PRESS SPACE KEY TO RESTART", width/2, height/2+100);
pressSpaceKey(); // スペースキーが押されたら再度プレイ開始
}

void gameOver() {

fill(255, 5);
rect(0, 0, width, height);

fill(0, 0, 255, 10);
textSize(30);
textAlign(CENTER, CENTER);
text( "GAME OVER", width/2, height/2 );
text( "PRESS SPACE KEY TO RESTART", width/2, height/2+50 );
pressSpaceKey(); 
}