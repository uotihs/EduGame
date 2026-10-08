
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
  private int mobRow=0;
  private int mobColumn=0;
  private int mobHealth=10;
  
  public MobData(int inputRow, int inputColumn)
  {
    this.mobRow = inputRow;
    this.mobColumn = inputColumn;
  }
  
  public int getMobRow() { return mobRow; }
  public int getMobColumn() { return mobColumn; }
  public int getMobHealth() { return mobHealth; }
  
  public void setMobHealth(int value) { mobHealth = value; }
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
