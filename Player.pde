
public class Player
{
  private float playerX=0, playerY=0, playerSize=0;
  private float speed = 10;
  // we can consider doing acceleration to get smoother movement?
  private IndexRange rowIndexRange = new IndexRange(0, 0);
  private IndexRange columnIndexRange = new IndexRange(0, 0);
  
  public Player()
  {
    this.playerSize = gridSize;
    this.playerX = width / 2 - playerSize / 2;
    this.playerY = height / 2 - playerSize / 2;
    updateAllConditionRanges();
  }
  
  public void moveUp()
  { 
    float nextPlayerY = playerY - speed;
    if(isTouchingPoint(width / 2, gridSize * 1.5) &&
      hasTopRoom() && mobArr.isEmpty())
    { 
      enterTopPortal();
      this.playerX = width / 2 - playerSize / 2;
      this.playerY = height - gridSize - playerSize;
      updateAllConditionRanges();
      onPlayerChangedConditionsRange();
      return;
    }
    if(arrRow.length == 0 || rowIndexRange.begin == -1)
    {
      this.playerY = Math.max(gridSize, nextPlayerY);
      return; 
    }
    if(nextPlayerY < (getRowValue(rowIndexRange.begin) + 1) * gridSize)
    {
      boolean isCollided = false;
      int last = findLastSameValueIndex(rowIndexRange.begin, Dimension.ROW);
      for(int i=rowIndexRange.begin; i <= last; i++)
      {
        float thisObsLeftX = arrRow[i].getObsColumn() * gridSize;
        float thisObsRightX = arrRow[i].getObsColumn() * gridSize + gridSize;
        if(playerX < thisObsRightX && playerX + playerSize > thisObsLeftX)
        {
          isCollided = true;
          break;
        }
      }
      if(isCollided) { this.playerY = (getRowValue(rowIndexRange.begin) + 1) * gridSize; } 
      else
      { 
        this.playerY = nextPlayerY;
        updateAllConditionRanges();
        onPlayerChangedConditionsRange();
      }
    }
    else { this.playerY = nextPlayerY; }
    if(nextPlayerY < gridSize) { this.playerY = gridSize; }
  }
  public void moveDown() 
  { 
    float nextPlayerY = playerY + speed;
    if(isTouchingPoint(width / 2, height - gridSize * 1.5) &&
      hasBottomRoom() && mobArr.isEmpty())
    { 
      enterBottomPortal();
      this.playerX = width / 2 - playerSize / 2;
      this.playerY = gridSize * 1;
      updateAllConditionRanges();
      onPlayerChangedConditionsRange();
      return;
    }
    if(arrRow.length == 0 || rowIndexRange.end == -1)
    {
      this.playerY = Math.min(height - gridSize - playerSize, nextPlayerY);
      return; 
    }
    if(nextPlayerY > (getRowValue(rowIndexRange.end) - 1) * gridSize)
    {
      boolean isCollided = false;
      int first = findFirstSameValueIndex(rowIndexRange.end, Dimension.ROW);
      for(int i=rowIndexRange.end; i >= first; i--)
      {
        float thisObsLeftX = arrRow[i].getObsColumn() * gridSize;
        float thisObsRightX = arrRow[i].getObsColumn() * gridSize + gridSize;
        if(playerX < thisObsRightX && playerX + playerSize > thisObsLeftX)
        {
          isCollided = true;
          break;
        }
      }
      if(isCollided) { this.playerY = getRowValue(rowIndexRange.end) * gridSize - gridSize; } 
      else 
      { 
        this.playerY = nextPlayerY;
        updateAllConditionRanges();
        onPlayerChangedConditionsRange();
      }
    }
    else { this.playerY = nextPlayerY; }
    if(nextPlayerY > height - gridSize - playerSize) { this.playerY = height - gridSize - playerSize; }
  }
  public void moveLeft() 
  { 
    float nextPlayerX = playerX - speed;
    if(isTouchingPoint(gridSize * 1.5, height / 2) &&
      hasLeftRoom() && mobArr.isEmpty())
    { 
      enterLeftPortal();
      this.playerX = width - gridSize - playerSize;
      this.playerY = height / 2 - playerSize / 2;
      updateAllConditionRanges();
      onPlayerChangedConditionsRange();
      return;
    }
    if(arrColumn.length == 0 || columnIndexRange.begin == -1)
    {
      this.playerX = Math.max(gridSize, nextPlayerX);
      return; 
    }
    if(nextPlayerX < (getColumnValue(columnIndexRange.begin) + 1) * gridSize)
    {
      boolean isCollided = false;
      int last = findLastSameValueIndex(columnIndexRange.begin, Dimension.COLUMN);
      for(int i=columnIndexRange.begin; i <= last; i++)
      {
        float thisObsTopY = arrColumn[i].getObsRow() * gridSize;
        float thisObsBottomY = arrColumn[i].getObsRow() * gridSize + gridSize;
        if(playerY < thisObsBottomY && playerY + playerSize > thisObsTopY)
        {
          isCollided = true;
          break;
        }
      }
      if(isCollided) { this.playerX = (getColumnValue(columnIndexRange.begin) + 1) * gridSize; } 
      else
      { 
        this.playerX = nextPlayerX;
        updateAllConditionRanges();
        onPlayerChangedConditionsRange();
      }
    }
    else { this.playerX = nextPlayerX; }
    if(nextPlayerX < gridSize) { this.playerX = gridSize; }
  }
  public void moveRight() 
  { 
    float nextPlayerX = playerX + speed;
    if(isTouchingPoint(width - gridSize * 1.5, height / 2) &&
      hasRightRoom() && mobArr.isEmpty())
    { 
      enterRightPortal();
      this.playerX = gridSize * 1;
      this.playerY = height / 2 - playerSize / 2;
      updateAllConditionRanges();
      onPlayerChangedConditionsRange();
      return;
    }
    if(arrColumn.length == 0 || columnIndexRange.end == -1)
    {
      this.playerX = Math.min(width - gridSize - playerSize, nextPlayerX);
      return;
    }
    if(nextPlayerX > (getColumnValue(columnIndexRange.end) - 1) * gridSize)
    {
      boolean isCollided = false;
      int first = findFirstSameValueIndex(columnIndexRange.end, Dimension.COLUMN);
      for(int i=columnIndexRange.end; i >= first; i--)
      {
        float thisObsTopY = arrColumn[i].getObsRow() * gridSize;
        float thisObsBottomY = arrColumn[i].getObsRow() * gridSize + gridSize;
        if(playerY < thisObsBottomY && playerY + playerSize > thisObsTopY)
        {
          isCollided = true;
          break;
        }
      }
      if(isCollided) { this.playerX = getColumnValue(columnIndexRange.end) * gridSize - gridSize; } 
      else
      { 
        this.playerX = nextPlayerX;
        updateAllConditionRanges();
        onPlayerChangedConditionsRange();
      }
    }
    else { this.playerX = nextPlayerX; }
    if(nextPlayerX > width - gridSize - playerSize) { this.playerX = width - gridSize - playerSize; }
  }
  
