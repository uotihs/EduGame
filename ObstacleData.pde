
public class ObstacleData
{
  private int x=0;
  private int y=0;
  private int type=0;
  
  public ObstacleData(int inputX, int inputY, int inputType)
  {
    this.x = inputX;
    this.y = inputY;
    this.type = inputType;
  }
  
  public int getX() { return x; }
  public int getY() { return y; }
  public int getType() { return type; }
}
