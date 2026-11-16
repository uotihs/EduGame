public class Bullet
{
  private float bulletX=0, bulletY=0;
  private float stepX=0, stepY=0;
  private float speed=5, bulletSize=8;
  private int bulletDamage=0;
  private boolean hasHit=false;

  public Bullet(float spawnX, float spawnY, float targetX, float targetY, int inputDamage)
  {
    this.bulletX = spawnX;
    this.bulletY = spawnY;
    this.bulletDamage = inputDamage;
  
    float d = dist(spawnX, spawnY, targetX, targetY);
    this.stepX = speed * ((targetX - spawnX) / d);
    this.stepY = speed * ((targetY - spawnY) / d);
  }

  private void move()
  {
    if(bulletX  + stepX < gridSize || bulletX + stepX > width - gridSize
      || bulletY + stepY < gridSize || bulletY + stepY > height - gridSize)
    {
      hasHit = true;
      return;
    }  
    damageTargets();
    obsDetection();
    bulletX += stepX;
    bulletY += stepY;
  }
  
  private void damageTargets()
  {
    int curRow = max((int)(bulletY / gridSize) - 1, 0),
      curColumn = max((int)(bulletX / gridSize) - 1, 0);
      
    ArrayList<Mob> checkList = new ArrayList<Mob>();
    checkList.addAll(mobGridArr[curRow * columns + curColumn]);
    //indexOutOfRange, check later
    if(stepX != 0)
    {
      int horizontalIndex = curColumn + (int)Math.signum(stepX) * -1;
      if(horizontalIndex > 0 && horizontalIndex < columns - 1)
      {
        checkList.addAll(mobGridArr[curRow * columns + horizontalIndex]);
      }
    }
    if(stepY != 0)
    {
      int verticalIndex = curRow + (int)Math.signum(stepY) * -1;
      if(verticalIndex > 0 && verticalIndex < rows - 1)
      {
        checkList.addAll(mobGridArr[verticalIndex * columns + curColumn]);
      }
    }
    if(stepX != 0 && stepY != 0)
    {
      int horizontalIndex = curColumn + (int)Math.signum(stepX) * -1,
        verticalIndex = curRow + (int)Math.signum(stepY) * -1;
      if(horizontalIndex > 0 && horizontalIndex < columns - 1
        && verticalIndex > 0 && verticalIndex < rows - 1)
      {
        checkList.addAll(mobGridArr[verticalIndex * columns + horizontalIndex]);
      }
    }
    
    for(Mob mob: checkList)
    {
      if(isOnTrajectory(bulletX, bulletY,
        mob.getMobX() + gridSize / 2, mob.getMobY() + gridSize / 2))
      {
        mob.addMobHealth(bulletDamage * -1);
        hasHit = true;
        break;
      }
    }
  }
  
  private void obsDetection()
  {
    int curRow = (int)(bulletY / gridSize),
      curColumn = (int)(bulletX / gridSize);
    if(isObstacle(curRow, curColumn) /*||
      isObstacle(curRow + (int)Math.signum(stepY), curColumn) ||
      isObstacle(curRow, curColumn + (int)Math.signum(stepX)) ||
      isObstacle(curRow + (int)Math.signum(stepY), curColumn + (int)Math.signum(stepX))*/)
    {
      hasHit = true;
    }
  }
  
  private boolean isOnTrajectory(float aX, float aY, float pX, float pY)
  {
    float apX = pX - aX, apY = pY - aY;
    float t = (stepX * apX + stepY * apY) / (stepX * stepX + stepY * stepY);
    if(t > 1) { return false; }
    float dX = apX - t * stepX, dY = apY - t * stepY;
    return (dX * dX + dY * dY) <= (gridSize * 0.7071) * (gridSize * 0.7071);
  }

  public void renderBullet()
  {
    if(hasHit) { return; }
    fill(255, 230, 0); 
    noStroke();
    ellipse(bulletX, bulletY, bulletSize, bulletSize);
  }
  
  public boolean hasHitObject() { return hasHit; }
}
