SaveManager saver;
MapData mapData;
int[][] roomDisData;
MobData[][][] mobData;
ObstacleData[][][] obsData;

boolean[] obsArr;
final int rows = 7, columns = 9;
Random rand = new Random();

float gridSize, transitionTimer = 0;
TransDir transDir;
int currentRow = 2, currentColumn = 2, bossKilled = 0;
Player player;
Weapon weapon;
Mob legMob = null;
Boss boss = null;
CutScene cutScene;
boolean up = false, down = false, left = false,
  right = false, isShooting = false, isPaused = false, gameRunning = false;

ArrayList<Mob> mobArr;
ArrayList<Mob>[] mobGridArr;
ArrayList<Bullet> bulletArr = new ArrayList<Bullet>(),
  splitParentArr = new ArrayList<Bullet> ();

PImage backgroundImage, playerImage, bossHealthBarFrame;
PImage[] tiles = new PImage[16], bulletImages = new PImage[6],
  mobImages = new PImage[18], weaponImages = new PImage[4], wordCards = new PImage[3];

void setup()
{
  size(935, 765);
  initializeGame();
}

void draw()
{
  background(#030303);
  if(gameRunning)
  {
    pushMatrix();
    focus();
  
    renderBackground();
    renderDoors();
    renderObstacles();
  
    if(!isPaused && transitionTimer <= 0)
    {
      if(player.isDead()) { gameOver(); }
      player.move();
      player.shoot();
      player.updateReloadTimer();
      player.updateHitTimer();
      weapon.updateWeapon();
  
      mobsMove();
      clearDeadMobs();
  
      bulletsMove();
      clearHitBullets();
      addSplitBullets();
    }
    renderBullets();
    renderMobs();
    player.renderPlayer();
    weapon.renderWeapon();
  
    popMatrix();
  
    renderBossHealthBar();
    if(isPaused && cutScene.cutSceneType == null) { renderMask(); }
    if(transitionTimer > 0)
    {
      updateTransition();
      renderRoomTransition();
    }
    else
    {
      cutScene.renderCutScene();
      cutScene.updateCutSceneTimer();
    }
    //tmpDisplayRoomInformation();
  }
  else
  {
    fill(255);
    textSize(50);
    text("Press P to start game.", gridSize * 3, gridSize * 4.5); 
  }
}

void keyPressed() { updateDirection(true); }
void keyReleased() { updateDirection(false); }
void mousePressed() { if(!isPaused) {isShooting = true; } }
