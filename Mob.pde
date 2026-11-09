import java.util.Queue;
import java.util.LinkedList;
import java.util.Map;
import java.util.Collections;
import java.util.ArrayDeque;

public class Mob
{
  private float mobX=0, mobY=0, mobSize=0;
  private float speed=2;
  private int mobType=0, mobHealth=0;
  private ArrayList<int[]> path = new ArrayList<>(),
    originalPath = new ArrayList<>();
  private boolean preCanSee = true;

  public Mob(MobData mobdata)
  {
    this.mobX = mobdata.getMobColumn() * gridSize;
    this.mobY = mobdata.getMobRow() * gridSize;
    this.mobHealth = mobdata.getMobHealth();
    this.mobSize = gridSize;
    updatePath();
  }

  private void move()
  {
    if(canSeePlayer())
    {
      preCanSee = true;
      float minDistance = gridSize * 2;
      float distance = dist(mobX, mobY, player.getPlayerX(), player.getPlayerY());
      if(distance > minDistance) { chasePlayer(); }
      else { attackPlayer(); }
    }
    else
    {
      if(preCanSee == true)
      {
        resetPath();
        preCanSee = false;
      }
      walkTowardWaypoint();
    }
  }
  
  private boolean canSeePlayer()
  {
    return LoS(mobX, mobY, player.getPlayerX(), player.getPlayerY());
  }
  
  private boolean LoS(float startX, float startY, float endX, float endY)
  {
    float startCX = startX + gridSize / 2,
      startCY = startY + gridSize / 2,
      endCX = endX + gridSize / 2,
      endCY = endY + gridSize / 2;
      
    int currentColumn = (int)(startCX / gridSize),
      currentRow = (int)(startCY / gridSize),
      endColumn = (int)(endCX / gridSize),
      endRow = (int)(endCY / gridSize);
    if(currentRow == endRow && currentColumn == endColumn) { return true; }
    if(isObstacle(currentRow, currentColumn)) { return false; }
      
    float deltaX = endCX - startCX,
      deltaY = endCY - startCY;
      
    int stepRow, stepColumn;
    float nextXBoundary, nextYBoundary;
    if(deltaX > 0)
    { 
      stepColumn = 1;
      nextXBoundary = (currentColumn + 1) * gridSize;
    }
    else
    {
      stepColumn = -1;
      nextXBoundary = currentColumn * gridSize;
    }
    if(deltaY > 0)
    {
      stepRow = 1;
      nextYBoundary = (currentRow + 1) * gridSize;
    }
    else
    {
      stepRow = -1;
      nextYBoundary = currentRow * gridSize;
    }
    
    float tX, tY, tTotalX, tTotalY;
    if(deltaX != 0)
    {
      tX = abs(gridSize / deltaX);
      tTotalX = abs((nextXBoundary - startCX) / deltaX);
    }
    else
    {
      tX = Float.POSITIVE_INFINITY;
      tTotalX = Float.POSITIVE_INFINITY;
    }
    if(deltaY != 0)
    {
      tY = abs(gridSize / deltaY);
      tTotalY = abs((nextYBoundary - startCY) / deltaY);
    }
    else
    {
      tY = Float.POSITIVE_INFINITY;
      tTotalY = Float.POSITIVE_INFINITY;
    }
  
    while(currentRow != endRow || currentColumn != endColumn)
    {
      if(tTotalX < tTotalY)
      {
        currentColumn += stepColumn;
        tTotalX += tX;
      }
      else if(tTotalX > tTotalY)
      {
        currentRow += stepRow;
        tTotalY += tY;
      }
      else
      {
        if(isObstacle(currentRow + stepRow, currentColumn) ||
          isObstacle(currentRow, currentColumn + stepColumn))
        {
          return false;
        }
        currentRow += stepRow;
        currentColumn += stepColumn;
        tTotalX += tX;
        tTotalY += tY;
      }
      if(isObstacle(currentRow, currentColumn)) { return false; }
    }
    return true;
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
    int[] curWaypoint = path.get(0);
    float thisWaypointX = (curWaypoint[1] + 1) * gridSize,
      thisWaypointY = (curWaypoint[0] + 1) * gridSize;
      
    float distanceToWaypoint = dist(thisWaypointX, thisWaypointY, mobX, mobY);
    if(distanceToWaypoint < speed)
    {  
      this.mobX = thisWaypointX;
      this.mobY = thisWaypointY;
      updatePath();
    }
    walkTowardTo(thisWaypointX, thisWaypointY);
  }
  
  private void walkTowardTo(float targetX, float targetY)
  {
    float deltaX = targetX - mobX, deltaY = targetY - mobY,
      distanceToTarget = dist(targetX, targetY, mobX, mobY);
    
    if(distanceToTarget == 0) { return; }
    
    float stepX = deltaX / distanceToTarget,
      stepY = deltaY / distanceToTarget;
      
    boolean verticalCollide = isVerticalCollided(stepY),
      horizontalCollide = isHorizontalCollided(stepX);
    
    if(verticalCollide && horizontalCollide)
    {
      //should not be happening, if so it's bad path finding.
      return;
    }
    else if(verticalCollide && !horizontalCollide)
    {
      if(Math.abs(deltaX) < speed)
      {
        this.mobX = targetX;
        updatePath();
      }
      else
      { this.mobX += speed * Math.signum(stepX); }
    }
    else if(!verticalCollide && horizontalCollide)
    {
      if(Math.abs(deltaY) < speed)
      {
        this.mobY = targetY;
        updatePath();
      }
      else
      { this.mobY += speed * Math.signum(stepY); } 
    }
    else
    {
      if(distanceToTarget < speed)
      {
        this.mobX = targetX;
        this.mobY = targetY;
        updatePath();
      }
      else
      {
        this.mobX += speed * (deltaX / distanceToTarget);
        this.mobY += speed * (deltaY / distanceToTarget);
      }
    }
    return;
  }
  
