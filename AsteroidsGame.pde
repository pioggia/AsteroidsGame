Star[] field;
ArrayList <Asteroid> belt;
ArrayList <Bullet> storm;
boolean airlock, leftAirlock, rightAirlock, breached, shields, warp;
Vessel swordFishII = new Vessel();
public void setup() 
{
  airlock = false;
  leftAirlock=false;
  rightAirlock=false;
  breached=false;
  shields=false;
  warp=false;
  background(9, 20, 21);
  size(800, 600);
  field = new Star[55];
  for(int i=0; i<field.length; i++)
  {
    field[i] = new Star();
  }
  belt = new ArrayList <Asteroid>();
  for (int i=0; i<15; i++)
  {
    belt.add(new Asteroid());
  }
  storm = new ArrayList <Bullet>();
}
public void draw() 
{
  background(9, 20, 21);
  for(int i = 0; i<storm.size(); i++)
  {
    storm.get(i).show();
    storm.get(i).move();
    if(storm.get(i).myCenterX<-15 || storm.get(i).myCenterX>815 || storm.get(i).myCenterY<-15 || storm.get(i).myCenterY>615)
    {
      storm.remove(i);
    }
  }
  for(int i=0; i<field.length; i++)
  {
    field[i].show();
    field[i].glow();
    field[i].wrap();
    if(field[i].siz<1) //glowing stars (in progress)
    {
      field[i].siz++;
    }
    else if(field[i].siz>2)
    {
      field[i].siz--;
    }
    if(field[i].lume<185)
    {
      field[i].lume+=10;
    }
    else if(field[i].lume>20)
    {
      field[i].lume-=10;
    }
  }
  for(int i=0; i<belt.size(); i++)
  {
    belt.get(i).show();
    belt.get(i).move();
    belt.get(i).wrap();
    if(dist((float)belt.get(i).myCenterX, (float)belt.get(i).myCenterY, (float)swordFishII.myCenterX, (float)swordFishII.myCenterY) <=30)
    {
      if(warp==false) //otherwise it is possible to warp and simutaneously wipe out asteroids
      {
        belt.remove(i); 
      }
      if(shields == false && warp ==false)
      {
        breached=true;
      }
    }
    for(int o=0; o<storm.size(); o++)
    {
      if(dist((float)belt.get(i).myCenterX, (float)belt.get(i).myCenterY, (float)storm.get(o).myCenterX, (float)storm.get(o).myCenterY) <=10)
      {
        belt.remove(i);
        storm.remove(o);
      }
    }
  }
  if(shields == false)
  {
    swordFishII.myColor=color(240, 46, 46);
  }
  else if(shields == true)
  {
    swordFishII.myColor=color(98, 210, 189);
  }
  swordFishII.show();
  swordFishII.drift();
  swordFishII.jump();
  swordFishII.deployAirlock();
  swordFishII.move();
  if(key == 'p')
  {
    for(int i=0; i<240; i++) //for four seconds after engaging warp, ship is immune to damage
    {
      warp=true;
    }
    warp=false;
  }
  if(airlock==true || (breached == true && shields == false && warp == false))
  {
    rect(0, 0, 800, 600);
    fill(240, 46, 46);
    textSize(45);
    text("see you space cowboy...", 235, 530);
  }
}
public void keyPressed()
{
  if(key == ' ')
  {
    swordFishII.stabilize(); //slows ship
  }
  if(key == 'k')
  {
    swordFishII.shieldsUp(); //toggles damage, so you can cruise around if you like
  }
  if(key == '[')
  {
    leftAirlock=true;
  }
  if(leftAirlock==true && key == ']')
  {
    rightAirlock=true;
  }
  if(key == 'm')
  {
    storm.add(new Bullet(swordFishII));
  }
}
class Vessel extends Floater
{   
  private int myX, myY, mach;
  private float acceleration, rotation;
  public Vessel()
  {
    myX=0;
    myY=0;
    myColor = color(240, 46, 46);
    myCenterX=400;
    myCenterY=300;
    myDirectionX=0;
    myDirectionY=0;
    myPointDirection=0;
    corners=25;
    int[] x = {-8, -11, -5, -5, 1, 3, -2, 4, 11, 5, 12, 16, 30, 16, 12, 5, 11, 4, -2, 3, 1, -5, -5, -11, -8};
    int[] y = {4, 7, 7, 3, 4, 16, 16, 18, 16, 16, 4, 2, 0, -2, -4, -16, -16, -18, -16, -16, -4, -3, -7, -7, -4};
    xCorners = x;
    yCorners = y;
    mach=5;
    rotation = 1.5;
    acceleration = 0.03;
  }
  public void shieldsUp()
  {
    shields=!shields;
  }
  public void deployAirlock() //if both airlock doors are open ( [] is pressed ), ship self-descructs
  {
    if(leftAirlock==true && rightAirlock==true)
    {
      airlock=true;
    }
  }
  public void jump() //"it never occured to me to think of space as the thing that was moving!"
  {
    if(key=='p')
    {
        for(int u = 0; u<100; u++)
        {
          rotate(u);
        }
        myCenterX=(int)(Math.random()*800);
        myCenterY=(int)(Math.random()*600);
        for(int u = 0; u<0; u--)
        {
          rotate(u);
        }
    }
    }
    public void stabilize()
    {
      for(double i = -acceleration; i<0; i+=0.01)
      {
        accelerate(i);
      }
  }
  public void drift()
  {
    if (key == 'a')
    {
      rotate(rotation);
    }
    if (key == 'd')
    {
      rotate(-rotation);
    }
    if(key == 'w')
    {
      accelerate(acceleration);
    }
    if(key == 's')
    {
      accelerate(-acceleration);
    }
  }
  public void setX(int x) {myX=x;}  
  public int getX() {return myX;}
  public void setY(int y) {myY=y;}
  public int getY() {return myY;}
  public void setDirectionX(double x) {myDirectionX=x;}
  public double getDirectionX() {return myDirectionX;}
  public void setDirectionY(double y) {myDirectionY=y;}
  public double getDirectionY() {return myDirectionY;}
  public void setPointDirection(double degrees) {myPointDirection=degrees;}
  public double getPointDirection() {return myPointDirection;}
}
class Bullet extends Floater
{
  private int myX, myY;
  private color myColor;
  private double dRadians;
  Bullet(Vessel i)
  {
    myCenterX=swordFishII.myCenterX;
    myCenterY=swordFishII.myCenterY;
    myColor = color(255);//(193, 51, 72);
    myX=0; 
    myY=0;
    myPointDirection=swordFishII.myPointDirection;
    dRadians = myPointDirection*(Math.PI/180);
    myDirectionX = 5*Math.cos(dRadians) + swordFishII.myDirectionX;
    myDirectionY = 5*Math.sin(dRadians) + swordFishII.myDirectionY;
  }
  public void show()
  {
    stroke(myColor);
    line((float)myCenterX, (float)myCenterY, (float)(myCenterX+10*Math.cos(myPointDirection)), (float)(myCenterY+10*Math.sin(myPointDirection)));
  }
  public void move()
  {
    if((myPointDirection/180)%2==0)
    {
      myCenterX=myCenterX+18*Math.cos(myPointDirection);
      myCenterY=myCenterY-18*Math.sin(myPointDirection);
    }
    else if((myPointDirection/180)%2!=0)
    {
      myCenterX=myCenterX+18*Math.cos(myPointDirection);
      myCenterY=myCenterY+18*Math.sin(myPointDirection);
    }
  }
  public void setX(int x) {myX=x;}  
  public int getX() {return myX;}
  public void setY(int y) {myY=y;}
  public int getY() {return myY;}
  public void setDirectionX(double x) {myDirectionX=x;}
  public double getDirectionX() {return myDirectionX;}
  public void setDirectionY(double y) {myDirectionY=y;}
  public double getDirectionY() {return myDirectionY;}
  public void setPointDirection(double degrees) {myPointDirection=degrees;}
  public double getPointDirection() {return myPointDirection;}
}
class Asteroid extends Floater //debris from an exploded warpgate
{
  private int myX, myY;
  private double speedX, speedY;
  private float myRotS;
  Asteroid()
  {
    myX=0;
    myY=0;
    myColor = color(240, 46, 46);
    myCenterX=Math.random()*800;
    myCenterY=Math.random()*600;
    myDirectionX=0;
    myDirectionY=0;
    myPointDirection=0;
    myRotS = (float)(Math.random()*2)-1;
    corners=5;
    int [] x = {(int)(-(Math.random()*20)), (int)Math.random()*20, (int)Math.random()*20, (int)((Math.random()*20)-10), (int)(-(Math.random()*20))};
    int [] y = {(int)Math.random()*20, (int)Math.random()*20, (int)(-(Math.random()*20)), (int)(-(Math.random()*20)), (int)((Math.random()*20)-10)};
    xCorners = x;
    yCorners = y;
    speedX = (Math.random()*1)+1;
    speedY = (Math.random()*1)+1;
  }
  public void move()
  {
    myCenterX+=speedX;
    myCenterY+=speedY;
    rotate(myRotS);
  }
  public void wrap()
  {
    if(myCenterX<0)
    {
      myCenterX=800;
    }
    if(myCenterX>800)
    {
      myCenterX=0;
    }
    if(myCenterY<0)
    {
      myCenterY=600;
    }
    if(myCenterY>600)
    {
      myCenterY=0;
    }
  }
  public void setX(int x) {myX=x;}  
  public int getX() {return myX;}
  public void setY(int y) {myY=y;}
  public int getY() {return myY;}
  public void setDirectionX(double x) {myDirectionX=x;}
  public double getDirectionX() {return myDirectionX;}
  public void setDirectionY(double y) {myDirectionY=y;}
  public double getDirectionY() {return myDirectionY;}
  public void setPointDirection(double degrees) {myPointDirection=degrees;}
  public double getPointDirection() {return myPointDirection;}
}
class Star
{
  public int lume, siz;
  private int x, y;
  Star()
  {
    x=(int)(Math.random()*800);
    y=(int)(Math.random()*600);
    siz=(int)(Math.random()*3);
    lume=10;
  }
  public void show()
  {
    fill(255, lume);
    rect(x, y, siz, siz);
    fill(255, lume-50);
    rect(x-(siz/3), y-(siz/3), siz*2, siz*2);
    fill(255, lume-55);
    rect(x-(siz/3), y-(siz/3), siz*3, siz*3);
  }
  public void glow()
  {
    if(siz<1)
    {
      for(int i=0; i<2; i++)
      {
        siz++;
      }
    }
    else if(siz>2)
    {
      for(int i=0; i>2; i++)
      {
        siz--;
      }
    }
  }
  public void wrap()
  {
    if(x>800)
    {
      x=0;
    }
    if(x<0)
    {
      x=800;
    }
    if(y>600)
    {
      y=0;
    }
    if(y<0)
    {
      y=600;
    }
  }
}
abstract class Floater //Do NOT modify the Floater class! Make changes in the Vessel class 
{   
  protected int corners;  //the number of corners, a triangular floater has 3   
  protected int[] xCorners;   
  protected int[] yCorners;   
  protected color myColor;   
  protected double myCenterX, myCenterY; //holds center coordinates   
  protected double myDirectionX, myDirectionY; //holds x and y coordinates of the vector for direction of travel   
  protected double myPointDirection; //holds current direction the ship is pointing in degrees    
  abstract public void setX(int x);  
  abstract public int getX();   
  abstract public void setY(int y);   
  abstract public int getY();   
  abstract public void setDirectionX(double x);   
  abstract public double getDirectionX();   
  abstract public void setDirectionY(double y);   
  abstract public double getDirectionY();   
  abstract public void setPointDirection(double degrees);   
  abstract public double getPointDirection(); 

