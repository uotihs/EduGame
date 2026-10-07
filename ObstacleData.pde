
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
