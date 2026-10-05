SaveManager saver;
MapData mapData;
int[][] roomDisData;
MobData[][][] mobData;
ObstacleData[][][] obsData;

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
  
  player = new Player();
  
  initializeImages();
  
  tmpPrintRoomDisData();
  
  size(880, 720);
  
  //mobData[2][1] = appendTo(mobData[2][1], new MobData(5, 6));
  //obsData[2][2] = appendTo(obsData[2][2], new ObstacleData(2, 3, 1));
  //saver.SaveIntoData(mapData);
  
  print(gridSize);
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
