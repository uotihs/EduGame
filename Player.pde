
public class Player
{
  private float playerX=0, playerY=0, playerSize=0;
  private float speed = 10;
  private int playerHealth = 0;
  private final int maxPlayerHealth = 100;
  private int preRow = 0, preColumn = 0, distLimit = 3;
  private int playerAmmos = 0, reloadTimer = 0, hitTimer = 0;
  private boolean isReloading = false;
  private final int maxAmmos = 6, reloadDuration = 35;
  // we can consider doing acceleration to get smoother movement?
  
  public Player()
  {
    this.playerSize = gridSize;
    this.playerX = (width - playerSize) / 2;
    this.playerY = (height - playerSize) / 2;
    this.preRow = (int)((playerY + playerSize / 2) / gridSize);
    this.preColumn = (int)((playerX + playerSize / 2) / gridSize);
    playerHealth = maxPlayerHealth;
    playerAmmos = maxAmmos;
    reloadTimer = reloadDuration;
  }
  
  public void move()
  {
    if(up) { player.moveUp(); }
    if(down) { player.moveDown(); }
    if(left) { player.moveLeft(); }
    if(right) { player.moveRight(); }
  }
  
  public void moveUp()
  { 
    if(isTouchingPoint(width / 2, gridSize * 1.5) &&
      hasTopRoom() && mobArr.isEmpty() && legMob == null)
    { 
      startRoomTransition(TransDir.TUP);
      updateMobsPath();
      return;
    }
    float nextY = playerY - speed;
    int nextRow = (int)(nextY / gridSize),
      leftColumn = (int)(playerX / gridSize),
      rightColumn = (int)((playerX + playerSize - 1) / gridSize);
    boolean leftBlocked = isObstacle(nextRow, leftColumn),
      rightBlocked = isObstacle(nextRow, rightColumn);
    if(!leftBlocked && !rightBlocked)
    {
      playerY = nextY;
      checkManhaDist();
    }
    else
    {
      playerY = nextRow * gridSize + playerSize;
      float tolerance = speed / 2 + 1;
      if(abs(playerX - leftColumn * gridSize) <= tolerance
        || abs(playerX + playerSize - rightColumn * gridSize) <= tolerance)
      {
        playerX = leftColumn * gridSize;
      }
    }
  }
  public void moveDown()
  {
    if(isTouchingPoint(width / 2, height - gridSize * 1.5) &&
      hasBottomRoom() && mobArr.isEmpty() && legMob == null)
    { 
      startRoomTransition(TransDir.TDOWN);
      updateMobsPath();
      return;
    }
    float nextY = playerY + speed;
    int nextRow = (int)((nextY + playerSize) / gridSize),
      leftColumn = (int)(playerX / gridSize),
      rightColumn = (int)((playerX + playerSize - 1) / gridSize);
    if(!isObstacle(nextRow, leftColumn) &&
      !isObstacle(nextRow, rightColumn))
    {
      playerY = nextY;
      checkManhaDist();
    }
    else
    {
      playerY = (nextRow - 1) * gridSize;
      float tolerance = speed / 2 + 1;
      if(abs(playerX - leftColumn * gridSize) <= tolerance
        || abs(playerX + playerSize - rightColumn * gridSize) <= tolerance)
      {
        playerX = leftColumn * gridSize;
      } 
    }
  }
  public void moveLeft()
  {
    if(isTouchingPoint(gridSize * 1.5, height / 2) &&
      hasLeftRoom() && mobArr.isEmpty() && legMob == null)
    { 
      startRoomTransition(TransDir.TLEFT);
      updateMobsPath();
      return;
    }
    float nextX = playerX - speed;
    int nextColumn = (int)(nextX / gridSize),
      topRow = (int)(playerY / gridSize),
      bottomRow = (int)((playerY + playerSize - 1) / gridSize);
    if(!isObstacle(topRow, nextColumn) &&
      !isObstacle(bottomRow, nextColumn))
    {
      playerX = nextX;
      checkManhaDist();
    }
    else { playerX = nextColumn * gridSize + playerSize; }
  }
  public void moveRight()
  {
    if(isTouchingPoint(width - gridSize * 1.5, height / 2) &&
      hasRightRoom() && mobArr.isEmpty() && legMob == null)
    { 
      startRoomTransition(TransDir.TRIGHT);
      updateMobsPath();
      return;
    }
    float nextX = playerX + speed;
    int nextColumn = (int)((nextX + playerSize) / gridSize),
      topRow = (int)(playerY / gridSize),
      bottomRow = (int)((playerY + playerSize - 1) / gridSize);
    if(!isObstacle(topRow, nextColumn) &&
      !isObstacle(bottomRow, nextColumn))
    {
      playerX = nextX;
      checkManhaDist();
    }
    else { playerX = (nextColumn - 1) * gridSize; }
  }
  
