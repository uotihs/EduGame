class basicScenePauseUI
{
    public boolean isOn;
    public int wid;
    public int hei;

    public basicScenePauseUI(int wid,int hei)
    {
        this.wid = wid;
        this.hei = hei;
        this.isOn = false;
    }

    public void printUI()
    {

        if(this.isOn)
        {
        
            rectMode(CENTER);
            fill(200,200,200);
            rect(wid/2,hei/2,wid/3,hei/3);
            textAlign(CENTER, CENTER);
            fill(0,0,0);
            text("testing pause panel",wid/2,hei/2);

        }

    }




};


class basicSceneUI{

    public Button pauseButton;
    public basicScenePauseUI pauseUI;
    public int wid;
    public int hei;
    public int coin = 0;

    public basicSceneUI(int wid,int hei,basicScenePauseUI pauseUI)
    {
        this.wid = wid;
        this.hei = hei;
        this.pauseUI = pauseUI;
        
        pauseButton = new Button("ll",wid - wid/12,hei/12+hei/6,wid/6,hei/6);
    }



    public void printUI()
    {
        if(pauseButton.checkmouse())
        {
            // call pauseUIs on and off
            this.pauseUI.isOn = !this.pauseUI.isOn;
        }
        
        
        pauseButton.printButton();
        printSmlMap();
        printCoin();
        this.pauseUI.printUI();
    }

    public void addCoin(int addCoin)
    {
        this.coin += addCoin;
    }

    public void printSmlMap()
    {
        rectMode(CENTER);
        fill(200,200,200);
        rect(wid/12,hei/12,wid/6,hei/6);
        fill(50,50,50);
        rect(wid/12,hei/12,wid/6-5,hei/6-5);
    }

    public void printCoin()
    {
        rectMode(CENTER);
        fill(#f7d96d);
        rect(wid/12+wid/6+5,hei/12,wid/12,hei/12);
        textAlign(CENTER, CENTER);
        text("coin = " + this.coin ,wid/12+wid/6+5+wid/12,hei/12);
        
    }

};


