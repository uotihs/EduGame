public class Bullet
{
  private float bulletX=0, bulletY=0;
  private float stepX=0, stepY=0;
  private float speed=15, bulletSize=20;
  private int bulletDamage=0;
  private TargetType targetType;
  private boolean hasHit=false;

  public Bullet(float spawnX, float spawnY, float targetX, float targetY, 
    int inputDamage, TargetType inputTargetType)
  {
    this.bulletX = spawnX;
    this.bulletY = spawnY;
    this.bulletDamage = inputDamage;
  
    float d = dist(spawnX, spawnY, targetX, targetY);
    this.stepX = speed * ((targetX - spawnX) / d);
    this.stepY = speed * ((targetY - spawnY) / d);
    this.targetType = inputTargetType;
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
    if(stepX == 0 && stepY == 0) { return; }
    if(targetType == TargetType.MOBS) { damageMobs(); }
    else { damagePlayer(); }
  }
  
  private void damageMobs()
  {
    int curRow = max((int)(bulletY / gridSize) - 1, 0),
      curColumn = max((int)(bulletX / gridSize) - 1, 0);
      
    ArrayList<Mob> checkList = new ArrayList<Mob>();
    checkList.addAll(mobGridArr[curRow * columns + curColumn]);
    if(stepX != 0)
    {
      int horizontalIndex = curColumn + (int)Math.signum(stepX);
      if(horizontalIndex > 0 && horizontalIndex < columns - 1)
      {
        checkList.addAll(mobGridArr[curRow * columns + horizontalIndex]);
      }
    }
    if(stepY != 0)
    {
      int verticalIndex = curRow + (int)Math.signum(stepY);
      if(verticalIndex > 0 && verticalIndex < rows - 1)
      {
        checkList.addAll(mobGridArr[verticalIndex * columns + curColumn]);
      }
    }
    if(stepX != 0 && stepY != 0)
    {
      int horizontalIndex = curColumn + (int)Math.signum(stepX),
        verticalIndex = curRow + (int)Math.signum(stepY);
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
        println("Hit mob at ("+bulletX+", "+bulletY+")");
        hasHit = true;
        break;
      }
    }
  }
  
  private void damagePlayer()
  {
    if(isOnTrajectory(bulletX, bulletY,
        player.getPlayerX() + gridSize / 2, player.getPlayerY() + gridSize / 2))
    {
      player.addPlayerHealth(bulletDamage * -1);
      hasHit = true;
    }
  }
  
  private void obsDetection()
  {
    int curRow = (int)(bulletY / gridSize),
      curColumn = (int)(bulletX / gridSize);
    if(isObstacle(curRow, curColumn)) { hasHit = true; }
  }
  
  private boolean isOnTrajectory(float aX, float aY, float pX, float pY)
  {
    float apX = pX - aX, apY = pY - aY;
    float t = (stepX * apX + stepY * apY) / (stepX * stepX + stepY * stepY);
    if(t > 1) { return false; }
    float dX = apX - t * stepX, dY = apY - t * stepY;
    return (dX * dX + dY * dY) <= 
      (gridSize * 0.7071 + bulletSize / 2 ) * (gridSize * 0.7071 + bulletSize / 2);
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
