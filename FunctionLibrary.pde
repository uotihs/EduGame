import java.util.Arrays;
import java.util.ArrayList;
import java.lang.IndexOutOfBoundsException;
import java.util.Comparator;
import java.util.Random;

public final int[] U = {-1, 0}, D = {1, 0}, L = {0, -1}, R = {0, 1};

public final int[][][] directions =
  {{U, D, L, R}, {U, D, R, L}, {U, L, D, R}, {U, L, R, D}, {U, R, D, L}, {U, R, L, D},
  {D, U, L, R}, {D, U, R, L}, {D, L, U, R}, {D, L, R, U}, {D, R, U, L}, {D, R, L, U},
  {L, U, D, R}, {L, U, R, D}, {L, D, U, R}, {L, D, R, U}, {L, R, U, D}, {L, R, D, U},
  {R, U, D, L}, {R, U, L, D}, {R, D, U, L}, {R, D, L, U}, {R, L, U, D}, {R, L, D, U}};

enum TargetType {PLAYER, MOBS};

public static <T> T[] appendTo(T[] oldArr, T item)
{
  T[] newArr = Arrays.copyOf(oldArr, oldArr.length + 1);
  newArr[newArr.length-1] = item;
  return newArr;
}

public void updateDirection(boolean inputValue)
{
  if((keyCode == 87) || (keyCode == 38)) { up = inputValue; }
  if((keyCode == 83) || (keyCode == 40)) { down = inputValue; } 
  if((keyCode == 65) || (keyCode == 37)) { left = inputValue; }
  if((keyCode == 68) || (keyCode == 39)) { right = inputValue; }
  if(keyCode == 82) { player.reload(); }
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

public void updateMobsGridArray()
{
  mobGridArr = new ArrayList[rows * columns];
  for(int i = 0; i < mobGridArr.length; i++) { mobGridArr[i] = new ArrayList<Mob>(); }
  for(Mob mob: mobArr)
  {
    int mobRow = max((int)((mob.getMobY() + gridSize / 2) / gridSize) - 1, 0),
       mobColumn = max((int)((mob.getMobX() + gridSize / 2) / gridSize) - 1, 0);
    mobGridArr[mobRow * columns + mobColumn].add(mob);
  }
}

public void updateMobsArray()
{
  mobArr = new ArrayList<Mob> ();
  MobData[] thisMobsData = mobData[currentRow][currentColumn];
  if(thisMobsData != null)
  {
    for(MobData thisMobData: thisMobsData)
    {
      mobArr.add(new Mob(thisMobData));
    }
  }
  clearDeadMobs();
}

public void clearDeadMobs()
{
  if(mobArr.size() != 0)
  {
    mobArr.removeIf(mob -> 
    {
      if(mob.isDead())
      {
        int curMobRow = max((int)((mob.getMobY() + gridSize / 2) / gridSize) - 1, 0),
          curMobColumn = max((int)((mob.getMobX() + gridSize / 2) / gridSize) - 1, 0);
        mobGridArr[curMobRow * columns + curMobColumn].remove(mob);
        return true;
      }
      return false;
    });
    if(mobArr.size() == 0) { roomCleared(); }
  }
}

public void roomCleared()
{
  mobData[currentRow][currentColumn] = null;
  player.addPlayerHealth(20);
}

public void clearHitBullets()
{
  bulletArr.removeIf(bullet -> bullet.hasHitObject());
}

public void mobsMove()
{
  for(Mob thisMob: mobArr)
  {
    thisMob.move();
    if(!thisMob.isInSameGrid())
    {
      int preMobRow = thisMob.getPreRow(),
        preMobColumn = thisMob.getPreColumn(),
        curMobRow = max((int)((thisMob.getMobY() + gridSize / 2) / gridSize) - 1, 0),
        curMobColumn = max((int)((thisMob.getMobX() + gridSize / 2) / gridSize) - 1, 0);
      mobGridArr[preMobRow * columns + preMobColumn].remove(thisMob);
      mobGridArr[curMobRow * columns + curMobColumn].add(thisMob);
      thisMob.updateRC();
    }
    thisMob.addAttackCooldown(-1);
  }
}

public void renderMobs()
{
  //int d=0;
  for(Mob thisMob: mobArr)
  {
    thisMob.renderMob();
    /*
    float thisTargetRow = thisMob.path.get(0)[0],
      thisTargetColumn = thisMob.path.get(0)[1];
    text("mobX: "+thisMob.getMobX()+" mobY: "+thisMob.getMobY()+" hp: "+thisMob.getMobHealth()
      +"\nTargetRC: ("+thisTargetRow+", "+thisTargetColumn+")", 300, d * 100 + 300);
    d += 1; */
  }
}

public void updateBulletsArray()
{
  bulletArr.clear(); 
}

public void bulletsMove()
{
  for(Bullet thisBullet: bulletArr)
  {
    thisBullet.move();
  }
}

public void renderBullets()
{
   for(Bullet thisBullet: bulletArr)
   {
     thisBullet.renderBullet(); 
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
  
  for(int i=0; i < weaponImgs.length; i++)
  {
    weaponImgs[i] = loadImage("images/weapon_lv" + (i + 1) + ".png");
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
  if(mobData[currentRow][currentColumn] != null)
  {
    for(int i=0; i < mobData[currentRow][currentColumn].length; i++)
    {
      MobData thisMob = mobData[currentRow][currentColumn][i];
      text(i +
          ": Row: "+ thisMob.getMobRow() +
          ", Column: "+ thisMob.getMobColumn() +
          ", Health: "+ thisMob.getMobHealth(), 60, 150+i*25);
    }
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
  if(currentRow - 1 < 0) { return false; }
  else if(roomDisData[currentRow - 1][currentColumn] == -1
    || (roomDisData[currentRow - 1][currentColumn] == 67 
    && roomDisData[currentRow][currentColumn] % 10 != 3)) { return false; }
  return true;
}

public boolean hasBottomRoom()
{
  if(currentRow + 1 > 4) { return false; }
  else if(roomDisData[currentRow + 1][currentColumn] == -1
    || (roomDisData[currentRow + 1][currentColumn] == 67 
    && roomDisData[currentRow][currentColumn] % 10 != 3)) { return false; }
  return true;
}

public boolean hasLeftRoom()
{
  if(currentColumn - 1 < 0) { return false; }
  else if(roomDisData[currentRow][currentColumn - 1] == -1
    || (roomDisData[currentRow][currentColumn - 1] == 67 
    && roomDisData[currentRow][currentColumn] % 10 != 3)) { return false; }
  return true;
}

public boolean hasRightRoom()
{
  if(currentColumn + 1 > 4) { return false; }
  else if(roomDisData[currentRow][currentColumn + 1] == -1
    || (roomDisData[currentRow][currentColumn + 1] == 67 
    && roomDisData[currentRow][currentColumn] % 10 != 3)) { return false; }
  return true;
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

public boolean isTeleportRoom() { return roomDisData[currentRow][currentColumn] == 67; }

public void teleportToSpawn()
{
  currentRow = 2;
  currentColumn = 2;
  updateAllArrays();
}

public void enterTopPortal()
{
  if(hasTopRoom())
  { 
    currentRow -= 1;
    updateAllArrays();
  }
}
public void enterBottomPortal()
{
  if(hasBottomRoom())
  { 
    currentRow += 1;
    updateAllArrays();
  }
}
public void enterLeftPortal()
{
  if(hasLeftRoom())
  { 
    currentColumn -= 1;
    updateAllArrays();
  }
}
public void enterRightPortal()
{
  if(hasRightRoom())
  { 
    currentColumn += 1;
    updateAllArrays();
  }
}

public void updateAllArrays()
{
  updateObsArr();
  updateMobsArray();
  updateMobsGridArray();
  updateBulletsArray();
}