import java.util.Arrays;
import java.lang.IndexOutOfBoundsException;

public static <T> T[] AppendTo(T[] oldArr, T item)
{
  T[] newArr = Arrays.copyOf(oldArr, oldArr.length + 1);
  newArr[newArr.length-1] = item;
  return newArr;
}

public void InitializeImages()
{
  backgroundImage = loadImage("images/background.png");
  
  PImage spritesheet = loadImage("images/spritesheet.png");
  int tileSize = 128;
  for(int i=0; i < tiles.length; i++)
  {
    tiles[i] = spritesheet.get(tileSize * i, 0, tileSize, tileSize); 
  }
}

public void tmpPrintRoomDisData()
{
  for(int i=0; i < roomDisData.length; i++)
  {
    for(int j=0; j < roomDisData[i].length; j++)
    {
      System.out.print(roomDisData[i][j]+" ");
    }
    System.out.print("\n");
  }
}

public void tmpDisplayRoomInformation()
{
  fill(#FFFFFF);
  textSize(35);
  text("Current Row: "+currentRow+"; Current Column: "+currentColumn
      +"; RoomValue: "+roomDisData[currentRow][currentColumn], 35, 100);
  textSize(20);
  for(int i=0; i < mobData[currentRow][currentColumn].length; i++)
  {
    MobData thisMob = mobData[currentRow][currentColumn][i];
    text(i +
        ": SpawnX: "+ thisMob.spawnX +
        ", SpawnY: "+ thisMob.spawnY +
        ", Health: "+ thisMob.health, 60, 150+i*25);
  }
  for(int i=0; i < obsData[currentRow][currentColumn].length; i++)
  {
    ObstacleData thisObs = obsData[currentRow][currentColumn][i];
    text(i +
        ": LocX: "+ thisObs.x +
        ", LocY: "+ thisObs.y +
        ", Type: "+ thisObs.type, 430, 150+i*25); 
  }
}

public void RenderBackground()
{
  image(backgroundImage, 0, 0, width, height);
  
  boolean topRoomExist = true, bottomRoomExist = true, 
          leftRoomExist = true, rightRoomExist = true;
  try { if(roomDisData[currentRow - 1][currentColumn] == -1) { topRoomExist = false; } }
  catch(IndexOutOfBoundsException e) { topRoomExist = false; }
  try { if(roomDisData[currentRow + 1][currentColumn] == -1) { bottomRoomExist = false; } }
  catch(IndexOutOfBoundsException e) { bottomRoomExist = false; }
  try { if(roomDisData[currentRow][currentColumn - 1] == -1) { leftRoomExist = false; } }
  catch(IndexOutOfBoundsException e) { leftRoomExist = false; }
  try { if(roomDisData[currentRow][currentColumn + 1] == -1) { rightRoomExist = false; } }
  catch(IndexOutOfBoundsException e) { rightRoomExist = false; }
  
  int gridSize = width / 11;
  if(topRoomExist) { image(tiles[0], gridSize * 5, 0, gridSize, gridSize); }
  if(bottomRoomExist) { image(tiles[2], gridSize * 5, height - gridSize, gridSize, gridSize); }
  if(leftRoomExist) { image(tiles[4], 0, gridSize * 4, gridSize, gridSize); }
  if(rightRoomExist) { image(tiles[6], width - gridSize, gridSize * 4, gridSize, gridSize); }
}

public void RenderObstacle()
{
  ObstacleData[] thisObsArray = obsData[currentRow][currentColumn];
  
  int gridSize = width / 11;
  for(int i=0; i < thisObsArray.length; i++)
  {
    int thisX = thisObsArray[i].getX();
    int thisY = thisObsArray[i].getY();
    int thisType = thisObsArray[i].getType() + 8;
    image(tiles[thisType], gridSize * thisX, gridSize * thisY, gridSize, gridSize);
  }
}

public void EnterTopPortal()
{
  fill(#FFFFFF);
  textSize(50);
  try
  {
    if(roomDisData[currentRow - 1][currentColumn] == -1)
    { 
      text("Top room doesn't exist.", 120, 400); 
    }
    else { currentRow -= 1; }
  }
  catch(IndexOutOfBoundsException e)
  {
    text("Top room doesn't exist.", 120, 400);
  }
}

public void EnterBottomPortal()
{
  fill(#FFFFFF);
  textSize(50);
  try
  {
    if(roomDisData[currentRow + 1][currentColumn] == -1) 
    { 
      text("Bottom room doesn't exist.", 120, 400); 
    }
    else { currentRow += 1; }
  }
  catch(IndexOutOfBoundsException e)
  {
    text("Bottom room doesn't exist.", 120, 400);
  }
}

public void EnterLeftPortal()
{
  fill(#FFFFFF);
  textSize(50);
  try
  {
    if(roomDisData[currentRow][currentColumn - 1] == -1)
    { 
      text("Left room doesn't exist.", 120, 400); 
    }
    else { currentColumn -= 1; }
  }
  catch(IndexOutOfBoundsException e)
  {
    text("Left room doesn't exist.", 120, 400);
  }
}

public void EnterRightPortal()
{
  fill(#FFFFFF);
  textSize(50);
  try
  {
    if(roomDisData[currentRow][currentColumn + 1] == -1)
    { 
      text("Right room doesn't exist.", 120, 400); 
    }
    else { currentColumn += 1; }
  }
  catch(IndexOutOfBoundsException e)
  {
    text("Right room doesn't exist.", 120, 400);
  }
}
