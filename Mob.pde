
public class Mob
{
  private float mobX=0, mobY=0, mobSize=0;
  private float speed=1;
  private float[] waypoint = new float[]{0, 0, 0};
  private int mobType=0, mobHealth=0;
  private IndexRange rowIndexRange = new IndexRange(0, 0);
  private IndexRange columnIndexRange = new IndexRange(0, 0);

  public Mob(MobData mobdata)
  {
    this.mobX = mobdata.getMobColumn() * gridSize;
    this.mobY = mobdata.getMobRow() * gridSize;
    this.mobHealth = mobdata.getMobHealth();
    this.mobSize = gridSize;
    updateAllConditionRanges();
    updateWaypoint();
  }

  private void move()
  {
    if(isInSameSpace())
    {
      float minDistance = gridSize * 2;
      float distance = dist(mobX, mobY, player.getPlayerX(), player.getPlayerY());
      if(distance > minDistance) { chasePlayer(); }
      else { attackPlayer(); }
    }
    else
    {
      walkTowardWaypoint();
    }
  }
  
  private void chasePlayer()
  {
    walkTowardTo(player.getPlayerX(), player.getPlayerY());
  }
  
  private void attackPlayer()
  {
    //haven't decided how to write this part.
    text("Attack!", mobX, mobY - 10);
  }
  
  private void walkTowardWaypoint()
  {
    float distanceToWaypoint = dist(waypoint[0], waypoint[1], mobX, mobY);
    if(distanceToWaypoint < speed)
    {
      if(waypoint[2] != -1)
      {
        int direction = (int)waypoint[2];
        if(direction == 0) { waypoint[1] -= gridSize; }
        else if(direction == 1) { waypoint[0] += gridSize; }
        else if(direction == 2) { waypoint[1] += gridSize; }
        else { waypoint[0] -= gridSize; }
        updateAllConditionRanges();
        waypoint[2] = -1;
      }
      else
      {
        this.mobX = waypoint[0];
        this.mobY = waypoint[1];
        updateAllConditionRanges();
        updateWaypoint();
        return;
      }
    }
    walkTowardTo(waypoint[0], waypoint[1]);
  }
  
  private void walkTowardTo(float targetX, float targetY)
  {
    float deltaX = targetX - mobX, deltaY = targetY - mobY;
    float distanceToTarget = dist(targetX, targetY, mobX, mobY);
    
    if(distanceToTarget == 0) { return; }
    if(distanceToTarget < speed)
    {
      this.mobX = targetX;
      this.mobY = targetY;
    }
    else
    {
      this.mobX += speed * (deltaX / distanceToTarget);
      this.mobY += speed * (deltaY / distanceToTarget);
    }
  }
  
  private Gap[] getGapArray()
  {
    Gap[] gapArray = {};
    int maxColumns = (int)(width / gridSize) - 1,
      maxRows = (int)(height / gridSize) - 1;
    
    int topRow=0, bottomRow=0, leftColumn=0, rightColumn=0;
    
    if(rowIndexRange.begin == -1) { topRow = 1; }
    else { topRow = getRowValue(rowIndexRange.begin); }
    if(rowIndexRange.end == -1) { bottomRow = maxRows - 2; }
    else { bottomRow = getRowValue(rowIndexRange.end); }
    if(columnIndexRange.begin == -1) { leftColumn = 1; }
    else { leftColumn = getColumnValue(columnIndexRange.begin); }
    if(columnIndexRange.end == -1) { rightColumn = maxColumns - 2; }
    else { rightColumn = getColumnValue(columnIndexRange.end); }
    
    //get top side gaps
    if(rowIndexRange.begin != -1)
    { 
      if(topRow > 1)
      {
        for(int i=leftColumn; i <= rightColumn; i++)
        {
        gapArray = appendTo(gapArray, new Gap(topRow, i, 0));
        }
        for(int i=rowIndexRange.begin;
          i <= findLastSameValueIndex(rowIndexRange.begin, Dimension.ROW); i++)
        {
          gapArray = removeFrom(gapArray, new Gap(topRow, arrRow[i].getObsColumn(), 0));
        }
        if(rowIndexRange.begin >= 1)
        {
          for(int i=findFirstSameValueIndex(rowIndexRange.begin - 1, Dimension.ROW);
            i <= rowIndexRange.begin - 1; i++)
          {
            gapArray = removeFrom(gapArray, new Gap(topRow, arrRow[i].getObsColumn(), 0));
          }
        }
      }
    }
    //get bottom side gaps
    if(rowIndexRange.end != -1)
    {
      if(bottomRow < maxRows - 1)
      {
        for(int i=leftColumn; i <= rightColumn; i++)
        {
          gapArray = appendTo(gapArray, new Gap(bottomRow, i, 2));
        }
        for(int i=rowIndexRange.end;
          i >= findFirstSameValueIndex(rowIndexRange.end, Dimension.ROW); i--)
        {
          gapArray = removeFrom(gapArray, new Gap(bottomRow, arrRow[i].getObsColumn(), 2));
        }
        if(rowIndexRange.end <= arrRow.length - 2)
        {
          for(int i=findLastSameValueIndex(rowIndexRange.end + 1, Dimension.ROW);
            i >= rowIndexRange.end + 1; i--)
          {
            gapArray = removeFrom(gapArray, new Gap(bottomRow, arrRow[i].getObsColumn(), 2));
          }
        }
      }
    }
    //get left side gaps
    if(columnIndexRange.begin != -1)
    {
      if(leftColumn > 1)
      {
        for(int i=topRow; i <= bottomRow; i++)
        {
          gapArray = appendTo(gapArray, new Gap(i, leftColumn, 3));
        }
        for(int i=columnIndexRange.begin;
          i <= findLastSameValueIndex(columnIndexRange.begin, Dimension.COLUMN); i++)
        {
          gapArray = removeFrom(gapArray, new Gap(arrColumn[i].getObsRow(), leftColumn, 3));
        }
        if(columnIndexRange.begin >= 1)
        {
          for(int i=findFirstSameValueIndex(columnIndexRange.begin - 1, Dimension.COLUMN);
            i <= columnIndexRange.begin - 1; i++)
          {
            gapArray = removeFrom(gapArray, new Gap(arrColumn[i].getObsRow(), leftColumn, 3));
          }
        }
      }
    }
    //get right side gaps
    if(columnIndexRange.end != -1)
    {
      if(rightColumn < maxColumns - 1)
      {
        for(int i=topRow; i <= bottomRow; i++)
        {
          gapArray = appendTo(gapArray, new Gap(i, rightColumn, 1));
        }
        for(int i=columnIndexRange.end;
          i >= findFirstSameValueIndex(columnIndexRange.end, Dimension.COLUMN); i--)
        {
          gapArray = removeFrom(gapArray, new Gap(arrColumn[i].getObsRow(), rightColumn, 1));
        }
        if(columnIndexRange.end < arrColumn.length - 2)
        {
          for(int i=findLastSameValueIndex(columnIndexRange.end + 1, Dimension.COLUMN);
            i >= columnIndexRange.end + 1; i--)
          {
            gapArray = removeFrom(gapArray, new Gap(arrColumn[i].getObsRow(), rightColumn, 1));
          }
        }
      } 
    }
    return gapArray;
  }
  
