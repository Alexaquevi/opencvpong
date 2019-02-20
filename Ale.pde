import gab.opencv.*;
import java.awt.Rectangle;
import processing.video.*;

Capture video;
PImage img;
boolean newFrame=false;
float escalaVideo = 2.5; // factor de escala del video que analiza opencv
int anchoA, altoA;

OpenCV opencv;
Rectangle[] faces;//guarda rectangulos de las caras, determinar en que posición del rect

float miX, miY; //variables para encontrar el rostro en x y y

float xLoc=random(0,640); // localización random a lo largo del eje x
float yLoc=random(0,480); // localización random a lo largo del eje y
float xVel=3;   //velocidad en x
float yVel=-3;  //velocidad en y
int score=0;

void setup(){
  size(640,480);
  
  anchoA = int (640/escalaVideo);
  altoA = int (480/escalaVideo);
  
  video = new Capture(this, anchoA, altoA);
  video.start(); // Comment the this line if you use Processing 1.5
  // img which will be sent to detection (a smaller copy of the cam frame)
  // this image is 8 times smaller that video 
  img = new PImage(anchoA, altoA);
   
  opencv = new OpenCV(this, video.width, video.height);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  //ver si hay caras de frente
  faces = opencv.detect();//guarda las detectadas
}
void draw(){
  background(38,34,98);
  ellipse(xLoc,yLoc,20,20);
  rect(miX,450,100,10);
  xLoc+=xVel; // localización y velocidad rectangulo
  yLoc+=yVel; // movimiento de la bola
  
  if(xLoc<=0||xLoc>=640){ //limites en x
    xVel=-xVel;}
    
  if(yLoc<=10){
    yVel=-yVel;}
    
  if((435<=yLoc)&&(yLoc<=465)&&(yVel>0)&&(miX-50<=xLoc)&&(xLoc<=miX+50)){
    yVel=-(yVel+0.5); //rebote
    println (miX);
    println (xLoc);
    
    if(xVel>0){
      xVel+=0.1;}
      
    else{
      xVel-=0.1;}
      
    
  }
    
  if(yLoc>=490){
    textSize(50);
    text("GAME OVER",180,330);}
    textSize(16);
  
  opencv.loadImage(video);
  opencv.flip(OpenCV.HORIZONTAL); 
  img = opencv.getSnapshot();
  opencv.useColor(RGB);  
  image(img, 0, 0,anchoA,altoA);
  faces = opencv.detect();
  
  noFill();
  stroke(141,198,63);
  //strokeWeight(3);
  for (int i = 0; i < faces.length; i++) {
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);//detecta parametros de las caras, controla la situación
    miX = map(faces[i].x+ (faces[i].width/2),0,anchoA,0,width);
    miY = map(faces[i].y +(faces[i].height/2),0,altoA,0,height);
 
}
  
  fill(141,198,63);}
  //text("frameRate = " + frameRate, 10, height-15);


void captureEvent(Capture cam) {
  cam.read();
  newFrame = true;
}

void drawCam () {
  if (newFrame) {
    newFrame=false;
    //image(video, 0, 0, width, height);
    img.copy(video, 0, 0, video.width, video.height, 0, 0, img.width, img.height);
  }
}


  
  