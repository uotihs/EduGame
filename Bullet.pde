public class Bullet
{
  private float bulletX = 0, bulletY = 0;
  private float stepX = 0, stepY = 0, stepAngle = 0;
  private float speed = 15, bulletSize = 30;
  private int bulletDamage = 0, bulletType = 0, shiningStage = 0;
  private TargetType targetType;
  private HitResult hasHit = HitResult.NOT_HIT;

  public Bullet(float spawnX, float spawnY, float targetX, float targetY, 
    int inputDamage, int inputBulletType, TargetType inputTargetType)
  {
    this.bulletX = spawnX;
    this.bulletY = spawnY;
    this.bulletDamage = inputDamage;
  
    float d = dist(spawnX, spawnY, targetX, targetY);
    this.stepX = speed * ((targetX - spawnX) / d);
    this.stepY = speed * ((targetY - spawnY) / d);
    this.stepAngle = atan2(stepY, stepX);
    this.bulletType = inputBulletType;
    this.targetType = inputTargetType;
  }

  public void move()
  {
    if(bulletX  + stepX < gridSize || bulletX + stepX > width - gridSize
      || bulletY + stepY < gridSize || bulletY + stepY > height - gridSize)
    {
      hasHit = HitResult.HIT_OBS;
      return;
    }
    obsDetection();
    damageTargets();
    bulletX += stepX;
    bulletY += stepY;
  }
  
  private void damageTargets()
  {
    if((stepX == 0 && stepY == 0) || hasHitObject()) { return; }
    if(targetType == TargetType.MOBS) { damageMobs(); }
    else { damagePlayer(); }
  }
  
  private void damageMobs()
  {
    int curRow = max((int)(bulletY / gridSize) - 1, 0),
      curColumn = max((int)(bulletX / gridSize) - 1, 0);
      
    ArrayList<Mob> checkList = new ArrayList<Mob>();
    if(legMob != null) { checkList.add(legMob); }
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
      if(isOnTrajectory(bulletX + bulletSize / 2, bulletY + bulletSize / 2,
        mob.getMobX() + gridSize / 2, mob.getMobY() + gridSize / 2))
      {
          mob.addMobHealth(bulletDamage * -1);
          mob.gotHit();
          hasHit = HitResult.HIT_TARGET;
          break;
      }
    }
  }
  
  private void damagePlayer()
  {
    if(isOnTrajectory(bulletX + bulletSize / 2, bulletY + bulletSize / 2,
        player.getPlayerX() + gridSize / 2, player.getPlayerY() + gridSize / 2))
    {
      player.addPlayerHealth(bulletDamage * -1);
      player.gotHit();
      hasHit = HitResult.HIT_TARGET;
    }
  }
  
  private void obsDetection()
  {
    int curRow = (int)((bulletY + bulletSize / 2) / gridSize),
      curColumn = (int)((bulletX + bulletSize / 2) / gridSize);
    if(isObstacle(curRow, curColumn)) { hasHit = HitResult.HIT_OBS; }
  }
  
  private boolean isOnTrajectory(float aX, float aY, float pX, float pY)
  {
    float apX = pX - aX, apY = pY - aY;
    float t = (stepX * apX + stepY * apY) / (stepX * stepX + stepY * stepY);
    if(t < 0 || t > 1) { return false; }
    float dX = apX - t * stepX, dY = apY - t * stepY;
    return (dX * dX + dY * dY) <= 
      (gridSize * 0.7071 + bulletSize / 2 ) * (gridSize * 0.7071 + bulletSize / 2);
  }

  public void renderBullet()
  {
    if(hasHitObject()) { return; }
    fill(255, 230, 0); 
    noStroke();
    pushMatrix();
    translate(bulletX, bulletY);
    rotate(stepAngle);
    PImage thisImage;
    if(shiningStage < 4) { thisImage = bulletImages[bulletType * 2]; }
    else { thisImage = bulletImages[bulletType * 2 + 1]; }
    image(thisImage, 0, 0, bulletSize, bulletSize);
    blendMode(ADD);
    image(thisImage, 0, 0, bulletSize, bulletSize);
    blendMode(BLEND);
    popMatrix();
  }
  
  public float getBulletX() { return bulletX; }
  public float getBulletY() { return bulletY; }
  public TargetType getTargetType() { return targetType; }
  public float getBulletAngle() { return atan2(stepY, stepX);}
  public HitResult getHasHit() { return hasHit; }
  public boolean hasHitObject()
  {
    return hasHit == HitResult.HIT_OBS || hasHit == HitResult.HIT_TARGET;
  }
  
  public void updateShiningStage()
  {
    shiningStage += 1;
    if(shiningStage >= 8) shiningStage = 0;
  }
}
