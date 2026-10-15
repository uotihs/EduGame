/*
usage:

1. get a object  =  Question q1;

2. in setup()    =  q1 = new Question(String questionText,String answer1,String answer2,String answer3,int width,int height);
(width is just width for the window, so as height)

3. in draw()    =  q1.Draw()   

4. in draw()    =   if(q1.DetectAns() == 1) {do sth}    // it means the first button be clicked , if ==0 : no click

5. after detect -> delete the q1

*/





public class Button{
      public int centerx;
      public int centery;
      public boolean pressed = false;
      public boolean onit = false;
      public String word = null;
      int width;
      int height;
      public Button(String word,int centerx,int centery,int width,int height)
      {
        this.word = word;
        this.centerx = centerx;
        this.centery= centery;
        this.width = width;
        this.height = height;
      }
      public void printButton()
      {
        strokeWeight(3);
        fill(255);
        if(onit)fill(#D8D8D8);
        if(pressed)fill(#5D5C5C);
        rectMode(CENTER);
        rect(centerx,centery,this.width/5,this.height/8);
        
        if(word!=null)
        {
          textSize(30);
          textAlign(CENTER,CENTER);
          fill(#5D5C5C);
          text(word,centerx,centery);
        }
        
        
      }
      public boolean checkmouse()
      {
        if(mouseX >= this.centerx - this.width/5/2 && mouseX <= this.centerx + this.width/8/2 && mouseY >= this.centery - this.height/5/2 && mouseY <= this.centery + this.height/8/2 )
        {
          if(mousePressed)
          {
            this.pressed = true;
          }
          
          if(!mousePressed && this.pressed)
          {
            this.pressed = false;
            return true;
          }
          this.onit = true;
        }
        else
        {
          this.pressed = false;
          this.onit = false;
        }
        
        if(!mousePressed)this.pressed = false;
        return false;
      }
  
}

public class Question
{
   public int centerX;
   public int centerY;
   public String questionText;
   public String answer1;
   public String answer2;
   public String answer3;
   int width;
   int height;
   
   Button ans1;
   Button ans2;
   Button ans3;
  
  public Question(String questionText,String answer1,String answer2,String answer3,int width,int height)
  {
    this.questionText = questionText;
    this.answer1 = answer1;
    this.answer2 = answer2;
    this.answer3 = answer3;
    this.width = width;
    this.height = height;
    this.ans1 = new Button(answer1,this.width/4,this.height/2- this.height/30,width,height );
    this.ans2 = new Button(answer2,this.width/4 + this.width/5 + this.width/20 ,this.height/2- this.height/30,width,height );
    this.ans3 = new Button(answer3,this.width/4 + 2*this.width/5 + 2*this.width/20,this.height/2- this.height/30,width,height );
    
  }
  
  public void Draw(int R,int G,int B)
  {
    fill(R,G,B);
    rectMode(CENTER);
    rect(this.width/2,this.height/2+this.height/4,this.width/4*3,this.height/3);
    
    this.ans1.printButton();
    this.ans2.printButton();
    this.ans3.printButton();
    
    //this.ans1.checkmouse();
    //this.ans2.checkmouse();
    //this.ans3.checkmouse();
    
    fill(255);
    textSize(30);
    textAlign(CENTER, CENTER);
    text(this.questionText,this.width/2,this.height/2+this.height/9*2);
    
  }
  
  public int DetectAns()
  {
    if(this.ans1.checkmouse()) return 1;
    if(this.ans2.checkmouse()) return 2;
    if(this.ans3.checkmouse()) return 3;
    
    return 0;
  }
  
}


//Question test;

//void setup()
//{
//  size(800,600);
//  test = new Question("test","ans1","ans2","ans3");
  
  
//}


//void draw()
//{
  
//  test.Draw(50,50,50);
//  if(test.DetectAns()!= 0)
//  {}
  
//}
