public class Bullet
{
  private float x;
  private float y;
  private float vx;
  private float vy;
  private float speed;
  private int damage;
  private float bulletSize;
  private boolean isAlive;

  public Bullet(float startX, float startY, float angle, float speed, int damage)
  {
    this.x = startX;
    this.y = startY;
    this.speed = speed;
    this.damage = damage;
    this.bulletSize = 8;
    this.isAlive = true;

    // 依據傳入的角度與速度計算 X、Y 分量
    this.vx = cos(angle) * speed;
    this.vy = sin(angle) * speed;
  }

  public void Update()
  {
    if (!isAlive) return;

    x += vx;
    y += vy;

    // 超出螢幕邊界就自動銷毀
    if (x < 0 || x > width || y < 0 || y > height)
    {
      isAlive = false;
    }
  }

  public void Render()
  {
    if (!isAlive) return;

    fill(255, 230, 0); 
    noStroke();
    ellipse(x, y, bulletSize, bulletSize);
  }

  // 檢查是否擊中敵人
  public void CheckHit(Mob mobdata)
  {
    if (!isAlive || !mobdata.isDead()) return;

    float enemyCenterX = mobdata.mobX() + 20;
    float enemyCenterY = mobdata.mobY() + 20;

    if (dist(x, y, enemyCenterX, enemyCenterY) < (bulletSize / 2 + 20))
    {
      mobdata.takeDamage(damage);
      isAlive = false; 
    }
  }

  public boolean isAlive()
  {
    return isAlive;
  }
}
