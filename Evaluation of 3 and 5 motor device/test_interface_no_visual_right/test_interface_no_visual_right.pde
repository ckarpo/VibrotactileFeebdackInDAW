import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

import ddf.minim.*;

Minim minim;
AudioPlayer player1;
AudioPlayer player2;
AudioPlayer player3;
AudioPlayer player4;
AudioPlayer player5;
AudioPlayer playerE;
AudioPlayer playerQ;



//fullscreen
int[] circleX= {630, 580, 700, 860, 820};
int[] circleY= {330, 500, 595, 515, 340};
//600x600
//int[] circleX= {224,155,280,430,410};
//int[] circleY= {175,340,450,370,200};
int[] circleOver= new int[5];
int[] circleColor =new int[5];
int[] circleNum = {1,2,3,4,5};



int[] examples = {5,4,4,2,1,3,5,2,3,1,5,1,1,3,3,1,5,3,3,3,5,2,5,1,
5,4,3,2,2,3,1,2,4,4,2,2,1,5,4,3,4,4,5,4,2,5,2,1,1,4,2,5,0};

int ans; //stores the key pressed
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
 
 //for the screen reader
  minim = new Minim(this);
   player1 = minim.loadFile("ena.mp3");
  player2 = minim.loadFile("duo.mp3");
  player3 = minim.loadFile("tria.mp3");
  player4 = minim.loadFile("tesera.mp3");
  player5 = minim.loadFile("pente.mp3");

  playerE = minim.loadFile("enter.mp3");
 playerQ = minim.loadFile("epomeni_erotisi.mp3");
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


void keyPressed(){ 
  
  OscMessage myMessage = new OscMessage("/test");
  OscMessage myMessageTrigger = new OscMessage("/trigger");
  
  if (key==49){
    ans=1;
    
    if ( player1.isPlaying() )
      { 
        player2.pause();
        player3.pause();
        player4.pause();
        player5.pause();
        playerE.pause();
        playerQ.pause();
      }
      else{
        player1.rewind();
        player1.play();
      }
  } else if ( key==50){
    ans=2;
    if ( player2.isPlaying() )
      {
        player1.pause();
        player3.pause();
        player4.pause();
        player5.pause();
        playerE.pause();
        playerQ.pause();
      }
      else{
        player2.rewind();
        player2.play();
      }
    
  } else if( key==51){
    ans=3;
    if ( player3.isPlaying() )
      {
        player1.pause();
        player2.pause();
        player4.pause();
        player5.pause();
        playerE.pause();
        playerQ.pause();
      }
      else{
        player3.rewind();
        player3.play();
      }
  } else if(key==52){
    ans=4;
    if ( player4.isPlaying() )
      {
        player1.pause();
        player2.pause();
        player3.pause();
        player5.pause();
        playerE.pause();
        playerQ.pause();
      }
      else{
        player4.rewind();
        player4.play();
      }
  } else if(key==53){
    ans=5;
    if ( player5.isPlaying() )
      {
        player1.pause();
        player2.pause();
        player3.pause();
        player4.pause();
        playerE.pause();
        playerQ.pause();
      }
      else{
        player5.rewind();
        player5.play();
      }
  }
    
  if(key==ENTER){
      print(ans);
      if ( playerE.isPlaying() )
      {
        player1.pause();
        player2.pause();
        player3.pause();
        player4.pause();
        player5.pause();
        playerQ.pause();
      }
      else{
        playerE.rewind();
        playerE.play();
      }
     
    newExample=false;
    endTime=millis();
    duration=endTime-startTime;
    //print(i+1,duration," ");
    rectColor=color(0);
    //OscMessage myMessage = new OscMessage("/test");
    myMessage.add(k-1);
    myMessage.add(examples[k-1]); /* add an int to the osc message */
    myMessage.add(ans);
    myMessage.add(duration);
    
    print(k," ",examples[k]," ",ans," ",duration);
    /* send the message */
    oscP5.send(myMessage, myRemoteLocation); 
   // k=k+1;
  }

 
    if(key==32){
      if ( playerQ.isPlaying() )
      {
        player1.pause();
        player2.pause();
        player3.pause();
        player4.pause();
        player5.pause();
        playerE.pause();
      }
      else{
        playerQ.rewind();
        playerQ.play();
      }
      newExample= true; 
      rectColor=color(150);
      startTime=millis();
      myMessageTrigger.add(examples[k]);
      oscP5.send(myMessageTrigger, myRemoteLocation);
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
