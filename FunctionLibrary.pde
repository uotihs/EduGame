import java.util.Arrays;
import java.lang.IndexOutOfBoundsException;

public static <T> T[] AppendTo(T[] oldArr, T item)
{
  T[] newArr = Arrays.copyOf(oldArr, oldArr.length + 1);
  newArr[newArr.length-1] = item;
  return newArr;
}

public void tmpDisplayRoomInformation()
{
  fill(#FFFFFF);
  textSize(35);
  text("Current Row: "+currentRow+"; Current Column: "+currentColumn
      +"; RoomValue: "+roomDisData[currentRow][currentColumn], 35, 100);
  textSize(20);
  for(int i=0; i < mobData[currentRow][currentColumn].length; i++)
  {
    MobData thisMob = mobData[currentRow][currentColumn][i];
    text(i +
        ": SpawnX: "+ thisMob.spawnX +
        ", SpawnY: "+ thisMob.spawnY +
        ", Health: "+ thisMob.health, 60, 150+i*25);
  }
  for(int i=0; i < obsData[currentRow][currentColumn].length; i++)
  {
    ObstacleData thisObs = obsData[currentRow][currentColumn][i];
    text(i +
        ": LocX: "+ thisObs.x +
        ", LocY: "+ thisObs.y +
        ", Type: "+ thisObs.type, 430, 150+i*25); 
  }
}

public void enterLeftPortal()
{
  fill(#FFFFFF);
  textSize(50);
  try
  {
    if(roomDisData[currentRow][currentColumn - 1] == -1)
    { 
      text("Left room doesn't exist.", 120, 400); 
    }
    else { currentColumn -= 1; }
  }
  catch(IndexOutOfBoundsException e)
  {
    text("Left room doesn't exist.", 120, 400);
  }
}

public void enterRightPortal()
{
  fill(#FFFFFF);
  textSize(50);
  try
  {
    if(roomDisData[currentRow][currentColumn + 1] == -1)
    { 
      text("Right room doesn't exist.", 120, 400); 
    }
    else { currentColumn += 1; }
  }
  catch(IndexOutOfBoundsException e)
  {
    text("Right room doesn't exist.", 120, 400);
  }
}

public void enterTopPortal()
{
  fill(#FFFFFF);
  textSize(50);
  try
  {
    if(roomDisData[currentRow - 1][currentColumn] == -1)
    { 
      text("Top room doesn't exist.", 120, 400); 
    }
    else { currentRow -= 1; }
  }
  catch(IndexOutOfBoundsException e)
  {
    text("Top room doesn't exist.", 120, 400);
  }
}

public void enterBottomPortal()
{
  fill(#FFFFFF);
  textSize(50);
  try
  {
    if(roomDisData[currentRow + 1][currentColumn] == -1) 
    { 
      text("Bottom room doesn't exist.", 120, 400); 
    }
    else { currentRow += 1; }
  }
  catch(IndexOutOfBoundsException e)
  {
    text("Bottom room doesn't exist.", 120, 400);
  }
}
