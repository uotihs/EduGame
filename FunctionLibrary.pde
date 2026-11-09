import java.util.Arrays;
import java.util.ArrayList;
import java.lang.IndexOutOfBoundsException;
import java.util.Comparator;

public static <T> T[] appendTo(T[] oldArr, T item)
{
  T[] newArr = Arrays.copyOf(oldArr, oldArr.length + 1);
  newArr[newArr.length-1] = item;
  return newArr;
}

public void updateObsArr()
{
  // rows * columns
  // remember this bool arr has conflict with old storing method.
  obsArr = new boolean[rows * columns];
  for(ObstacleData obs : obsData[currentRow][currentColumn])
  {
    obsArr[(obs.getObsRow() - 1) * columns + obs.getObsColumn() - 1] = true;
  }
}

public boolean isObstacle(int thisRow, int thisColumn)
{
  //Subtract 1 to solve the conflict.
  thisRow -= 1;
  thisColumn -= 1;
  if(thisRow < 0 || thisRow > rows - 1 ||
    thisColumn < 0 || thisColumn > columns - 1) { return true; }
  else { return obsArr[thisRow * columns + thisColumn]; }
}

public void updateMobsArray()
{
  mobArr = new ArrayList<Mob> ();
  for(MobData thisMobData: mobData[currentRow][currentColumn])
  {
    mobArr.add(new Mob(thisMobData));
  }
}

public void clearDeadMobs()
{
  mobArr.removeIf(mob -> mob.isDead());
}

public void renderMobs()
{
  int d=0;
  for(Mob thisMob: mobArr)
  {
    thisMob.renderMob();
    float thisTargetRow = thisMob.path.get(0)[0],
      thisTargetColumn = thisMob.path.get(0)[1];
    text("mobX: "+thisMob.getMobX()+" mobY: "+thisMob.getMobY()+" hp: "+thisMob.getMobHealth()
      +"\nTargetRC: ("+thisTargetRow+", "+thisTargetColumn+")", 300, d * 100 + 300);
    d += 1;
  }
}
  
public void initializeImages()
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
        ": Row: "+ thisMob.getMobRow() +
        ", Column: "+ thisMob.getMobColumn() +
        ", Health: "+ thisMob.getMobHealth(), 60, 150+i*25);
  }
  for(int i=0; i < obsData[currentRow][currentColumn].length; i++)
  {
    ObstacleData thisObs = obsData[currentRow][currentColumn][i];
    text(i +
        ": Row: "+ thisObs.getObsRow() +
        ", Column: "+ thisObs.getObsColumn() +
        ", Type: "+ thisObs.getObsType(), 430, 150+i*25); 
  }
}

public boolean hasTopRoom()
{
  boolean topRoomExist = true;
  try { if(roomDisData[currentRow - 1][currentColumn] == -1) { topRoomExist = false; } }
  catch(IndexOutOfBoundsException e) { topRoomExist = false; }
  return topRoomExist;
}

public boolean hasBottomRoom()
{
  boolean bottomRoomExist = true;
  try { if(roomDisData[currentRow + 1][currentColumn] == -1) { bottomRoomExist = false; } }
  catch(IndexOutOfBoundsException e) { bottomRoomExist = false; }
  return bottomRoomExist;
}

public boolean hasLeftRoom()
{
  boolean leftRoomExist = true;
  try { if(roomDisData[currentRow][currentColumn - 1] == -1) { leftRoomExist = false; } }
  catch(IndexOutOfBoundsException e) { leftRoomExist = false; }
  return leftRoomExist;
}

public boolean hasRightRoom()
{
  boolean rightRoomExist = true;
  try { if(roomDisData[currentRow][currentColumn + 1] == -1) { rightRoomExist = false; } }
  catch(IndexOutOfBoundsException e) { rightRoomExist = false; }
  return rightRoomExist;
}

public void renderBackground()
{
  image(backgroundImage, 0, 0, width, height);
}

public void renderDoors()
{
  if(mobArr.isEmpty())
  {
    if(hasTopRoom()) {image(tiles[1], gridSize * 5, 0, gridSize, gridSize); }
    if(hasBottomRoom()) { image(tiles[3], gridSize * 5, height - gridSize, gridSize, gridSize); }
    if(hasLeftRoom()) { image(tiles[5], 0, gridSize * 4, gridSize, gridSize); }
    if(hasRightRoom()) { image(tiles[7], width - gridSize, gridSize * 4, gridSize, gridSize); } 
  }
  else
  {
    if(hasTopRoom()) {image(tiles[0], gridSize * 5, 0, gridSize, gridSize); }
    if(hasBottomRoom()) { image(tiles[2], gridSize * 5, height - gridSize, gridSize, gridSize); }
    if(hasLeftRoom()) { image(tiles[4], 0, gridSize * 4, gridSize, gridSize); }
    if(hasRightRoom()) { image(tiles[6], width - gridSize, gridSize * 4, gridSize, gridSize); }
  }
}

public void renderObstacles()
{
  ObstacleData[] thisObsArray = obsData[currentRow][currentColumn];
  
  for(int i=0; i < thisObsArray.length; i++)
  {
    float thisX = thisObsArray[i].getObsColumn() * gridSize;
    float thisY = thisObsArray[i].getObsRow() * gridSize;
    int thisType = thisObsArray[i].getObsType() + 8;
    image(tiles[thisType], thisX, thisY, gridSize, gridSize);
  }
}

public void enterTopPortal()
{
  if(hasTopRoom())
  { 
    currentRow -= 1;
    updateMobsArray();
  }
}
public void enterBottomPortal()
{
  if(hasBottomRoom())
  { 
    currentRow += 1;
    updateMobsArray();
  }
}
public void enterLeftPortal()
{
  if(hasLeftRoom())
  { 
    currentColumn -= 1;
    updateMobsArray();
  }
}
public void enterRightPortal()
{
  if(hasRightRoom())
  { 
    currentColumn += 1;
    updateMobsArray();
  }
}
