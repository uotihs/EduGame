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
    updateRowConditionRange();
    updateColumnConditionRange();
    
    this.playerSize = gridSize;
  }
  
  public void moveUp()
  { 
    float nextPlayerY = playerY - speed;
    if(isTouchingPoint(width / 2, gridSize * 1.5))
    { 
      enterTopPortal();
      updateObstacleArray();
      this.playerY = height - gridSize * 2;
      updateRowConditionRange();
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
          float thisObsRightX = (arrRow[i].getObsColumn() + 1) * gridSize;
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
          endIndexRow = last;
          if(beginIndexRow >= 1)
          { 
            beginIndexRow = findFirstSameValueIndex(beginIndexRow - 1, Dimension.ROW);
          }
          else { beginIndexRow = -1; }
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
      this.playerY = gridSize * 1;
      updateRowConditionRange();
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
          float thisObsRightX = (arrRow[i].getObsColumn() + 1) * gridSize;
          if(playerX < thisObsRightX && playerX + gridSize > thisObsLeftX)
          {
            isCollided = true;
            break;
          }
        }
        if(isCollided) { this.playerY = (arrRow[endIndexRow].getObsRow() - 1) * gridSize; } 
        else
        { 
          this.playerY = nextPlayerY;
          beginIndexRow = first;
          if(endIndexRow < arrRow.length - 1) 
          { 
            endIndexRow = findLastSameValueIndex(endIndexRow + 1, Dimension.ROW);
          }
          else { endIndexRow = -1; }
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
      updateColumnConditionRange();
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
          float thisObsLeftY = arrColumn[i].getObsRow() * gridSize;
          float thisObsRightY = (arrColumn[i].getObsRow() + 1) * gridSize;
          if(playerY < thisObsRightY && playerY + gridSize > thisObsLeftY)
          {
            isCollided = true;
            break;
          }
        }
        if(isCollided) { this.playerX = (arrColumn[beginIndexColumn].getObsColumn() + 1) * gridSize; } 
        else
        { 
          this.playerX = nextPlayerX;
          endIndexColumn = last;
          if(beginIndexColumn >= 1)
          { 
            beginIndexColumn = findFirstSameValueIndex(beginIndexColumn - 1, Dimension.COLUMN);
          }
          else { beginIndexColumn = -1; }
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
      updateColumnConditionRange();
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
          float thisObsLeftY = arrColumn[i].getObsRow() * gridSize;
          float thisObsRightY = (arrColumn[i].getObsRow() + 1) * gridSize;
          if(playerY < thisObsRightY && playerY + gridSize > thisObsLeftY)
          {
            isCollided = true;
            break;
          }
        }
        if(isCollided) { this.playerX = (arrColumn[endIndexColumn].getObsColumn() - 1) * gridSize; } 
        else
        { 
          this.playerX = nextPlayerX;
          beginIndexColumn = first;
          if(endIndexColumn < arrColumn.length - 1) 
          { 
            endIndexColumn = findLastSameValueIndex(endIndexColumn + 1, Dimension.COLUMN);
          }
          else { endIndexColumn = -1; }
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
  
  private void updateRowConditionRange()
  {
    beginIndexRow = -1;
    endIndexRow = -1;
    if(arrRow.length == 0)
    { 
      return; 
    }
    else if(playerY <= arrRow[0].getObsRow() * gridSize) 
    { 
      endIndexRow = 0; 
      return;
    }
    else if(playerY >= (arrRow[arrRow.length-1].getObsRow() + 1) * gridSize) 
    { 
      beginIndexRow = findFirstSameValueIndex(arrRow.length-1, Dimension.ROW);
      return;
    }
    beginIndexRow = 0;
    endIndexRow = 0;  
    for(int i=1; i < arrRow.length; i++)
    {
      if(arrRow[i].getObsRow() > arrRow[i-1].getObsRow() 
        && (arrRow[i].getObsRow() + 1) * gridSize <= playerY)
      {
        this.beginIndexRow = i;
      }
      if((arrRow[i-1].getObsRow() + 1) * gridSize <= playerY 
        && arrRow[i].getObsRow() * gridSize > playerY)
      {
        this.endIndexRow = i;
        endIndexRow = findLastSameValueIndex(endIndexRow, Dimension.ROW);
        break;
      }
    }
  }
  private void updateColumnConditionRange()
  {
    beginIndexColumn = -1;
    endIndexColumn = -1;
    if(arrColumn.length == 0)
    { 
      return; 
    }
    else if(playerX <= arrColumn[0].getObsColumn() * gridSize) 
    { 
      endIndexColumn = 0; 
      return;
    }
    else if(playerX >= (arrColumn[arrColumn.length-1].getObsColumn() + 1) * gridSize) 
    { 
      beginIndexColumn = findFirstSameValueIndex(arrColumn.length-1, Dimension.COLUMN);
      return;
    }
    beginIndexColumn = 0;
    endIndexColumn = 0;  
    for(int i=1; i < arrColumn.length; i++)
    {
      if(arrColumn[i].getObsColumn() > arrColumn[i-1].getObsColumn() 
        && (arrColumn[i].getObsColumn() + 1) * gridSize <= playerX)
      {
        this.beginIndexColumn = i;
      }
      if((arrColumn[i-1].getObsColumn() + 1) * gridSize <= playerX
        && arrColumn[i].getObsColumn() * gridSize > playerX)
      {
        this.endIndexColumn = i;
        endIndexColumn = findLastSameValueIndex(endIndexColumn, Dimension.COLUMN);
        break;
      }
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
  public int getBeginIndexRow() { return beginIndexRow; }
  public int getEndIndexRow() { return endIndexRow; }
}
