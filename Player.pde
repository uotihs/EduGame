import java.util.Comparator;

public class Player
{
  private float playerX=0, playerY=0, playerSize=0;
  private float speed = 10; 
  // we can consider doing acceleration to get smoother movement?
  private ObstacleData[] arrRow, arrColumn;
  private int beginIndexRow=0, endIndexRow=0, beginIndexColumn=0, endIndexColumn=0;
  
  public Player()
  {
    updateObstacleArray();
    this.playerX = width / 2 - gridSize / 2;
    this.playerY = height / 2 - gridSize / 2;
    updateAllConditionRanges();
    
    this.playerSize = gridSize;
  }
  
  public void moveUp()
  { 
    float nextPlayerY = playerY - speed;
    if(isTouchingPoint(width / 2, gridSize * 1.5))
    { 
      enterTopPortal();
      updateObstacleArray();
      this.playerX = width / 2 - gridSize / 2;
      this.playerY = height - gridSize * 2;
      updateAllConditionRanges();
      return;
    }
    if(arrRow.length == 0 || beginIndexRow == -1)
    {
      this.playerY = Math.max(gridSize, nextPlayerY);
      return; 
    }
    if(nextPlayerY < (arrRow[beginIndexRow].getObsRow() + 1) * gridSize)
      {
        boolean isCollided = false;
        int last = findLastSameValueIndex(beginIndexRow, Dimension.ROW);
        for(int i=beginIndexRow; i <= last; i++)
        {
          float thisObsLeftX = arrRow[i].getObsColumn() * gridSize;
          float thisObsRightX = arrRow[i].getObsColumn() * gridSize + gridSize;
          if(playerX < thisObsRightX && playerX + gridSize > thisObsLeftX)
          {
            isCollided = true;
            break;
          }
        }
        if(isCollided) { this.playerY = (arrRow[beginIndexRow].getObsRow() + 1) * gridSize; } 
        else
        { 
          this.playerY = nextPlayerY;
          updateAllConditionRanges();
        }
      }
      else { this.playerY = nextPlayerY; }
      if(nextPlayerY < gridSize) { this.playerY = gridSize; }
  }
  public void moveDown() 
  { 
    float nextPlayerY = playerY + speed;
    if(isTouchingPoint(width / 2, height - gridSize * 1.5))
    { 
      enterBottomPortal();
      updateObstacleArray();
      this.playerX = width / 2 - gridSize / 2;
      this.playerY = gridSize * 1;
      updateAllConditionRanges();
      return;
    }
    if(arrRow.length == 0 || endIndexRow == -1)
    {
      this.playerY = Math.min(height - gridSize * 2, nextPlayerY);
      return; 
    }
    if(nextPlayerY > (arrRow[endIndexRow].getObsRow() - 1) * gridSize)
      {
        boolean isCollided = false;
        int first = findFirstSameValueIndex(endIndexRow, Dimension.ROW);
        for(int i=endIndexRow; i >= first; i--)
        {
          float thisObsLeftX = arrRow[i].getObsColumn() * gridSize;
          float thisObsRightX = arrRow[i].getObsColumn() * gridSize + gridSize;
          if(playerX < thisObsRightX && playerX + gridSize > thisObsLeftX)
          {
            isCollided = true;
            break;
          }
        }
        if(isCollided) { this.playerY = arrRow[endIndexRow].getObsRow() * gridSize - gridSize; } 
        else 
        { 
          this.playerY = nextPlayerY;
          updateAllConditionRanges();
        }
      }
      else { this.playerY = nextPlayerY; }
      if(nextPlayerY > height - gridSize * 2) { this.playerY = height - gridSize * 2; }
  }
  public void moveLeft() 
  { 
    float nextPlayerX = playerX - speed;
    if(isTouchingPoint(gridSize * 1.5, height / 2))
    { 
      enterLeftPortal();
      updateObstacleArray();
      this.playerX = width - gridSize * 2;
      this.playerY = height / 2 - gridSize / 2;
      updateAllConditionRanges();
      return;
    }
    if(arrColumn.length == 0 || beginIndexColumn == -1)
    {
      this.playerX = Math.max(gridSize, nextPlayerX);
      return; 
    }
    if(nextPlayerX < (arrColumn[beginIndexColumn].getObsColumn() + 1) * gridSize)
      {
        boolean isCollided = false;
        int last = findLastSameValueIndex(beginIndexColumn, Dimension.COLUMN);
        for(int i=beginIndexColumn; i <= last; i++)
        {
          float thisObsTopY = arrColumn[i].getObsRow() * gridSize;
          float thisObsBottomY = arrColumn[i].getObsRow() * gridSize + gridSize;
          if(playerY < thisObsBottomY && playerY + gridSize > thisObsTopY)
          {
            isCollided = true;
            break;
          }
        }
        if(isCollided) { this.playerX = (arrColumn[beginIndexColumn].getObsColumn() + 1) * gridSize; } 
        else
        { 
          this.playerX = nextPlayerX;
          updateAllConditionRanges();
        }
      }
      else { this.playerX = nextPlayerX; }
      if(nextPlayerX < gridSize) { this.playerX = gridSize; }
  }
  public void moveRight() 
  { 
    float nextPlayerX = playerX + speed;
    if(isTouchingPoint(width - gridSize * 1.5, height / 2))
    { 
      enterRightPortal();
      updateObstacleArray();
      this.playerX = gridSize * 1;
      this.playerY = height / 2 - gridSize / 2;
      updateAllConditionRanges();
      return;
    }
    if(arrColumn.length == 0 || endIndexColumn == -1)
    {
      this.playerX = Math.min(width - gridSize * 2, nextPlayerX);
      return; 
    }
    if(nextPlayerX > (arrColumn[endIndexColumn].getObsColumn() - 1) * gridSize)
      {
        boolean isCollided = false;
        int first = findFirstSameValueIndex(endIndexColumn, Dimension.COLUMN);
        for(int i=endIndexColumn; i >= first; i--)
        {
          float thisObsTopY = arrColumn[i].getObsRow() * gridSize;
          float thisObsBottomY = arrColumn[i].getObsRow() * gridSize + gridSize;
          if(playerY < thisObsBottomY && playerY + gridSize > thisObsTopY)
          {
            isCollided = true;
            break;
          }
        }
        if(isCollided) { this.playerX = arrColumn[endIndexColumn].getObsColumn() * gridSize - gridSize; } 
        else
        { 
          this.playerX = nextPlayerX;
          updateAllConditionRanges();
        }
      }
      else { this.playerX = nextPlayerX; }
      if(nextPlayerX > width - gridSize * 2) { this.playerX = width - gridSize * 2; }
  }
  
