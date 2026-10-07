
public class MapData
{
  private int[][] roomDistData = new int[5][5];
  private MobData[][][] mobData = new MobData[5][5][0];
  private ObstacleData[][][] obsData = new ObstacleData[5][5][0];
  
  public MapData()
  {
    for(int i=0; i < this.roomDistData.length; i++)
    {
      for(int j=0; j < this.roomDistData[i].length; j++)
      {
        this.roomDistData[i][j] = -1;
      }
    }
  }
  
  public int[][] getRoomDistData() { return roomDistData; }
  public MobData[][][] getMobData() { return mobData; }
  public ObstacleData[][][] getObsData() { return obsData; }
}

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

public class ObstacleData
{
  private int obsRow=0;
  private int obsColumn=0;
  private int obsType=0;
  
  public ObstacleData(int inputRow, int inputColumn, int inputType)
  {
    this.obsRow = inputRow;
    this.obsColumn = inputColumn;
    this.obsType = inputType;
  }
  
  public int getObsRow() { return obsRow; }
  public int getObsColumn() { return obsColumn; }
  public int getObsType() { return obsType; }
}
