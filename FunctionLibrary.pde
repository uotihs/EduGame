import java.util.Arrays;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.Random;

public final int[] U = {-1, 0}, D = {1, 0}, L = {0, -1}, R = {0, 1};

public final int[][][] directions =
  {{U, D, L, R}, {U, D, R, L}, {U, L, D, R}, {U, L, R, D}, {U, R, D, L}, {U, R, L, D},
  {D, U, L, R}, {D, U, R, L}, {D, L, U, R}, {D, L, R, U}, {D, R, U, L}, {D, R, L, U},
  {L, U, D, R}, {L, U, R, D}, {L, D, U, R}, {L, D, R, U}, {L, R, U, D}, {L, R, D, U},
  {R, U, D, L}, {R, U, L, D}, {R, D, U, L}, {R, D, L, U}, {R, L, U, D}, {R, L, D, U}};

public enum TargetType {PLAYER, MOBS};
public enum TransDir {TUP, TDOWN, TLEFT, TRIGHT};
public enum HitResult {NOT_HIT, HIT_OBS, HIT_TARGET}

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
  if(keyCode == 82 && !isPaused) { player.reload(); }
  if(keyCode == 69 && inputValue && transitionTimer <= 0 && !player.isDead())
  {
    if(isPaused) { isPaused = false; }
    else { isPaused = true; } 
  }
}

public void renderMask()
{
  fill(227, 189, 85, 70);
  rect(0, 0, width, height);
}

public void renderRoomTransition()
{
  fill(#061D43);
  float outerR = dist(0, 0, (float)rows / 2 + 1, (float)columns / 2 + 1);
  if(transitionTimer > 30)
  {
    donutShape(width / 2, height / 2, PI * 1.5, PI * (1.5 + (60 - transitionTimer) / 15.0),
      gridSize * 1.5, gridSize * outerR);
    circle(width / 2, height / 2, gridSize * 3 * ((60 - transitionTimer) / 30) + 2);
  }
  else
  {
    donutShape(width / 2, height / 2, PI  * (1.5 - transitionTimer / 15.0), PI * 1.5,
      gridSize * 1.5, gridSize * outerR);
    circle(width / 2, height / 2, gridSize * 3 * (transitionTimer / 30) + 2);
  }
}

public void donutShape(float centerX, float centerY,
  float startAngle, float endAngle, float innerR, float outerR)
{
  int steps = 60;
  float dAngle = (endAngle - startAngle) / steps;
  beginShape();
  for(int i = 0; i <= steps; i++)
  {
    float curAngle = startAngle + i * dAngle;
    vertex(centerX + cos(curAngle) * innerR, centerY + sin(curAngle) * innerR);
  }
  for(int i = steps; i >= 0; i--)
  {
    float curAngle = startAngle + i * dAngle;
    vertex(centerX + cos(curAngle) * outerR, centerY + sin(curAngle) * outerR); 
  }
  endShape(CLOSE);
}

public void gameOver()
{
  isPaused = true;
  // unfinished yet
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
  
  if(roomDisData[currentRow][currentColumn] % 10 == 3
    && legMob == null)
  {
    legMob = new Mob(new MobData(4, 5, 100));
    boss = new Boss();
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
      if(thisMobData.getMobHealth() > 0)
      {
        mobArr.add(new Mob(thisMobData));
      }
    }
  }
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
    if(mobArr.size() == 0 && legMob == null) { roomCleared(); }
  }
  if(legMob != null)
  {
    if(legMob.isDead())
    {
      legMob = null;
      boss = null;
      mobArr = new ArrayList<Mob> ();
      mobGridArr = new ArrayList[rows * columns];
      for(int i = 0; i < mobGridArr.length; i++) { mobGridArr[i] = new ArrayList<Mob>(); }
      bossRoomCleared();
    }
  }
}

public void roomCleared()
{
  mobData[currentRow][currentColumn] = null;
  player.addPlayerHealth(20);
  println("Normal clear");
}

