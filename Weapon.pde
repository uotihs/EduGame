public class Weapon
{
  private float weaponX = 0, weaponY = 0, weaponSize = 0;
  private float angle = 0;
  private float holdDistance = 0;
  private int weaponLevel = 0;
  private final int maxWeaponLevel = 3;
  
  public Weapon()
  {
    this.weaponSize = gridSize * 0.75;
    this.holdDistance = gridSize * 0.5;
    updateWeapon();
  }

  public void updateWeapon()
  {
    weaponX = player.getPlayerX() + player.getPlayerSize() / 2;
    weaponY = player.getPlayerY() + player.getPlayerSize() / 2;
    angle = atan2(mouseY - weaponY, mouseX - weaponX);
  }

  public void renderWeapon()
  {
    pushMatrix();
    pushStyle();
    translate(weaponX, weaponY);
    rotate(angle);
    if(abs(angle) > HALF_PI) { scale(1, -1); }
    translate(holdDistance, 0);
    PImage currentImage = weaponImages[weaponLevel];
    imageMode(CENTER);
    if(currentImage != null) { image(currentImage, 0, 0, weaponSize, weaponSize); }
    else
    {
      fill(200);
      rect(0, 0, weaponSize, weaponSize);
    }
    popStyle();
    popMatrix();
  }
  public float getAngle() { return angle; }
  public float getWeaponSize() { return weaponSize; }
  public int getWeaponLevel() { return weaponLevel; }
  
  public void upgradeWeapon() { weaponLevel = min(weaponLevel + 1, maxWeaponLevel); }
}
