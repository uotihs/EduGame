
public class Player
{
  private float playerX=0, playerY=0, playerSize=0;
  private float speed = 10;
  // we can consider doing acceleration to get smoother movement?
  
  public Player()
  {
    this.playerSize = gridSize;
    this.playerX = width / 2 - playerSize / 2;
    this.playerY = height / 2 - playerSize / 2;
  }
  
  public void moveUp()
  { 
    if(isTouchingPoint(width / 2, gridSize * 1.5) &&
      hasTopRoom() && mobArr.isEmpty())
    { 
      enterTopPortal();
      this.playerX = width / 2 - playerSize / 2;
      this.playerY = height - gridSize - playerSize;
      updateObsArr();
      return;
    }
    float nextY = playerY - speed;
    int nextRow = (int)(nextY / gridSize),
      leftColumn = (int)(playerX / gridSize),
      rightColumn = (int)((playerX + playerSize - 1) / gridSize);
    if(!isObstacle(nextRow, leftColumn) &&
      !isObstacle(nextRow, rightColumn)) { playerY = nextY; }
    else { playerY = nextRow * gridSize + playerSize; }
  }
  public void moveDown()
  {
    if(isTouchingPoint(width / 2, height - gridSize * 1.5) &&
      hasBottomRoom() && mobArr.isEmpty())
    { 
      enterBottomPortal();
      this.playerX = width / 2 - playerSize / 2;
      this.playerY = gridSize * 1;
      updateObsArr();
      return;
    }
    float nextY = playerY + speed;
    int nextRow = (int)((nextY + playerSize) / gridSize),
      leftColumn = (int)(playerX / gridSize),
      rightColumn = (int)((playerX + playerSize - 1) / gridSize);
    if(!isObstacle(nextRow, leftColumn) &&
      !isObstacle(nextRow, rightColumn)) { playerY = nextY; }
    else { playerY = (nextRow - 1) * gridSize; }
  }
  public void moveLeft()
  {
    if(isTouchingPoint(gridSize * 1.5, height / 2) &&
      hasLeftRoom() && mobArr.isEmpty())
    { 
      enterLeftPortal();
      this.playerX = width - gridSize - playerSize;
      this.playerY = height / 2 - playerSize / 2;
      updateObsArr();
      return;
    }
    float nextX = playerX - speed;
    int nextColumn = (int)(nextX / gridSize),
      topRow = (int)(playerY / gridSize),
      bottomRow = (int)((playerY + playerSize - 1) / gridSize);
    if(!isObstacle(topRow, nextColumn) &&
      !isObstacle(bottomRow, nextColumn)) { playerX = nextX; }
    else { playerX = nextColumn * gridSize + playerSize; }
  }
  public void moveRight()
  {
    if(isTouchingPoint(width - gridSize * 1.5, height / 2) &&
      hasRightRoom() && mobArr.isEmpty())
    { 
      enterRightPortal();
      this.playerX = gridSize * 1;
      this.playerY = height / 2 - playerSize / 2;
      updateObsArr();
      return;
    }
    float nextX = playerX + speed;
    int nextColumn = (int)((nextX + playerSize) / gridSize),
      topRow = (int)(playerY / gridSize),
      bottomRow = (int)((playerY + playerSize - 1) / gridSize);
    if(!isObstacle(topRow, nextColumn) &&
      !isObstacle(bottomRow, nextColumn)) { playerX = nextX; }
    else { playerX = (nextColumn - 1) * gridSize; }
  }

  private boolean isTouchingPoint(float pointX, float pointY)
  {
    return ((playerX < pointX) && (playerX + playerSize > pointX)
          && (playerY < pointY) && (playerY + playerSize > pointY));
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
  public float getPlayerSize() { return playerSize; }
}
