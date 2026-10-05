
public class Player
{
  private float playerX=0, playerY=0;
  private float playerSize=0;
  private float speed = 10;
  
  public Player()
  {
    this.playerX = width / 2;
    this.playerY = height / 2;
    
    this.playerSize = gridSize;
  }
  
  public void moveUp()
  { 
    float nextPlayerY = playerY - speed;
    if(isTouchingPoint(width / 2, gridSize * 1.5))
    { 
      enterTopPortal();
      this.playerY = height - gridSize * 2;
    }
    else if(nextPlayerY < gridSize) { this.playerY = gridSize; }
    else { this.playerY = nextPlayerY; }
  }
  public void moveDown() 
  { 
    float nextPlayerY = playerY + speed;
    if(isTouchingPoint(width / 2, height - gridSize * 1.5))
    {
      enterBottomPortal();
      this.playerY = gridSize * 1;
    }
    else if(nextPlayerY > height - gridSize - playerSize) { this.playerY = height - gridSize - playerSize; }
    else { this.playerY = nextPlayerY; }
  }
  public void moveLeft() 
  { 
    float nextPlayerX = playerX - speed;
    if(isTouchingPoint(gridSize * 1.5, height / 2))
    {
      enterLeftPortal();
      this.playerX = width - gridSize * 2;
    }
    else if(nextPlayerX < gridSize) { this.playerX = gridSize; }
    else { this.playerX = nextPlayerX; }
  }
  public void moveRight() 
  { 
    float nextPlayerX = playerX + speed;
    if(isTouchingPoint(width - gridSize * 1.5, height / 2))
    {
      enterRightPortal();
      this.playerX = gridSize * 1; 
    }
    else if(nextPlayerX > width - gridSize - playerSize) { this.playerX = width - gridSize - playerSize; }
    else { this.playerX = nextPlayerX; } 
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
}
