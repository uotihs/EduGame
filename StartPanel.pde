class StartPanel
{
    public int wid;
    public int hei;
    public Button startB;
    public Button creditB;
    public Button backCreditB;
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
        //                            //
        backGround = loadImage("images/startPanelBG.png");//
        //                            //
        //============================//

        startB = new Button("startGame",wid/5,hei/5+hei/10,wid/4,hei/10);
        creditB = new Button("credit",wid/5,hei/5+hei/10+hei/6,wid/4,hei/10);
        backCreditB = new Button("ll",wid - wid/10 , hei/10 + 10 ,wid/10,hei/10);
    }

    public void draw()
    {        
        

        pushMatrix();
        translate(0,0);
        
        if(nowPage == 0) // start panel
        {
            //============================//
            //                            //
            image(backGround,0,0);        //
            //                            //
            //============================//
            fill(99 , 75 , 47);
            textSize(70);
            text("MAKE A GOOD GAME-DEMO",wid/2,hei/8);
            
            
            startB.printButton(10, 99 , 75 , 47 , 153 ,126, 95, 40, 99 , 75 , 47);
            creditB.printButton(10, 99 , 75 , 47 , 153 ,126, 95, 40 ,99 , 75 , 47);

            nowPage = checkButton();


        }
        else if(nowPage == 1) // start
        {

            // join your game!

        }
        else if(nowPage == 2) // credit
        {
            noStroke();
            fill(105,192,97);
            rectMode(CENTER);
            rect(width/2,height/2,width,height);

            if(backCreditB.checkmouse()) nowPage = 0;
            backCreditB.printButton(10, 99 , 75 , 47 , 153 ,126, 95, 40 ,99 , 75 , 47);
            
            fill(99 , 75 , 47 );
            textSize(50);
            text("credit\n 1. 吳文禾\n 2. 黃上銘\n 3. 薛宇峻\n 4. 郭峻愷\n 5. 林宥廷\n6. 黃暐宸",wid/5,hei/3+100);
        }
        rectMode(CORNER);
        popMatrix();



    }

    public int checkButton()
    {
        if(startB.checkmouse()) return 1;
        if(creditB.checkmouse()) return 2;
        return 0;
    }




}

