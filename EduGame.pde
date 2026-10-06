SaveManager saver;
MapData mapData;
int[][] roomDisData;
MobData[][][] mobData;
ObstacleData[][][] obsData;

float gridSize;
int currentRow = 2, currentColumn = 2;
Player player;

PImage backgroundImage;
PImage[] tiles = new PImage[11];

void setup()
{
  saver = new SaveManager();
  // below line will reset whole data, can only use once after refactor!!!
  // saver.initializeData();
  
  mapData = saver.loadFromData();
  roomDisData = mapData.roomDistData;
  mobData = mapData.mobData;
  obsData = mapData.obsData;
  saver.saveIntoData(mapData);
  
  initializeImages();
  
  tmpPrintRoomDisData();
  
  size(880, 720);
  gridSize = width / 11;
  
  player = new Player();
  
  //mobData[2][1] = appendTo(mobData[2][1], new MobData(5, 6));
  //obsData[2][3] = appendTo(obsData[2][3], new ObstacleData(1, 1, 0));
  //saver.saveIntoData(mapData);
}

void draw()
{
  renderBackground();
  player.renderPlayer();
  renderObstacle();
  tmpDisplayRoomInformation();
}

void keyPressed()
{
  if((keyCode == 87) || (keyCode == 38)) { player.moveUp(); }
  if((keyCode == 83) || (keyCode == 40)) { player.moveDown(); }  
  if((keyCode == 65) || (keyCode == 37)) { player.moveLeft(); }
  if((keyCode == 68) || (keyCode == 39)) { player.moveRight(); }
}
