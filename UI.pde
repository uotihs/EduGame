/*

||====================================================================================================||


                                      **BUTTON**


//=======declare========//


Button but = Button(String word,int centerx,int centery,int width,int height);


//======in Draw()======//

1.    but.printButton();

2.    if(but.checkmouse() == true)
      {
            //the button is surely clicked!
      }

//====================//

Note :

1. you can surely access its position for flexible usages;
2. the width and height is fixed for easier maintainence
3. you can modify the text by easily add font before printButton();


||====================================================================================================||


                                      **SLIDERBAR**


//=======declare========//


SliderBar sbar = SliderBar(int centerx, int centery, int widthForSlide, int knotRadius);


//======in Draw()======//

1.    sbar.printSlider();

2.    sbar.nowValue(); //will return the value btw 0 & 100

//====================//

Note :

1. you can surely access its position for flexible usages;
2. the width and height is fixed for easier maintainence

*/


public class Button{
      public int centerx;
      public int centery;
      public boolean pressed = false;
      public boolean onit = false;
      public String word = null;
      int width1;
      int height1;
      public Button(String word,int centerx,int centery,int width1,int height1)
      {
        this.word = word;
        this.centerx = centerx;
        this.centery= centery;
        this.width1 = width1;
        this.height1 = height1;
      }
      public void printButton()
      {
        strokeWeight(3);
        fill(255);
        if(onit)fill(#D8D8D8);
        if(pressed)fill(#5D5C5C);
        rectMode(CENTER);
        rect(centerx,centery,this.width1,this.height1);
        
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
        if(mouseX >= this.centerx - this.width1/2 && mouseX <= this.centerx + this.width1/2 && mouseY >= this.centery - this.height1/2 && mouseY <= this.centery + this.height1/2 )
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


public class SliderBar 
{
  public int centerx;
  public int centery;
  public int value = 50;
  public boolean pressed = false;
  public boolean onit = false;

  int width1;
  int height1;
  boolean wasMousePressed = false;

  public SliderBar(int centerx, int centery, int width1, int height1) 
  {
    this.centerx = centerx;
    this.centery = centery;
    this.width1 = max(1, width1);
    this.height1 = max(1, height1);
  }

  public float nowValue() 
  {
    float left = centerx - this.width1 / 2.0f;
    float right = centerx + this.width1 / 2.0f;
    float radius = this.height1 / 2.0f;

    this.onit = ((mouseX >= left - radius) && (mouseX <= right + radius) && (mouseY >= centery - radius) && (mouseY <= centery + radius));

    if (mousePressed && !this.wasMousePressed) 
    {
      this.pressed = this.onit;
    }

    // boolean finished = pressed && !mousePressed;

    if (this.pressed) 
    {
      float x = constrain(mouseX, left, right);// if mouse < LEFT or mouse > RIGHT : mouse=> left,right
      value = round(map(x, left, right, 0, 100));//to map it into the value btw left,right
    }

    if (!mousePressed) this.pressed = false;
    this.wasMousePressed = mousePressed;
    return value;
  }

  public void printSlider() {
    float left = this.centerx - this.width1 / 2.0f;
    float right = this.centerx + this.width1 / 2.0f;
    float knobX = map(value, 0, 100, left, right);// this is the knot (ball on the slide)

    pushStyle(); // this func stores the outer style and do its

    strokeWeight(6);
    stroke(200);
    line(left, centery, right, centery);
    stroke(#5588CC);
    line(left, centery, knobX, centery);

    strokeWeight(2);
    stroke(80);
    fill(255);
    if (this.onit) fill(#D8D8D8);
    if (this.pressed) fill(#5D5C5C);
    ellipseMode(CENTER);
    ellipse(knobX, centery, this.height1, this.height1);

    popStyle();
  }
}



// SliderBar test;
// void setup()
// {
//  size(800,600);
//  test= new SliderBar(width/2,height/2,width/2,height/10);
  
  
// }


// void draw()
// {
  
//  test.printSlider();
 
 
//   println(test.nowValue());
 

// }
