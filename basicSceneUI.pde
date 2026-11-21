
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= << EXAMPLE >> =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= \\
/*

basicScenePauseUI bsPUI;
basicSceneUI bsUI;

void setup()
{
    size(800,600);

    bsPUI = new basicScenePauseUI(width,height);
    bsUI = new basicSceneUI(width,height,bsPUI);
}


void draw()
{
    fill(255,255,255);
  
    rect(width/2,height/2,width,height);
    bsUI.printUI();



}

NOTES : you can totally copy this to ur code since ive finished the open and close panelPart
*/


class basicScenePauseUI
{
    public boolean isOn;
    public int wid;
    public int hei;

    public float MusicSoundValue=50;
    public float EffectSoundValue=50;

    public SliderBar musicSoundBar;
    public SliderBar effectSoundBar;


    public basicScenePauseUI(int wid,int hei)
    {
        this.wid = wid;
        this.hei = hei;
        this.isOn = false;

        musicSoundBar = new SliderBar(wid/2 + wid/18 , hei/2 - hei/6 - hei/12 ,wid/2,hei/24);
        effectSoundBar = new SliderBar(wid/2 + wid/18 , hei/2 - hei/6 - hei/12 + hei/12 ,wid/2,hei/24);
    }

    public void printUI()
    {

        if(this.isOn)
        {
        
            rectMode(CENTER);
            fill(200,200,200);
            rect(wid/2,hei/2,wid/1.5,hei/1.5);
            textAlign(CENTER, CENTER);
            fill(0,0,0);
            text("testing pause panel",wid/2,hei/2);

            if(musicSoundBar != null)
            {
                text("musicS",wid/2 + wid/18 - wid/4 -60 , hei/2 - hei/6 - hei/12 );
                musicSoundBar.printSlider();
                MusicSoundValue = musicSoundBar.nowValue();

                // assign the value to the music player 

            }
            if(effectSoundBar != null)
            {
                text("effectS",wid/2 + wid/18 - wid/4 -60 , hei/2 - hei/6 - hei/12 + hei/12 );
                effectSoundBar.printSlider();
                EffectSoundValue = effectSoundBar.nowValue();

                // assign the value to the music player 
            }


        }

    }




};


class basicSceneUI{

    public Button pauseButton;
    public basicScenePauseUI pauseUI;
    public int wid;
    public int hei;
    public int coin = 0;
    public float musicSoundval = 50;
    public float effectSoundVal = 50;



    public basicSceneUI(int wid,int hei,basicScenePauseUI pauseUI)
    {
        this.wid = wid;
        this.hei = hei;
        this.pauseUI = pauseUI;
        
        pauseButton = new Button("ll",wid - hei/16 - 10 , hei/16 + 10 ,hei/8,hei/8);
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
        
        UpdateValues();
    }

    public void UpdateValues()
    {
        musicSoundval = this.pauseUI.MusicSoundValue;
        effectSoundVal = this.pauseUI.EffectSoundValue;
    }

    public void addCoin(int addCoin)
    {
        this.coin += addCoin;
    }

    public void printSmlMap()
    {
        rectMode(CENTER);
        fill(200,200,200);
        rect(hei/12 + 5,hei/12 + 5,hei/6,hei/6);
        fill(50,50,50);
        rect(hei/12 + 5 ,hei/12 + 5,hei/6-5,hei/6-5);
    }

    public void printCoin()
    {
        rectMode(CENTER);
        fill(#f7d96d);
        rect(hei/12 + 5  + hei/6 + 5,hei/15,hei/15,hei/15);
        textAlign(CENTER, CENTER);
        text("coin = " + this.coin ,hei/12 + 5  + hei/6 + 5 + hei/15 + 50 ,hei/15);
        
    }

};