  private void updateAllConditionRanges()
  {
    updateRowConditionRange();
    updateColumnConditionRange();
  }
  
  private void updateRowConditionRange()
  {
    IndexRange newRowConditionRange = getRowConditionRange(playerY);
    rowIndexRange.begin = newRowConditionRange.begin;
    rowIndexRange.end = newRowConditionRange.end;
  }

  private void updateColumnConditionRange()
  {
    IndexRange newColumnConditionRange = getColumnConditionRange(playerX);
    columnIndexRange.begin = newColumnConditionRange.begin;
    columnIndexRange.end = newColumnConditionRange.end;
  }
  
  private boolean isTouchingPoint(float pointX, float pointY)
  {
    return ((playerX < pointX) && (playerX + playerSize > pointX)
          && (playerY < pointY) && (playerY + playerSize > pointY));
  }
  
  private void onPlayerChangedConditionsRange()
  {
    for(Mob thisMob: mobArr)
    {
      if(!thisMob.isInSameSpace() && 
        thisMob.waypoint.getWaypointDir() != Direction.CROSSING_GAP)
      {
        thisMob.updateAllConditionRanges();
        thisMob.updateWaypoint();
      }
    }
    return;
  }
  
  public void renderPlayer()
  {
    // should do image(charcterTiles[i], playerX, playerY, playerSize, playerSize); here.
    // using rect() as tmp rendering object.
    noStroke();
    fill(#F72A2A);
    rect(playerX, playerY, playerSize, playerSize);
  }
  
  public float getPlayerX() { return playerX; }
  public float getPlayerY() { return playerY; }
  public IndexRange getRowIndexRange() { return rowIndexRange; }
  public IndexRange getColumnIndexRange() { return columnIndexRange; }
  
  //for testing, can remove after movement function all done.
  public int getBeginRow() 
  { 
    try
    {
      return getRowValue(rowIndexRange.begin);
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
      return getRowValue(rowIndexRange.end);
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
      return getColumnValue(columnIndexRange.begin);
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
      return getColumnValue(columnIndexRange.end);
    }
    catch(IndexOutOfBoundsException e)
    {
      return -1;
    }
  }
}
