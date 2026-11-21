/*
usage:

1. get a object  =  Question q1;

2. in setup()    =  q1 = new Question(String questionText,String answer1,String answer2,String answer3,int w,int h);
(w is just w for the window, so as h)

3. in draw()    =  q1.Draw()   

4. in draw()    =   if(q1.DetectAns() == 1) {do sth}    // it means the first button be clicked , if ==0 : no click

5. after detect -> delete the q1 by your self

*/

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= <<EXAMPLE>> =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= //

/*

Question test;

void setup()
{
 size(800,600);
 test = new Question("how to answer lim 0/0 questions","L'Hospital","L'Hopital","Locust",width,height);
  
  
}

boolean ansIsTrue = false;

void draw()
{
    fill(255);
    rectMode(CENTER);
    rect(width/2,height/2,width,height);

    int choose = test.DetectAns();
    if(choose == 0)
    {
        test.Draw(50,50,50);
    }
    else if(choose == 1) 
    {
        
    }
    else if(choose == 2)
    {
        ansIsTrue = true;
    }
    else if(choose == 3)
    {

    }
    else // ended
    {
        if(ansIsTrue)
        {
            fill(0);
            textSize(50);
            text("right!!!",width/2,height/2);
        }
    }
  
}


*/





public class Question
{
   public int centerX;
   public int centerY;
   public String questionText;
   public String answer1;
   public String answer2;
   public String answer3;
   int wid;
   int hei;
   public boolean ended = false;
   
   Button ans1;
   Button ans2;
   Button ans3;
  
  public Question(String questionText,String answer1,String answer2,String answer3,int w,int h)
  {
    this.questionText = questionText;
    this.answer1 = answer1;
    this.answer2 = answer2;
    this.answer3 = answer3;
    this.wid = w;
    this.hei = h;
    this.ans1 = new Button(answer1,this.wid/4,this.hei/2- this.hei/30,w/5,h/8 );
    this.ans2 = new Button(answer2,this.wid/4 + this.wid/5 + this.wid/20 ,this.hei/2- this.hei/30,w/5,h/8 );
    this.ans3 = new Button(answer3,this.wid/4 + 2*this.wid/5 + 2*this.wid/20,this.hei/2- this.hei/30,w/5,h/8 );
    
  }
  
  public void Draw(int R,int G,int B)
  {
    fill(R,G,B);
    rectMode(CENTER);
    rect(this.wid/2,this.hei/2+this.hei/4,this.wid/4*3,this.hei/3);
    
    this.ans1.printButton();
    this.ans2.printButton();
    this.ans3.printButton();
    
    fill(255);
    textSize(30);
    textAlign(CENTER, CENTER);
    text(this.questionText,this.wid/2,this.hei/2+this.hei/7);
    
  }
  
  public int DetectAns()
  {
    if(this.ans1.checkmouse()) { this.ended = true; return 1;}
    if(this.ans2.checkmouse()) { this.ended = true; return 2;}
    if(this.ans3.checkmouse()) { this.ended = true; return 3;}
    
    if(!this.ended)
    return 0;
    else
    return -1;
  }
  
}

