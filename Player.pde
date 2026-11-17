
public class Player
{
  private float playerX=0, playerY=0, playerSize=0;
  private float speed = 10;
  private int playerHealth = 0;
  private final int maxPlayerHealth = 100;
  private int preRow = 0, preColumn = 0, distLimit = 3;
  private int playerAmmos = 0, reloadTimer = 0;
  private boolean isReloading = false;
  // we can consider doing acceleration to get smoother movement?
  
  public Player()
  {
    this.playerSize = gridSize;
    centeringPlayer();
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
      hasTopRoom() && mobArr.isEmpty())
    { 
      enterTopPortal();
      if(isTeleportRoom())
      {
        centeringPlayer();
        teleportToSpawn();
      }
      else
      {
        this.playerX = width / 2 - playerSize / 2;
        this.playerY = height - gridSize - playerSize;
      }
      updateMobsPath();
      return;
    }
    float nextY = playerY - speed;
    int nextRow = (int)(nextY / gridSize),
      leftColumn = (int)(playerX / gridSize),
      rightColumn = (int)((playerX + playerSize - 1) / gridSize);
    if(!isObstacle(nextRow, leftColumn) &&
      !isObstacle(nextRow, rightColumn))
    {
      playerY = nextY;
      checkManhaDist();
    }
    else { playerY = nextRow * gridSize + playerSize; }
  }
  public void moveDown()
  {
    if(isTouchingPoint(width / 2, height - gridSize * 1.5) &&
      hasBottomRoom() && mobArr.isEmpty())
    { 
      enterBottomPortal();
      if(isTeleportRoom())
      {
        centeringPlayer();
        teleportToSpawn();
      }
      else
      {
        this.playerX = width / 2 - playerSize / 2;
        this.playerY = gridSize * 1;
      }
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
    else { playerY = (nextRow - 1) * gridSize; }
  }
  public void moveLeft()
  {
    if(isTouchingPoint(gridSize * 1.5, height / 2) &&
      hasLeftRoom() && mobArr.isEmpty())
    { 
      enterLeftPortal();
      if(isTeleportRoom())
      {
        centeringPlayer();
        teleportToSpawn();
      }
      else
      {
        this.playerX = width - gridSize - playerSize;
        this.playerY = height / 2 - playerSize / 2;
      }
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
      hasRightRoom() && mobArr.isEmpty())
    { 
      enterRightPortal();
      if(isTeleportRoom())
      {
        centeringPlayer();
        teleportToSpawn();
      }
      else
      {
        this.playerX = gridSize * 1;
        this.playerY = height / 2 - playerSize / 2;
      }
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
    if(shooting)
    { 
      if(playerAmmos > 0)
      {
        bulletArr.add(
          new Bullet(playerX + playerSize / 2, playerY + playerSize / 2, 
          mouseX, mouseY, 10, TargetType.MOBS));
        playerAmmos -= 1;
        if(playerAmmos <= 0) { isReloading = true; }
      }
      shooting = false;
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
    // should do image(charcterTiles[i], playerX, playerY, playerSize, playerSize); here.
    // using rect() as tmp rendering object. 
    noStroke();
    fill(#F72A2A);
    rect(playerX, playerY, playerSize, playerSize);
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
  
  public void reload()
  {
    if(playerAmmos != maxAmmos)
    {
      this.isReloading = true;
    }
  }
  public void centeringPlayer()
  {
    this.playerX = width / 2 - playerSize / 2;
    this.playerY = height / 2 - playerSize / 2;
  }
  public void addPlayerHealth(int inputValue)
  {
    this.playerHealth = min(max(playerHealth + inputValue, 0), maxPlayerHealth);
  }
}
