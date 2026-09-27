SaveManager saver;
MapData mapData;
int[][] roomDisData;
MobData[][][] mobData;
ObstacleData[][][] obsData;
int currentRow, currentColumn;

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
  
  currentRow=2;
  currentColumn=2;
  
  for(int i=0; i < roomDisData.length; i++)
  {
    for(int j=0; j < roomDisData[i].length; j++)
    {
      System.out.print(roomDisData[i][j]+" ");
    }
    System.out.print("\n");
  }
  
  size(800, 600);
  
  //mobData[2][1] = AppendTo(mobData[2][1], new MobData(5, 6));
  //obsData[0][0] = AppendTo(obsData[0][0], new ObstacleData(4, 6, 456));
  //saver.SaveIntoData(mapData);
}

void draw()
{
  background(#000000);
  tmpDisplayRoomInformation();
}

void keyPressed()
{
  if(keyCode == 65) { enterLeftPortal(); }
  if(keyCode == 68) { enterRightPortal(); }
  if(keyCode == 87) { enterTopPortal(); }
  if(keyCode == 83) { enterBottomPortal(); }
}
