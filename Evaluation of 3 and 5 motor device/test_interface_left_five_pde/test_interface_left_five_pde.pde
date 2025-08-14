import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;





//fullscreen
int[] circleX= {820, 860, 700, 580, 630};//
int[] circleY= {340,515,595,500,330 };
//600x600
//int[] circleX= {410, 430 , 280, 155, 224};
//int[] circleY= {200, 370, 450, 340, 175};
int[] circleOver= new int[5];
int[] circleColor =new int[5];
int[] circleNum = {1,2,3,4,5};
//int[] examples = {5,4,4,2,1,3,5,2,3,1,5,1,1,3,3,1,5,3,3,3,5,2,5,1,
//5,4,3,2,2,3,1,2,4,4,2,2,1,5,4,3,4,4,5,4,2,5,2,1,1,4,2,5,0};

int[] examples={1,  5,  3,  5,  5,  1,  3,  5,  3,  1,  1,  3,  5,  3,  5,  1,  1,  5,  3,  5,  1,  3,  5,
3,  1,  3,  5,  1,  1,  3};

int k=0;
int circleSize =50; 
color newColor, baseColor, rectColor;
int startTime, endTime, duration;
int previousK=0;
boolean newExample= false; 

void setup(){
 //size(600,600);
 fullScreen();
 oscP5 = new OscP5(this,12000);
 myRemoteLocation = new NetAddress("127.0.0.1",12000);
 
 
 
 background(255);
 //noStroke();
 ellipseMode(CENTER);
 baseColor = color(255);
 newColor =color(0);
 for (int i=0; i<5; i++){
   circleColor[i]= color(random(200));
 }
}


void draw(){ 

fill(255);
strokeWeight(10);
ellipse(width/2,height/2, 300,300);
strokeWeight(3);

  for (int i=0; i<5; i++){
  
     
   if (circleOver[i]==1) {
      fill(circleColor[i]);
      
    } else {
      fill(baseColor);
    } 
  
    ellipse(circleX[i], circleY[i], 50,50);
    fill(20, 200, 100);
    textSize(30);
    text(circleNum[i], circleX[i]-5, circleY[i]+5);
  }
fill(rectColor);
noStroke();
rect(0, height-50, width, height) ; 
stroke(2);
fill(255);
textSize(40);
  if (k<51){
    text("New Example", width/2-150, height-20); 
  }else{
    text("End", width/3, height-20);
  }
fill(50);
textSize(20);
text("Step1: click New Example for triggering a new vibration", 20, 20);
text("Step2: click the vibration number you felt", 20, 45);
text("Note: you can experience each example only one time, and chose only 1 correct answer", 20, 70);



//print(endTime-startTime);
}


void mousePressed(){
  
  OscMessage myMessage = new OscMessage("/test");
  OscMessage myMessageTrigger = new OscMessage("/trigger");
for (int i=0; i<5; i++){  
 if (overCircle(circleX[i],circleY[i],circleSize)){
    circleOver[i]=1;
    circleColor[i]=color(100);
    newExample=false;
    endTime=millis();
    duration=endTime-startTime;
    print(i+1,duration," ");
    rectColor=color(0);
    //OscMessage myMessage = new OscMessage("/test");
    myMessage.add(k-1);
    myMessage.add(examples[k-1]); /* add an int to the osc message */
    myMessage.add(i+1);
    myMessage.add(duration);
    
    print(k," ",examples[k]," ",i+1," ",duration);
    /* send the message */
    oscP5.send(myMessage, myRemoteLocation); 
   // k=k+1;
  } 
} 

  if (mouseY> height-50){
    newExample= true; 
    for (int i=0; i<5; i++){
      circleColor[i]=color(255);
      rectColor=color(150);
      startTime=millis();
      myMessageTrigger.add(examples[k]);
      oscP5.send(myMessageTrigger, myRemoteLocation);
      
    }
    k=k+1; 
    //i put k here o indicate in what example we are, if you press accidentaly new example it will track 
    //in which example on the list we are, if you click the circle twice it will stay on the same example 
  } 
  
}

boolean overCircle(int x, int y, int diameter) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
    return true;
  } else {
    return false;
  }
}
