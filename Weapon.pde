public class PlayerWeapon
{
  private float weaponX = 0, weaponY = 0, weaponSize = 0;
  private float angle = 0;
  private float handOffsetY = 0, holdDistance = 0;
  private int weaponLevel = 1;
  private final int maxLevel = 4;
  
  public PlayerWeapon()
  {
    this.weaponSize = gridSize * 0.75;
    this.handOffsetY = gridSize * 0.08;
    this.holdDistance = gridSize * 0.35;
    updateWeapon();
  }

  public void updateWeapon()
  {
    this.weaponX = player.getPlayerX() + 80 / 2;
    this.weaponY = player.getPlayerY() + 80 / 2 + handOffsetY;

    // 槍口方向隨滑鼠游標旋轉
    this.angle = atan2(mouseY - this.weaponY, mouseX - this.weaponX);
  }

  public void upgradeWeapon()
  {
    // 武器升級 (Lv.1 ~ Lv.4)，每增加一級切換至下一張 PNG
    if(this.weaponLevel < this.maxLevel)
    {
      this.weaponLevel += 1;
    }
  }

  public void setWeaponLevel(int inputLevel)
  {
    this.weaponLevel = constrain(inputLevel, 1, this.maxLevel);
  }

  public void renderWeapon()
  {
    updateWeapon();

    pushMatrix();
    pushStyle();

    translate(this.weaponX, this.weaponY);
    rotate(this.angle);

    // 當滑鼠在玩家左側時垂直鏡像翻轉，避免武器貼圖上下顛倒
    if(abs(this.angle) > HALF_PI)
    {
      scale(1, -1);
    }

    // 將武器往瞄準方向外推
    translate(this.holdDistance, 0);

    imageMode(CENTER);
    PImage currentImg = weaponImgs[this.weaponLevel - 1];
    if(currentImg != null)
    {
      image(currentImg, 0, 0, this.weaponSize, this.weaponSize);
    }
    else
    {
      // 防呆暫代方塊
      rectMode(CENTER);
      fill(200);
      rect(0, 0, this.weaponSize * 0.6, this.weaponSize * 0.25);
    }

    popStyle();
    popMatrix();
  }

  public float getWeaponX() { return weaponX; }
  public float getWeaponY() { return weaponY; }
  public float getAngle() { return angle; }
  public int getWeaponLevel() { return weaponLevel; }
}
