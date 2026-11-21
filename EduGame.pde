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
int currentRow = 2, currentColumn = 2;
Player player;
Weapon weapon;
boolean up = false, down = false, left = false,
  right = false, isShooting = false, isPaused = false;
  
ArrayList<Mob> mobArr;
ArrayList<Mob>[] mobGridArr;
ArrayList<Bullet> bulletArr = new ArrayList<Bullet>();

PImage backgroundImage;
PImage[] tiles = new PImage[11];
PImage[] weaponImages = new PImage[4];

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
  
  updateAllArrays();

  initializeImages();
  
  size(880, 720);
  gridSize = width / 11;

  player = new Player();
  weapon = new Weapon();
  //mobData[2][3] = appendTo(mobData[2][3], new MobData(4, 8));
  //obsData[2][1] = appendTo(obsData[2][1], new ObstacleData(8, 5, 0));
  //saver.saveIntoData(mapData);
}

void draw()
{
  renderBackground();
  renderDoors();
  renderObstacles();
  
  if(!isPaused && transitionTimer <= 0)
  {
    if(player.isDead()) { gameOver(); }
    player.move();
    player.shoot();
    player.updateReloadTimer();
    weapon.updateWeapon();
  
    mobsMove();
    clearDeadMobs();
  
    bulletsMove();
    clearHitBullets();
  }
  renderBullets();
  renderMobs();
  player.renderPlayer();
  weapon.renderWeapon();
  if(transitionTimer > 0)
  {
    updateTransition();
    renderRoomTransition();
  }
  if(isPaused) { renderMask(); }
  //tmpDisplayRoomInformation();
}

void keyPressed() { updateDirection(true); }
void keyReleased() { updateDirection(false); }
void mousePressed() { if(!isPaused) {isShooting = true; } }
