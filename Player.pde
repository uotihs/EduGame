
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
    if(nextPlayerY < gridSize) { this.playerY = gridSize; }
    else { this.playerY = nextPlayerY; }
  }
  public void moveDown() 
  { 
    float nextPlayerY = playerY + speed;
    if(nextPlayerY > height - gridSize - playerSize) { this.playerY = height - gridSize - playerSize; }
    else { this.playerY = nextPlayerY; }
  }
  public void moveLeft() 
  { 
    float nextPlayerX = playerX - speed;
    if(nextPlayerX < gridSize) { this.playerX = gridSize; }
    else { this.playerX = nextPlayerX; }
  }
  public void moveRight() 
  { 
    float nextPlayerX = playerX + speed;
    if(nextPlayerX > width - gridSize - playerSize) { this.playerX = width - gridSize - playerSize; }
    else { this.playerX = nextPlayerX; } 
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
