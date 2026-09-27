
public class MobData
{
  private int spawnX=0;
  private int spawnY=0;
  private int health=10;
  
  public MobData(int inputX, int inputY)
  {
    this.spawnX = inputX;
    this.spawnY = inputY;
  }
  
  public void setHealth(int value) { health = value; }
}
