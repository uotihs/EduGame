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
  right = false, isShooting = false, isPaused = false;

ArrayList<Mob> mobArr;
ArrayList<Mob>[] mobGridArr;
ArrayList<Bullet> bulletArr = new ArrayList<Bullet>(),
  splitParentArr = new ArrayList<Bullet> ();

PImage backgroundImage, playerImage, bossHealthBarFrame;
PImage[] tiles = new PImage[16], bulletImages = new PImage[6],
  mobImages = new PImage[18], weaponImages = new PImage[4], wordCards = new PImage[3];

void setup()
{
  saver = new SaveManager();
  // below line will reset whole data, can only use once after refactor!!!
  //saver.initializeData();
  
  mapData = saver.loadFromData();
  roomDisData = mapData.roomDistData;
  mobData = mapData.mobData;
  obsData = mapData.obsData;
  saver.saveIntoData(mapData);
  
  tmpPrintRoomDisData();
  
  updateAllArrays();

  initializeImages();
  
  size(935, 765);
  //880, 720
  gridSize = width / 11;

  player = new Player();
  weapon = new Weapon();
  cutScene = new CutScene();
  //mobData[3][2] = appendTo(mobData[3][2], new MobData(2, 2, 100));
  //obsData[2][1] = appendTo(obsData[2][1], new ObstacleData(8, 5, 0));
  //saver.saveIntoData(mapData);
}

void draw()
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

void keyPressed() { updateDirection(true); }
void keyReleased() { updateDirection(false); }
void mousePressed() { if(!isPaused) {isShooting = true; } }
