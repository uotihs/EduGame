
public class Boss
{
  private float bossX = 0, bossY = 0, bossSize = 0;
  private int bossType = 0, attackCooldown = 60, 
    stage = 0, stageTimer = 0;
  private int narrowBurstLeft = 0, traceBulletsLeft = 0; 
  private float lockedTargetAngle = 0;
  private boolean isCharging = false;
  
  public Boss()
  {
    teleportToLegMob();
    this.bossSize = gridSize;
    this.bossType = roomDisData[currentRow][currentColumn] / 10 - 1;
    if(bossType == 2) { legMob.setMobSpeed(0); }
  }
  
  public void attack()
  {
    if(attackCooldown == 0)
    {
      if(stage == 0 && stageTimer == 0)
      {
         stageTimer = 10;
         stage = 1;
      }
      else if(stage == 1 && stageTimer == 0)
      {
        stage = 2;
        stageTimer = 6;
        if(bossType == 0) { physicsBossAttack(); }
        else if(bossType == 1) { mathBossAttack(); }
        else if(bossType == 2) { chemistryBossAttack(); }
        attackCooldown = 60;
      }
    }
    if(stageTimer == 0)
    {
      if(isCharging)
      {
        isCharging = false;
        legMob.setMobSpeed(2);
        narrowRangeAttack();
      }
      if(narrowBurstLeft > 0) { fireNarrowWave(); }
      if(traceBulletsLeft > 0) { fireTraceBullet(); }
      if(narrowBurstLeft + traceBulletsLeft != 0) { stageTimer = 3; }
      if(stage == 2 && narrowBurstLeft + traceBulletsLeft == 0)
      {
        stage = 0;
        stageTimer = 6;
      }
    }
  }
  
  private void physicsBossAttack()
  {
    int randNum = rand.nextInt(10);
    if(randNum < 2) { wideRangeAttack(); }
    else if(randNum < 5) { narrowRangeAttack(); }
    else if(randNum < 9) { traceBulletAttack(); }
    else { healing(); }
  }
  
  private void mathBossAttack()
  {
    int randNum = rand.nextInt(10);
    if(randNum < 7)
    {
      if(legMob.thisCanSeePlayer()) { chargeAttack(); }
      else { bounceBulletAttack(); }
    }
    else { traceBulletAttack(); }
  }
  
  private void chemistryBossAttack()
  {
    int randNum = rand.nextInt(10);
    if(randNum < 4)
    {
      if(mobArr.size() == 0) { summonMobs(); }
      else { narrowRangeAttack(); }
    }
    else if(randNum < 7) { wideRangeAttack(); }
    else { bounceBulletAttack(); }
  }
  
  private void wideRangeAttack()
  {
    int steps = 12;
    float centerBossX = bossX + bossSize / 2,
      centerBossY = bossY + bossSize / 2;
    for(int i = 0; i < steps; i++)
    {
      float angle = PI * 2.0 / steps * i;
      bulletArr.add(new Bullet(
        centerBossX, centerBossY,
        centerBossX + cos(angle), centerBossY + sin(angle),
        10, 1, TargetType.PLAYER)); 
    }
  }
  
  private void narrowRangeAttack()
  {
    lockedTargetAngle = atan2(player.getPlayerY() - bossY,
      player.getPlayerX() - bossX);
    narrowBurstLeft = 5;
    fireNarrowWave();
  }
  
  private void fireNarrowWave()
  {
    float spreadAngle = 0.5,
      centerBossX = bossX + bossSize / 2,
      centerBossY = bossY + bossSize / 2;
    for(int i = 0; i < 3; i++)
    {
      float thisAngle = lockedTargetAngle + spreadAngle * (i - 1);
      bulletArr.add(new Bullet(
        centerBossX, centerBossY,
        centerBossX + cos(thisAngle), centerBossY + sin(thisAngle),
        10, 1, TargetType.PLAYER));
    }
    narrowBurstLeft -= 1;
  }
  
  private void bounceBulletAttack()
  {
    float angle = atan2(player.getPlayerY() - bossY,
      player.getPlayerX() - bossX),
      centerBossX = bossX + bossSize / 2,
      centerBossY = bossY + bossSize / 2;
    for(int i = 0; i < 3; i++)
    {
      float thisAngle = angle + 0.5 * (i - 1);
      bulletArr.add(new Bullet(
        centerBossX, centerBossY,
        centerBossX + cos(thisAngle), centerBossY + sin(thisAngle),
        10, 2, TargetType.PLAYER));
    }
  }
  
  private void traceBulletAttack()
  {
    traceBulletsLeft = 15;
    fireTraceBullet();
  }
  
  private void fireTraceBullet()
  {
    float thisAngle = atan2(player.getPlayerY() - bossY,
      player.getPlayerX() - bossX),
      centerBossX = bossX + bossSize / 2,
      centerBossY = bossY + bossSize / 2;;
    bulletArr.add(new Bullet(
      centerBossX, centerBossY,
      centerBossX + cos(thisAngle), centerBossY + sin(thisAngle),
      10, 1, TargetType.PLAYER));
    traceBulletsLeft -= 1;
  }
  
  private void summonMobs()
  {
    int steps = rand.nextInt(3) + 1;
    for(int i = 0; i < steps; i++)
    {
      float thisAngle = (float)PI / steps * i;
      int mobRow = (int)((bossY + bossSize / 2 +
        sin(thisAngle) * gridSize * 0.75) / gridSize),
        mobColumn = (int)((bossX + bossSize / 2 +
        cos(thisAngle) * gridSize * 0.75) / gridSize);
      if(mobRow < 0 || mobRow > rows - 1 ||
          mobColumn < 0 || mobColumn > columns - 1) { return; }
      if(!isObstacle(mobRow, mobColumn))
      {
        Mob newMob = new Mob(new MobData(mobRow, mobColumn, 100));
        mobArr.add(newMob);
        mobGridArr[mobRow * columns + mobColumn].add(newMob);
      }
    }
  }
  
  private void chargeAttack()
  {
    isCharging = true;
    legMob.setMobSpeed(10);
  }
  
  private void healing()
  {
    legMob.addMobHealth(30); 
  }
  
  public void teleportToLegMob()
  {
    this.bossX = legMob.getMobX();
    this.bossY = legMob.getMobY();
  }
  
  public void renderBoss()
  {
    image(mobImages[bossType * 6 + 3 + stage], bossX, bossY, bossSize, bossSize);
    if(legMob.getHitTimer() <= 4 && legMob.getHitTimer() > 0)
    {
      blendMode(SUBTRACT);
      tint(#0B8AA2);
      image(mobImages[bossType * 6 + 3 + stage], bossX, bossY, bossSize, bossSize);
      noTint();
      blendMode(BLEND);
    }
  }
  
  public void renderBossHealthBar()
  {
    image(bossHealthBarFrame, gridSize * 2, 0,
      gridSize * 7, gridSize);
    fill(#E8070B);
    rect(gridSize * 3, gridSize * (7.0 / 16),
      gridSize * 5 * ((float)legMob.getMobHealth() / legMob.getInitMobHealth()),
      gridSize / 8);
    image(wordCards[bossType], gridSize * 2, 0, gridSize * 3, gridSize);
  }
  
  public void addAttackCooldown(int inputValue)
  { 
    this.attackCooldown = max(attackCooldown + inputValue, 0);
  }
  public void updateStageTimer() { stageTimer = max(stageTimer - 1, 0); }
}