  private void updateObstacleArray()
  {
    ObstacleData[] thisObsData = obsData[currentRow][currentColumn];
    this.arrRow = Arrays.copyOf(thisObsData, thisObsData.length);
    this.arrColumn = Arrays.copyOf(thisObsData, thisObsData.length);
    
    Arrays.sort(arrRow, Comparator.comparingInt(obs -> obs.getObsRow()));
    Arrays.sort(arrColumn, Comparator.comparingInt(obs -> obs.getObsColumn()));
  }
  
  private void updateAllConditionRanges()
  {
    updateRowConditionRange();
    updateColumnConditionRange();
  }
  private void updateRowConditionRange()
  {
    if(arrRow.length == 0) 
    { 
      beginIndexRow = -1;
      endIndexRow = -1;
      return; 
    }
    
    beginIndexRow = 0;
    endIndexRow = arrRow.length - 1;
    
    for(int i = 0; i < arrRow.length; i++) 
    {
      if((arrRow[i].getObsRow() + 1) * gridSize <= playerY + 1) 
      {
        beginIndexRow = i;
      }
    }
    beginIndexRow = findFirstSameValueIndex(beginIndexRow, Dimension.ROW);
    
    for(int i = arrRow.length - 1; i >= 0; i--) 
    {
      if(arrRow[i].getObsRow() * gridSize >  playerY) 
      {
        endIndexRow = i;
      }
    }
    endIndexRow = findLastSameValueIndex(endIndexRow, Dimension.ROW);
    
    if(arrRow[beginIndexRow].getObsRow() == arrRow[0].getObsRow()
      && arrRow[endIndexRow].getObsRow() == arrRow[0].getObsRow()) 
    { 
      beginIndexRow = -1; 
    }
    else if(arrRow[beginIndexRow].getObsRow() == arrRow[arrRow.length - 1].getObsRow()
      && arrRow[endIndexRow].getObsRow() == arrRow[arrRow.length - 1].getObsRow())
    { 
      endIndexRow = -1; 
    }
  }
  private void updateColumnConditionRange()
  {
    if(arrColumn.length == 0) 
    { 
      beginIndexColumn = -1;
      endIndexColumn = -1;
      return; 
    }

    beginIndexColumn = 0;
    endIndexColumn = arrColumn.length - 1;
    
    for(int i = 0; i < arrColumn.length; i++) 
    {
      if((arrColumn[i].getObsColumn() + 1) * gridSize <= playerX + 1)
      {
        beginIndexColumn = i;
      }
    }
    beginIndexColumn = findFirstSameValueIndex(beginIndexColumn, Dimension.COLUMN);
    
    for(int i = arrColumn.length - 1; i >= 0; i--)
    {
      if(arrColumn[i].getObsColumn() * gridSize > playerX)
      {
        endIndexColumn = i;  
      }
    }
    endIndexColumn = findLastSameValueIndex(endIndexColumn, Dimension.COLUMN);
    
    if(arrColumn[beginIndexColumn].getObsColumn() == arrColumn[0].getObsColumn()
      && arrColumn[endIndexColumn].getObsColumn() == arrColumn[0].getObsColumn()) 
    { 
      beginIndexColumn = -1; 
    }
    else if(arrColumn[beginIndexColumn].getObsColumn() == arrColumn[arrColumn.length - 1].getObsColumn()
      && arrColumn[endIndexColumn].getObsColumn() == arrColumn[arrColumn.length - 1].getObsColumn())
    { 
      endIndexColumn = -1; 
    }
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
  private int findFirstSameValueIndex(int index, Dimension dimension)
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
  
  private boolean isTouchingPoint(float pointX, float pointY)
  {
    return ((playerX < pointX) && (playerX + gridSize > pointX)
          && (playerY < pointY) && (playerY + gridSize > pointY));
  }
  
  public void renderPlayer()
  {
    // should do image(charcterTiles[i], playerX, playerY, playerWidth, playerHeight); here.
    // using rect() as tmp rendering object.
    noStroke();
    fill(#F72A2A);
    rect(playerX, playerY, playerSize, playerSize);
  }
  
  public float getPlayerX() { return playerX; }
  public float getPlayerY() { return playerY; }
  
  //for testing, can remove after movement function all done.
  public int getBeginRow() 
  { 
    try
    {
      return arrRow[beginIndexRow].getObsRow();
    }
    catch(IndexOutOfBoundsException e)
    {
      return -1;
    }
  }
  public int getEndRow()
  { 
    try
    {
      return arrRow[endIndexRow].getObsRow();
    }
    catch(IndexOutOfBoundsException e)
    {
      return -1;
    }
  }
  public int getBeginColumn()
  { 
    try
    {
      return arrColumn[beginIndexColumn].getObsColumn();
    }
    catch(IndexOutOfBoundsException e)
    {
      return -1;
    }
  }
  public int getEndColumn()
  { 
    try
    {
      return arrColumn[endIndexColumn].getObsColumn();
    }
    catch(IndexOutOfBoundsException e)
    {
      return -1;
    }
  }
}
