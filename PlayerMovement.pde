public class PlayerMovement
{
  private float x;
  private float y;

  private int playerWidth;
  private int playerHeight;

  private float speed;

  private boolean moveUp;
  private boolean moveDown;
  private boolean moveLeft;
  private boolean moveRight;


  public PlayerMovement(float startX, float startY)
  {
    x = startX;
    y = startY;

    playerWidth = 40;
    playerHeight = 40;

    speed = 5;

    moveUp = false;
    moveDown = false;
    moveLeft = false;
    moveRight = false;
  }


  public void Update()
  {
    if(moveUp)
    {
      y -= speed;
    }

    if(moveDown)
    {
      y += speed;
    }

    if(moveLeft)
    {
      x -= speed;
    }

    if(moveRight)
    {
      x += speed;
    }

    x = constrain(x, 0, width - playerWidth);
    y = constrain(y, 0, height - playerHeight);
  }


  public void Render()
  {
    fill(255, 0, 0);
    rect(x, y, playerWidth, playerHeight);
  }


  public void KeyPressed(char inputKey)
  {
    if(inputKey == 'w' || inputKey == 'W')
    {
      moveUp = true;
    }

    if(inputKey == 's' || inputKey == 'S')
    {
      moveDown = true;
    }

    if(inputKey == 'a' || inputKey == 'A')
    {
      moveLeft = true;
    }

    if(inputKey == 'd' || inputKey == 'D')
    {
      moveRight = true;
    }
  }


  public void KeyReleased(char inputKey)
  {
    if(inputKey == 'w' || inputKey == 'W')
    {
      moveUp = false;
    }

    if(inputKey == 's' || inputKey == 'S')
    {
      moveDown = false;
    }

    if(inputKey == 'a' || inputKey == 'A')
    {
      moveLeft = false;
    }

    if(inputKey == 'd' || inputKey == 'D')
    {
      moveRight = false;
    }
  }


  public float getX()
  {
    return x;
  }

  public float getY()
  {
    return y;
  }
}
