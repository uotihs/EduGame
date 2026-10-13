import java.util.Arrays;
import java.lang.IndexOutOfBoundsException;
import java.util.Comparator;

public enum Dimension
{
  ROW, COLUMN
}

public class IndexRange
{
  public int begin=0, end=0;
  public IndexRange(int inputBeginIndex, int inputEndIndex)
  {
    this.begin = inputBeginIndex;
    this.end = inputEndIndex;
  }
}

public class Gap
{
  public int gapRow=0, gapColumn=0, gapDirection=0;
  
  Gap(int inputRow, int inputColumn, int inputDirection)
  {
    this.gapRow = inputRow;
    this.gapColumn = inputColumn;
    this.gapDirection = inputDirection;
  }
  
   public boolean matches(int targetRow, int targetColumn, int targetDirection)
   {
     return gapRow == targetRow && 
      gapColumn == targetColumn &&
      gapDirection == targetDirection;
   }
}

public static <T> T[] appendTo(T[] oldArr, T item)
{
  T[] newArr = Arrays.copyOf(oldArr, oldArr.length + 1);
  newArr[newArr.length-1] = item;
  return newArr;
}

public static <T> T[] removeFrom(T[] oldArr, T item)
{
  for(int i=0; i < oldArr.length; i++)
  {
    if(oldArr[i].equals(item))
    {
      T[] newArr = Arrays.copyOf(oldArr, oldArr.length - 1);
      System.arraycopy(oldArr, 0, newArr, 0, i);
      System.arraycopy(oldArr, i + 1, newArr, i, oldArr.length - i - 1);
      return newArr;
    }
  }
  return oldArr;
}

public void updateMobsArray()
{
  mobArr = new Mob[]{};
  for(MobData thisMobData: mobData[currentRow][currentColumn])
  {
    mobArr = appendTo(mobArr, new Mob(thisMobData));
  }
}

public void clearDeadMobs()
{
  mobArr = Arrays.stream(mobArr)
    .filter(mob -> !mob.isDead())
    .toArray(Mob[]::new);
}

public void renderMobs()
{
  int d=0;
  for(Mob thisMob: mobArr)
  {
    thisMob.renderMob();
    text("mobX: "+thisMob.getMobX()+" mobY: "+thisMob.getMobY()+" hp: "+thisMob.getMobHealth()
      +"\nTarget: ("+thisMob.waypoint[0]+", "+thisMob.waypoint[1]+")"
      +"\nTargetRC: ("+thisMob.waypoint[1]/gridSize+", "+thisMob.waypoint[0]/gridSize+")"
      +"\nDirection: "+thisMob.waypoint[2], 300, d * 100 + 300);
    d += 1;
  }
}

public void updateObstaclesArray()
{
  ObstacleData[] thisObsData = obsData[currentRow][currentColumn];
  arrRow = Arrays.copyOf(thisObsData, thisObsData.length);
  arrColumn = Arrays.copyOf(thisObsData, thisObsData.length);
    
  Arrays.sort(arrRow, Comparator.comparingInt(obs -> obs.getObsRow()));
  Arrays.sort(arrColumn, Comparator.comparingInt(obs -> obs.getObsColumn()));
}

public IndexRange getRowConditionRange(float inputY)
{
  if(arrRow.length == 0) 
  { 
    return new IndexRange(-1, -1); 
  }
  
  int rowBeginIndex = 0, rowEndIndex = arrRow.length - 1;
  
  for(int i = 0; i < arrRow.length; i++) 
  {
    if((getRowValue(i) + 1) * gridSize <= inputY + 1) 
    {
      rowBeginIndex = i;
    }
  }
  rowBeginIndex = findFirstSameValueIndex(rowBeginIndex, Dimension.ROW);
    
  for(int i = arrRow.length - 1; i >= 0; i--) 
  {
    if(getRowValue(i) * gridSize >  inputY) 
    {
      rowEndIndex = i;
    }
  }
  rowEndIndex = findLastSameValueIndex(rowEndIndex, Dimension.ROW);
    
  if(getRowValue(rowBeginIndex) == getRowValue(0)
    && getRowValue(rowEndIndex) == getRowValue(0)) 
  { 
    rowBeginIndex = -1; 
  }
  else if(getRowValue(rowBeginIndex) == getRowValue(arrRow.length - 1)
    && getRowValue(rowEndIndex) == getRowValue(arrRow.length - 1))
  { 
    rowEndIndex = -1; 
  }
  return new IndexRange(rowBeginIndex, rowEndIndex);
}