  //Accelerates the floater in the direction it is pointing (myPointDirection)   
  public void accelerate (double dAmount)   
  {          
    //convert the current direction the floater is pointing to radians    
    double dRadians =myPointDirection*(Math.PI/180);     
    //change coordinates of direction of travel    
    myDirectionX += ((dAmount) * Math.cos(dRadians));    
    myDirectionY += ((dAmount) * Math.sin(dRadians));       
  }   
  public void rotate (float nDegreesOfRotation)   
  {     
    //rotates the floater by a given number of degrees    
    myPointDirection+=nDegreesOfRotation;   
  }   
  public void move ()   //move the floater in the current direction of travel
  {      
    //change the x and y coordinates by myDirectionX and myDirectionY       
    myCenterX += myDirectionX;    
    myCenterY += myDirectionY;     

    //wrap around screen    
    if(myCenterX >width)
    {     
      myCenterX = 0;    
    }    
    else if (myCenterX<0)
    {     
      myCenterX = width;    
    }    
    if(myCenterY >height)
    {    
      myCenterY = 0;    
    }   
    else if (myCenterY < 0)
    {     
      myCenterY = height;    
    }   
  }   
  public void show ()  //Draws the floater at the current position  
  {
    if(airlock == true || (breached == true && shields == false))
    {
      noFill();
      noStroke();
    }   
    else 
    {
      //fill(myColor);
      noFill();
      stroke(myColor);
    }   
    //convert degrees to radians for sin and cos         
    double dRadians = myPointDirection*(Math.PI/180);                 
    int xRotatedTranslated, yRotatedTranslated;    
    beginShape();         
    for(int nI = 0; nI < corners; nI++)    
    {     
      //rotate and translate the coordinates of the floater using current direction 
      xRotatedTranslated = (int)((xCorners[nI]* Math.cos(dRadians)) - (yCorners[nI] * Math.sin(dRadians))+myCenterX);     
      yRotatedTranslated = (int)((xCorners[nI]* Math.sin(dRadians)) + (yCorners[nI] * Math.cos(dRadians))+myCenterY);      
      vertex(xRotatedTranslated,yRotatedTranslated);    
    }   
    endShape(CLOSE);  
  }   
} 
