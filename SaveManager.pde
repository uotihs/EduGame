import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import java.io.FileWriter;
import java.io.FileReader;
import java.io.IOException;

public class SaveManager
{
  private String filePath = dataPath("mapdata/Data.json");
  Gson gson = new GsonBuilder().setPrettyPrinting().create(); 
  
  public void initializeData()
  {
    saveIntoData(new MapData()); 
  }
  
  public MapData loadFromData()
  {  
    try (FileReader reader = new FileReader(filePath))
    {
      MapData newMapData = gson.fromJson(reader, MapData.class);
      return newMapData;
    }
    catch (IOException e)
    {
      System.out.println("File path doesn't exist.");
      return null;
    }
  }
  
  public void saveIntoData(MapData mapData)
  {
    try (FileWriter writer = new FileWriter(filePath))
    { 
      gson.toJson(mapData, writer);
    }
    catch (IOException e)
    {
      System.out.println("File path doesn't exist.");
    }
  }
}
