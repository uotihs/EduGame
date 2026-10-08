public class Mob
{
  private float mobX=0, mobY=0, mobSize=0;
  private float speed=10;
  private int mobType=0, mobHealth=0;

  public Mob(MobData mobdata)
  {
    this.mobX = mobdata.getMobColumn() * gridSize;
    this.mobY = mobdata.getMobRow() * gridSize;
    this.mobHealth = mobdata.getMobHealth();
    
    this.mobSize = gridSize;
  }

  public void Render()
  {
    // also should do image(charcterTiles[i+mobType], mobX, mobY, mobSize, mobSize); here.
    // using rect() as tmp rendering object.
    noStroke();
    fill(#F72A2A);
    rect(this.mobX, this.mobY, mobSize, mobSize);
    //tmp hp bar.
    fill(255);
    textSize(14);
    text("HP: " + mobHealth, this.mobX, this.mobY - 5);
  }
  
  public boolean isAlive()
  {
    return mobHealth > 0; 
  }
  
  public float getMobX() { return mobX; }
  public float getMobY() { return mobY; }
  public int getMobHealth() { return mobHealth; }
}