public void bossRoomCleared()
{
  player.addPlayerHealth(50);
  println("Boss clear");
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
    thisMob.updateHitTimer();
    thisMob.updateStageTimer();
    thisMob.addAttackCooldown(-1);
  }
  if(legMob != null)
  {
    legMob.move();
    legMob.updateHitTimer();
    
    boss.teleportToLegMob();
    boss.updateStageTimer();
    boss.addAttackCooldown(-1);
    boss.attack();
  }
}

public void renderMobs()
{
  if(boss != null) { boss.renderBoss(); }
  for(Mob thisMob: mobArr)
  {
    thisMob.renderMob();
  }
}

public void updateBulletsArray()
{
  bulletArr.clear(); 
}

public void clearHitBullets()
{
  bulletArr.removeIf(bullet -> 
    {
      if(bullet.hasHitObject())
      {
        if(bullet.bulletType == 2 && bullet.getHasHit() == HitResult.HIT_OBS)
        {
          splitParentArr.add(bullet);
        }
        return true;
      }
      return false;
    });
}

public void addSplitBullets()
{
  for(Bullet bullet : splitParentArr)
  {
    float bX = bullet.getBulletX(), bY = bullet.getBulletY(),
      thisAngle = bullet.getBulletAngle(), spreadAngle = 0.5;
    bX -= cos(thisAngle) * 17; bY -= sin(thisAngle) * 17;
    for(int i = 0; i < 4; i++)
    {
      bulletArr.add(new Bullet(
        bX, bY, bX - cos(thisAngle + (i - 1.5) * spreadAngle),
        bY - sin(thisAngle + (i - 1.5) * spreadAngle), 10, 1, bullet.getTargetType()));
    }
  }
  splitParentArr.clear();
}

public void bulletsMove()
{
  for(Bullet thisBullet: bulletArr)
  {
    thisBullet.move();
    thisBullet.updateShiningStage();
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
  playerImage = loadImage("images/player.png");
  int tileSize = 128;
  PImage spritesheet = loadImage("images/spritesheet.png");
  PImage bullets = loadImage("images/bullets.png");
  PImage mobs = loadImage("images/mobs.png");
  for(int i=0; i < tiles.length; i++)
  {
    tiles[i] = spritesheet.get(tileSize * i, 0, tileSize, tileSize);
  }
  for(int i = 0; i < bulletImages.length; i++)
  {
    bulletImages[i] = bullets.get(tileSize * i, 0, tileSize, tileSize); 
  }
  for(int i=0; i < mobImages.length; i++)
  {
    mobImages[i] = mobs.get(tileSize * i, 0, tileSize, tileSize);
  }
  for(int i=0; i < weaponImages.length; i++)
  {
    weaponImages[i] = loadImage("images/weaponLevel" + i + ".png");
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
  if(mobArr.isEmpty() && legMob == null)
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

public void startRoomTransition(TransDir dir)
{
  if(transitionTimer > 0) return;
  transitionTimer = 60;
  transDir = dir;
}

public void updateTransition()
{
  if(transitionTimer <= 0) return;
  transitionTimer -= 1;
  if(transitionTimer == 30)
  {
    float playerSize = player.getPlayerSize();
    player.setPlayerX((width - playerSize) / 2);
    player.setPlayerY((height - playerSize) / 2);
    if(transDir == TransDir.TUP)
    {
      enterTopPortal();
      player.setPlayerY(height - gridSize - playerSize);
    }
    else if(transDir == TransDir.TDOWN)
    {
      enterBottomPortal();
      player.setPlayerY(gridSize);
    }
    else if(transDir == TransDir.TLEFT)
    {
      enterLeftPortal();
      player.setPlayerX(width - gridSize - playerSize);
    }
    else if(transDir == TransDir.TRIGHT)
    {
      enterRightPortal();
      player.setPlayerX(gridSize);
    }
    if(isTeleportRoom())
    {
      teleportToSpawn();
      player.setPlayerX((width - playerSize) / 2);
      player.setPlayerY((height - playerSize) / 2);
    }
    weapon.updateWeapon();
  }
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
