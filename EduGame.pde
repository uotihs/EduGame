SaveManager saver;
MapData mapData;
int[][] roomDisData;
MobData[][][] mobData;
ObstacleData[][][] obsData;

boolean[] obsArr;
final int rows = 7, columns = 9,
  maxAmmos = 6, reloadDuration = 60;
Random rand = new Random();

float gridSize;
int currentRow = 2, currentColumn = 2;
Player player;
PlayerWeapon weapon;
boolean up = false, down = false,
  left = false, right = false, shooting = false;
  
ArrayList<Mob> mobArr;
ArrayList<Mob>[] mobGridArr;
ArrayList<Bullet> bulletArr = new ArrayList<Bullet>();

PImage backgroundImage;
PImage[] tiles = new PImage[11];
PImage[] weaponImgs = new PImage[4];

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
  
  tmpPrintRoomDisData();
  
  size(880, 720);
  gridSize = width / 11;

  player = new Player();
  weapon = new PlayerWeapon();
  //mobData[2][3] = appendTo(mobData[2][3], new MobData(4, 8));
  //obsData[2][1] = appendTo(obsData[2][1], new ObstacleData(8, 5, 0));
  //saver.saveIntoData(mapData);
}

void draw()
{
  renderBackground();
  renderDoors();
  renderObstacles();
  
  if(player.isDead()) { println("Game Over"); }
  player.move();
  player.shoot();
  player.updateReloadTimer();
  player.renderPlayer();
  weapon.renderWeapon();
  
  mobsMove();
  clearDeadMobs();
  renderMobs();
  
  bulletsMove();
  clearHitBullets();
  renderBullets();
  
  //tmpDisplayRoomInformation();
}

void keyPressed() { updateDirection(true); }
void keyReleased() { updateDirection(false); }
void mousePressed() { shooting = true; }