  private void checkManhaDist()
  {
    int curRow = (int)((playerY + playerSize / 2) / gridSize),
      curColumn = (int)((playerX + playerSize / 2) / gridSize);
    int manhaDist = abs(curRow - preRow) + abs(curColumn - preColumn);
    if(manhaDist >= distLimit)
    {
      updateMobsPath();
      preRow = curRow;
      preColumn = curColumn;
    }
  }
  
  private boolean isTouchingPoint(float pointX, float pointY)
  {
    return ((playerX < pointX) && (playerX + playerSize > pointX)
          && (playerY < pointY) && (playerY + playerSize > pointY));
  }
  
  public void updateMobsPath()
  {
    for(Mob mob: mobArr)
    {
      if(!mob.canSeePlayer()) { mob.resetPath(); }
    }
  }
  
  public void shoot()
  {
    if(isShooting)
    { 
      if(playerAmmos > 0)
      {
        bulletArr.add(
          new Bullet(playerX + playerSize / 2, playerY + playerSize / 2,
          mouseX - 15, mouseY - 15, 10, 0, TargetType.MOBS));
        playerAmmos -= 1;
        if(playerAmmos <= 0) { isReloading = true; }
      }
      isShooting = false;
    }
  }
  
  public void updateReloadTimer()
  {
    if(isReloading)
    {
      reloadTimer -= 1;
      playerAmmos = 0;
      if(reloadTimer == 0)
      {
        playerAmmos = maxAmmos;
        reloadTimer = reloadDuration;
        isReloading = false;
      }
    }
  }
  
  public void renderPlayer()
  {
    noStroke();
    image(playerImage, playerX, playerY, playerSize, playerSize);
    if(hitTimer > 0)
    {
      blendMode(SUBTRACT);
      if(hitTimer > 6) { tint(#0B8AA2); }
      else { tint(#101F64); }
      image(playerImage, playerX, playerY, playerSize, playerSize);
      noTint();
      blendMode(BLEND);
    }
    displayHealthPointBar();
    displayAmmosBar();
  }
  
  private void displayHealthPointBar()
  {
    fill(#204D17);
    rect(playerX - 5, playerY - gridSize / 5 - 17,
      gridSize + 10, gridSize / 5);
    fill(#2EDB09);
    rect(playerX, playerY - gridSize / 5 - 13,
      gridSize * ((float)playerHealth / maxPlayerHealth), gridSize / 10);
  }
  private void displayAmmosBar()
  {
    fill(#E8B125);
    float barThickness = gridSize / 20;
    rect(playerX + 5, playerY - barThickness - 7,
      gridSize - 10, barThickness);
    rect(playerX + 5, playerY - barThickness - 10,
      barThickness, barThickness * 2.5);
    rect(playerX + gridSize - 8, playerY - barThickness - 10,
      barThickness, barThickness * 2.5);
    fill(#FAD605);
    if(isReloading)
    {
      rect(playerX + 7 + (gridSize - 17) * ((reloadDuration - reloadTimer) / (float)reloadDuration), 
        playerY - barThickness - 10, barThickness, barThickness * 2.5);
    }
    else
    {
      rect(playerX + 9, playerY - barThickness - 9,
        (gridSize - 17) * ((float)playerAmmos / maxAmmos), barThickness * 2);
    }
  }
  
  public boolean isDead() { return playerHealth <= 0; }
  
  public float getPlayerX() { return playerX; }
  public float getPlayerY() { return playerY; }
  public float getPlayerSize() { return playerSize; }
  
  public void setPlayerX(float inputValue) { this.playerX = inputValue; }
  public void setPlayerY(float inputValue) { this.playerY = inputValue; }
  public void gotHit()
  {
    if(hitTimer == 0) { hitTimer = 10; }
  }
  public void updateHitTimer() { hitTimer = max(hitTimer - 1, 0); }
  public void reload()
  {
    if(playerAmmos != maxAmmos)
    {
      this.isReloading = true;
    }
  }
  public void addPlayerHealth(int inputValue)
  {
    if(hitTimer == 0)
    {
      this.playerHealth = min(max(playerHealth + inputValue, 0), maxPlayerHealth);
    }
  }
}