public IndexRange getColumnConditionRange(float inputX)
{
  if(arrColumn.length == 0) 
  {
    return new IndexRange(-1, -1); 
  }

  int columnBeginIndex = 0, columnEndIndex = arrColumn.length - 1;
    
  for(int i = 0; i < arrColumn.length; i++) 
  {
    if((arrColumn[i].getObsColumn() + 1) * gridSize <= inputX + 1)
    {
      columnBeginIndex = i;
    }
  }
  columnBeginIndex = findFirstSameValueIndex(columnBeginIndex, Dimension.COLUMN);
    
  for(int i = arrColumn.length - 1; i >= 0; i--)
  {
    if(getColumnValue(i) * gridSize > inputX)
    {
      columnEndIndex = i;  
    }
  }
  columnEndIndex = findLastSameValueIndex(columnEndIndex, Dimension.COLUMN);
    
  if(getColumnValue(columnBeginIndex) == getColumnValue(0)
    && getColumnValue(columnEndIndex) == getColumnValue(0)) 
  { 
    columnBeginIndex = -1; 
  }
  else if(getColumnValue(columnBeginIndex) == getColumnValue(arrColumn.length - 1)
    && getColumnValue(columnEndIndex) == getColumnValue(arrColumn.length - 1))
  { 
    columnEndIndex = -1; 
  }
  return new IndexRange(columnBeginIndex, columnEndIndex);
}

private int findLastSameValueIndex(int index, Dimension dimension)
{
  switch(dimension)
  {
    case ROW:
      while(index + 1 < arrRow.length &&
        arrRow[index].getObsRow() == arrRow[index + 1].getObsRow()) { index += 1; }
      break;
    case COLUMN:
      while(index + 1 < arrColumn.length &&
        arrColumn[index].getObsColumn() == arrColumn[index + 1].getObsColumn()) { index += 1; }
      break;
    default:
      throw new IllegalArgumentException("Unidentified dimension: "+dimension);
  }
  return index;
}
  
public int findFirstSameValueIndex(int index, Dimension dimension)
{
  switch(dimension)
  {
    case ROW:
      while(index > 0 &&
        arrRow[index].getObsRow() == arrRow[index - 1].getObsRow()) { index -= 1; }
      break;
    case COLUMN:
      while(index > 0 &&
        arrColumn[index].getObsColumn() == arrColumn[index - 1].getObsColumn()) { index -= 1; }
      break;
    default:
      throw new IllegalArgumentException("Unidentified dimension: "+dimension);
  }
  return index;
}
  
public int getRowValue(int rowIndex)
{
  return arrRow[rowIndex].getObsRow();
}

public int getColumnValue(int columnIndex)
{
  return arrColumn[columnIndex].getObsColumn();
}
  
public void initializeImages()
{
  backgroundImage = loadImage("images/background.png");
  
  PImage spritesheet = loadImage("images/spritesheet.png");
  int tileSize = 128;
  for(int i=0; i < tiles.length; i++)
  {
    tiles[i] = spritesheet.get(tileSize * i, 0, tileSize, tileSize); 
  }
}

public void tmpPrintRoomDisData()
{
  for(int i=0; i < roomDisData.length; i++)
  {
    for(int j=0; j < roomDisData[i].length; j++)
    {
      System.out.print(roomDisData[i][j]+" ");
    }
    System.out.print("\n");
  }
}

