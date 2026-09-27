
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