  private void updateWaypoint()
  {
    Gap[] gapArray = getGapArray();
    
    /* print(mobHealth+"\n");
    for(Gap thisGap: gapArray)
    {
      print("Row: "+thisGap.gapRow+" Column: "+thisGap.gapColumn+" Direction: "+thisGap.gapDirection+"\n");
    } */
    
    if(gapArray.length == 0) { return; }
    
    float[] weight = new float[gapArray.length];
    int minIndex = 0;
    for(int i=0; i < gapArray.length; i++)
    {
      float thisGapX = gapArray[i].gapColumn * gridSize,
        thisGapY = gapArray[i].gapRow * gridSize;
      float thisWeight = dist(thisGapX, thisGapY, mobX, mobY)
        + dist(thisGapX, thisGapY, player.playerX, player.playerY) * 3;
      weight[i] = thisWeight;
      if(thisWeight < weight[minIndex]) { minIndex = i; }
    }
    /* print("Final decision-> Row: "+gapArray[minIndex].gapRow+" Column: "
      +gapArray[minIndex].gapColumn+" Direction: "+gapArray[minIndex].gapDirection+"\n\n"); */
    
    float targetX = gapArray[minIndex].gapColumn * gridSize,
      targetY = gapArray[minIndex].gapRow * gridSize;
    float targetDirection = gapArray[minIndex].gapDirection;
    waypoint = new float[]{targetX, targetY, targetDirection};
  }
  
  private void updateAllConditionRanges()
  {
    updateRowConditionRange();
    updateColumnConditionRange();
  }
  
  private void updateRowConditionRange()
  {
    IndexRange newRowConditionRange = getRowConditionRange(mobY);
    rowIndexRange.begin = newRowConditionRange.begin;
    rowIndexRange.end = newRowConditionRange.end;
  }

  private void updateColumnConditionRange()
  {
    IndexRange newColumnConditionRange = getColumnConditionRange(mobX);
    columnIndexRange.begin = newColumnConditionRange.begin;
    columnIndexRange.end = newColumnConditionRange.end;
  }
  
  private boolean isInSameSpace()
  {
     return (rowIndexRange.begin == player.getRowIndexRange().begin &&
       rowIndexRange.end == player.getRowIndexRange().end &&
       columnIndexRange.begin == player.getColumnIndexRange().begin &&
       columnIndexRange.end == player.getColumnIndexRange().end);
  }

  public void renderMob()
  {
    // also should do image(charcterTiles[i+mobType], mobX, mobY, mobSize, mobSize); here.
    // using rect() as tmp rendering object.
    noStroke();
    fill(#F72A2A);
    rect(this.mobX + 10, this.mobY + 10, 60, 60);
    //tmp hp bar.
    fill(255);
    textSize(14);
    text("HP: "+mobHealth, this.mobX, this.mobY - 5);
  }
  
  public boolean equals(Mob m)
  {
    if(this == m) { return true; }
    else if(m == null) { return false; }
    return mobX == m.getMobX() && mobY == m.getMobY() && mobHealth == m.getMobHealth();
  }
  
  public boolean isDead() { return mobHealth <= 0; }
  
  public float getMobX() { return mobX; }
  public float getMobY() { return mobY; }
  public int getMobHealth() { return mobHealth; }
}