  private boolean isVerticalCollided(float stepY)
  {
    float nextY = mobY + stepY;
    int nextRow = 0;
    if(stepY < 0) { nextRow = (int)(nextY / gridSize); }
    else { nextRow = (int)((nextY + mobSize) / gridSize); }
    int leftColumn = (int)(mobX / gridSize),
      rightColumn = (int)((mobX + mobSize - 1) / gridSize);
    return isObstacle(nextRow, leftColumn) || isObstacle(nextRow, rightColumn);
  }
  
  private boolean isHorizontalCollided(float stepX)
  {
    float nextX = mobX + stepX;
    int nextColumn = 0;
    if(stepX < 0) { nextColumn = (int)(nextX / gridSize); }
    else { nextColumn = (int)((nextX + mobSize) / gridSize); }
    int topRow = (int)(mobY / gridSize),
      bottomRow = (int)((mobY + mobSize - 1) / gridSize);
    return isObstacle(topRow, nextColumn) || isObstacle(bottomRow, nextColumn);
  }

  private void updatePath()
  {
    if(path.size() <= 1) { resetPath(); }
    else { path.remove(0); }
  }
  
  private void resetPath()
  {
    ArrayList<int[]> newPath = getPath();
    if(path.size() <= 1 || !isSamePath(originalPath, newPath))
    {
      originalPath = newPath;
      path = newPath;
    }
  }
  
  private boolean isSamePath(ArrayList<int[]> originP, ArrayList<int[]> newP)
  {
    if(originP == null || newP == null) { return originP == newP; }
    if(originP.size() != newP.size()) { return false; }
    for(int i = 0; i < originP.size(); i++)
    {
      if(!Arrays.equals(originP.get(i), newP.get(i))) { return false; }
    }
    return true;
  }
  
  private ArrayList<int[]> getPath()
  {
    int endRow = max((int)((player.playerY + player.playerSize / 2) / gridSize) - 1, 0),
      endColumn = max((int)((player.playerX + player.playerSize / 2) / gridSize) - 1, 0);
     
    int startRow = max((int)((mobY + mobSize / 2) / gridSize) - 1, 0),
      startColumn = max((int)((mobX + mobSize / 2) / gridSize) - 1, 0);
      
    Queue<int[]> queue = new ArrayDeque<>();
    boolean[] visited = Arrays.copyOf(obsArr, obsArr.length);
    int[][] directions = {{-1, 0}, {0, 1}, {1, 0}, {0, -1}};
    
    Map<Integer, Integer> parentMap = new HashMap<>();
    
    queue.add(new int[]{startRow, startColumn});
    parentMap.put(startRow * columns + startColumn, -1);
    visited[startRow * columns + startColumn] = true;
    
    while(!queue.isEmpty())
    {
      int[] cur = queue.poll();
      if(cur[0] == endRow && cur[1] == endColumn) { break; }
      
      for(int i = 0; i < 4; i++)
      {
        int nextRow = cur[0] + directions[i][0],
          nextColumn = cur[1] + directions[i][1];
        if(nextRow >= 0 && nextRow <= rows - 1
          && nextColumn >= 0 && nextColumn <= columns - 1)
        {
          if(!visited[nextRow * columns + nextColumn])
          {
            queue.add(new int[]{nextRow, nextColumn});
            parentMap.put(nextRow * columns + nextColumn, cur[0] * columns + cur[1]);
            visited[nextRow * columns + nextColumn] = true;
          }
        }
      }
    }
    ArrayList<int[]> path = new ArrayList<>();
    Integer cur = endRow * columns + endColumn;
    if(!parentMap.containsKey(cur)) { return path; }
    
    while(cur != null && cur != -1)
    {
      path.add(new int[]{cur / columns, cur % columns});
      cur = parentMap.get(cur);
    }
    Collections.reverse(path);
    return smoothPath(path);
  }
  
  ArrayList<int[]> smoothPath(ArrayList<int[]> p)
  {
    if(p.size() <= 1) return p;

    ArrayList<int[]> smoothedPath = new ArrayList<>();
    smoothedPath.add(p.get(0));
    int curIndex = 0;
    
    while(curIndex < p.size() - 1)
    {
      int farthestIndex = curIndex + 1;
      
      for(int i = curIndex + 1; i < p.size(); i++)
      {
        float curX = p.get(curIndex)[1] * gridSize,
        curY = p.get(curIndex)[0] * gridSize,
        targetX = p.get(i)[1] * gridSize,
        targetY = p.get(i)[0] * gridSize;

        if(LoS(curX, curY, targetX, targetY)) { farthestIndex = i; }
        else { break; }
      }
      
      smoothedPath.add(p.get(farthestIndex));
      curIndex = farthestIndex;
    }
    return smoothedPath;
  }

  public void renderMob()
  {
    // also should do image(charcterTiles[i+mobType], mobX, mobY, mobSize, mobSize); here.
    // using rect() as tmp rendering object.
    noStroke();
    fill(#F72A2A);
    rect(this.mobX, this.mobY, mobSize, mobSize);
    //tmp hp bar.
    fill(255);
    textSize(14);
    text("HP: "+mobHealth, this.mobX, this.mobY - 5);
  }
  
  public boolean isDead() { return mobHealth <= 0; }
  
  public float getMobX() { return mobX; }
  public float getMobY() { return mobY; }
  public int getMobHealth() { return mobHealth; }
}