public void tmpDisplayRoomInformation()
{
  fill(#FFFFFF);
  textSize(35);
  text("Current Row: "+currentRow+"; Current Column: "+currentColumn
      +"; RoomValue: "+roomDisData[currentRow][currentColumn], 35, 100);
  textSize(20);
  for(int i=0; i < mobData[currentRow][currentColumn].length; i++)
  {
    MobData thisMob = mobData[currentRow][currentColumn][i];
    text(i +
        ": Row: "+ thisMob.getMobRow() +
        ", Column: "+ thisMob.getMobColumn() +
        ", Health: "+ thisMob.getMobHealth(), 60, 150+i*25);
  }
  for(int i=0; i < obsData[currentRow][currentColumn].length; i++)
  {
    ObstacleData thisObs = obsData[currentRow][currentColumn][i];
    text(i +
        ": Row: "+ thisObs.getObsRow() +
        ", Column: "+ thisObs.getObsColumn() +
        ", Type: "+ thisObs.getObsType(), 430, 150+i*25); 
  }
  text("Row: "+player.getBeginRow()+"~"+player.getEndRow()+"\n"
    +"Column: "+player.getBeginColumn()+"~"+player.getEndColumn(), 200, 650);
}

public boolean hasTopRoom()
{
  boolean topRoomExist = true;
  try { if(roomDisData[currentRow - 1][currentColumn] == -1) { topRoomExist = false; } }
  catch(IndexOutOfBoundsException e) { topRoomExist = false; }
  return topRoomExist;
}

public boolean hasBottomRoom()
{
  boolean bottomRoomExist = true;
  try { if(roomDisData[currentRow + 1][currentColumn] == -1) { bottomRoomExist = false; } }
  catch(IndexOutOfBoundsException e) { bottomRoomExist = false; }
  return bottomRoomExist;
}

public boolean hasLeftRoom()
{
  boolean leftRoomExist = true;
  try { if(roomDisData[currentRow][currentColumn - 1] == -1) { leftRoomExist = false; } }
  catch(IndexOutOfBoundsException e) { leftRoomExist = false; }
  return leftRoomExist;
}

public boolean hasRightRoom()
{
  boolean rightRoomExist = true;
  try { if(roomDisData[currentRow][currentColumn + 1] == -1) { rightRoomExist = false; } }
  catch(IndexOutOfBoundsException e) { rightRoomExist = false; }
  return rightRoomExist;
}

public void renderBackground()
{
  image(backgroundImage, 0, 0, width, height);
  
  if(hasTopRoom()) { image(tiles[0], gridSize * 5, 0, gridSize, gridSize); }
  if(hasBottomRoom()) { image(tiles[2], gridSize * 5, height - gridSize, gridSize, gridSize); }
  if(hasLeftRoom()) { image(tiles[4], 0, gridSize * 4, gridSize, gridSize); }
  if(hasRightRoom()) { image(tiles[6], width - gridSize, gridSize * 4, gridSize, gridSize); }
}

public void renderObstacles()
{
  ObstacleData[] thisObsArray = obsData[currentRow][currentColumn];
  
  for(int i=0; i < thisObsArray.length; i++)
  {
    float thisX = thisObsArray[i].getObsColumn() * gridSize;
    float thisY = thisObsArray[i].getObsRow() * gridSize;
    int thisType = thisObsArray[i].getObsType() + 8;
    image(tiles[thisType], thisX, thisY, gridSize, gridSize);
  }
}

public void enterTopPortal()
{
  fill(#FFFFFF);
  textSize(50);
  try
  {
    if(roomDisData[currentRow - 1][currentColumn] == -1)
    { 
      text("Top room doesn't exist.", 120, 400); 
    }
    else
    {
      currentRow -= 1;
      updateObstaclesArray();
      updateMobsArray();
    }
  }
  catch(IndexOutOfBoundsException e)
  {
    text("Top room doesn't exist.", 120, 400);
  }
}
public void enterBottomPortal()
{
  fill(#FFFFFF);
  textSize(50);
  try
  {
    if(roomDisData[currentRow + 1][currentColumn] == -1) 
    { 
      text("Bottom room doesn't exist.", 120, 400); 
    }
    else
    {
      currentRow += 1;
      updateObstaclesArray();
      updateMobsArray();
    }
  }
  catch(IndexOutOfBoundsException e)
  {
    text("Bottom room doesn't exist.", 120, 400);
  }
}
public void enterLeftPortal()
{
  fill(#FFFFFF);
  textSize(50);
  try
  {
    if(roomDisData[currentRow][currentColumn - 1] == -1)
    { 
      text("Left room doesn't exist.", 120, 400); 
    }
    else
    {
      currentColumn -= 1;
      updateObstaclesArray();
      updateMobsArray();
    }
  }
  catch(IndexOutOfBoundsException e)
  {
    text("Left room doesn't exist.", 120, 400);
  }
}
public void enterRightPortal()
{
  fill(#FFFFFF);
  textSize(50);
  try
  {
    if(roomDisData[currentRow][currentColumn + 1] == -1)
    { 
      text("Right room doesn't exist.", 120, 400); 
    }
    else
    {
      currentColumn += 1;
      updateObstaclesArray();
      updateMobsArray();
    }
  }
  catch(IndexOutOfBoundsException e)
  {
    text("Right room doesn't exist.", 120, 400);
  }
}
