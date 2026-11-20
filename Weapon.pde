public class Weapon
{
  private float weaponX = 0, weaponY = 0, weaponSize = 0;
  private float angle = 0;
  private float handOffsetY = 0, holdDistance = 0;
  private int weaponLevel = 0;
  private final int maxWeaponLevel = 3;
  
  public Weapon()
  {
    this.weaponSize = gridSize * 0.75;
    this.handOffsetY = gridSize * 0.08;
    this.holdDistance = gridSize * 0.35;
    updateWeapon();
  }

  private void updateWeapon()
  {
    weaponX = player.getPlayerX() + 80 / 2;
    weaponY = player.getPlayerY() + 80 / 2 + handOffsetY;
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

    imageMode(CENTER);
    PImage currentImage = weaponImages[weaponLevel];
    if(currentImage != null) { image(currentImage, 0, 0, weaponSize, weaponSize); }
    else
    {
      rectMode(CENTER);
      fill(200);
      rect(0, 0, weaponSize, weaponSize);
    }
    popStyle();
    popMatrix();
  }

  public float getWeaponX() { return weaponX; }
  public float getWeaponY() { return weaponY; }
  public float getAngle() { return angle; }
  public int getWeaponLevel() { return weaponLevel; }
  
  public void upgradeWeapon() { weaponLevel = min(weaponLevel + 1, maxWeaponLevel); }
}
