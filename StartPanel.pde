
class StartPanel
{
    public int wid;
    public int hei;
    public Button startB;
    public Button creditB;
    public PImage backGround;
    public int nowPage = 0;
    // 0 means startPanel
    // 1 means start
    // 2 means credit


    public StartPanel(int w,int h)
    {
        this.wid = w;
        this.hei = h;

        //============================//
        /*                            //
        backGround = loadImage("???");//
        */                            //
        //============================//

        startB = new Button("startGame",wid/10,hei/2+hei/10,wid/5,hei/5);
        creditB = new Button("credit",wid/10,hei/2+hei/10+hei/5*2,wid/5,hei/5);

    }

    public void draw()
    {

        if(nowPage == 0) // start panel
        {
            startB.printButton();
            creditB.printButton();

            checkButton();

        }
        else if(nowPage == 1) // start
        {

            // do nothing();

        }
        else if(nowPage == 2) // credit
        {
            
            fill(0);
            textSize(60);
            text("credit\n 1. xxx\n 2. xxx\n 3. xxx\n 4. xxx\n 5. xxx\n6. xxx",wid/2,hei/4);


        }


        //============================//
        /*                            //
        image(backGround,0,0);        //
        */                            //
        //============================//


    }

    public void checkButton()
    {
        startB.checkmouse();
        creditB.checkmouse();
    }




}