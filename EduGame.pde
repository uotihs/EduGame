SaveManager saver;
MapData mapData;
int[][] roomDisData;
MobData[][][] mobData;
ObstacleData[][][] obsData;

int currentRow = 2, currentColumn = 2;

PImage backgroundImage;
PImage[] tiles = new PImage[11];

void setup()
{
  saver = new SaveManager();
  // below line will reset whole data, can only use once after refactor!!!
  // saver.InitializeData();
  
  mapData = saver.LoadFromData();
  roomDisData = mapData.roomDistData;
  mobData = mapData.mobData;
  obsData = mapData.obsData;
  saver.SaveIntoData(mapData);
  
  InitializeImages();
  
  tmpPrintRoomDisData();
  
  size(880, 720);
  
  //mobData[2][1] = AppendTo(mobData[2][1], new MobData(5, 6));
  //obsData[2][2] = AppendTo(obsData[2][2], new ObstacleData(2, 3, 1));
  //saver.SaveIntoData(mapData);
}

void draw()
{
  RenderBackground();
  RenderObstacle();
  tmpDisplayRoomInformation();
}

void keyPressed()
{
  if((keyCode == 87) || (keyCode == 38)) { EnterTopPortal(); }
  if((keyCode == 83) || (keyCode == 40)) { EnterBottomPortal(); }  
  if((keyCode == 65) || (keyCode == 37)) { EnterLeftPortal(); }
  if((keyCode == 68) || (keyCode == 39)) { EnterRightPortal(); }
}
