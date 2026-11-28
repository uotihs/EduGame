
public class CutScene
{
  CutSceneType cutSceneType = null;
  int cutSceneTimer = 0;
  
  public CutScene() {}
  
  public void renderCutScene()
  {
    if(cutSceneType != null)
    {
      if(cutSceneTimer == 0)
      {
        isPaused = true;
        if(cutSceneType == CutSceneType.FINAL_DOOR_DISPLAY) { cutSceneTimer = 60; }
        else if(cutSceneType == CutSceneType.BOSS_INTRO) { cutSceneTimer = 30; }
      }
      if(cutSceneType == CutSceneType.FINAL_DOOR_DISPLAY) { finalDoorDisplay(); }
      else if(cutSceneType == CutSceneType.BOSS_INTRO) { bossIntro(); }
    }
  }
  
  private void finalDoorDisplay()
  {
    float shakeIntensity = 0;
    if(cutSceneTimer >= 30 && cutSceneTimer <= 45)
    {
      shakeIntensity = map(cutSceneTimer, 45, 30, 0.2, 1.0);
    }
    else if(cutSceneTimer >= 15 && cutSceneTimer < 30)
    {
      shakeIntensity = pow(map(cutSceneTimer, 30, 15, 1.0, 0.0), 1.5);
    }
    
    float shakeMag = gridSize * 0.18 * shakeIntensity;
    float shakeX = random(-shakeMag, shakeMag);
    float shakeY = random(-shakeMag, shakeMag);

    float doorScale = 1.0;
    if (cutSceneTimer < 30 && cutSceneTimer > 20)
    {
      float popProgress = map(cutSceneTimer, 30, 20, 1, 0);
      doorScale = 1.0 + 0.15 * pow(popProgress, 2);
    }

    pushMatrix();
    translate(shakeX, shakeY);
    
    image(backgroundImage.get(474, 128, 474, 128),
      -10, -10, width + 20, gridSize * 3 + 20);
    image(backgroundImage.get(474, 0, 474, 384),
      -10, gridSize * 1.5 - 10, width + 20, height + gridSize / 3);
      
    pushMatrix();
    translate(width / 2, gridSize * 3);
    scale(doorScale);
    image(tiles[bossKilled + 11 + ((cutSceneTimer < 30)? 1 : 0)],
      -gridSize * 1.5, -gridSize * 1.5, gridSize * 3, gridSize * 3);
    popMatrix();
    
    popMatrix();
    
    if(cutSceneTimer >= 15 && cutSceneTimer <= 45)
    {
      pushMatrix();
      translate(width / 2, gridSize * 3);
      rotate(PI * cutSceneTimer / 30);
      fill(255, 242, 90, (15 - abs(30 - cutSceneTimer)) * 2 + 200);
      starShape(0, 0, (15 - abs(30 - cutSceneTimer)) * 20);
      popMatrix();
    }
    
    if (cutSceneTimer <= 30 && cutSceneTimer > 24)
    {
      float flashAlpha = 180 * pow(map(cutSceneTimer, 30, 24, 1, 0), 2);
      fill(255, 250, 210, flashAlpha);
      rect(0, 0, width, height);
    }
    renderMovieFrame();
  }
  
  private void bossIntro()
  {
    float barIn = min(1, max(0, map(cutSceneTimer, 30, 15, 0, 1)));
    float barInEased = 1 - pow(1 - barIn, 3);
    
    float barOut = min(1, max(0, map(cutSceneTimer, 6, 0, 0, 1)));
    float barOutEased = pow(barOut, 2);
    
    float barFactor = barInEased - barOutEased;
    float topOffset = lerp(-gridSize * 4, 0, barFactor);
    float bottomOffset = lerp(gridSize * 3.5, 0, barFactor);
    
    float reveal = min(1, max(0, map(cutSceneTimer, 30, 20, 0, 1)));
    float fadeOut = min(1, max(0, map(cutSceneTimer, 6, 0, 1, 0)));
    
    float brightness = lerp(0, 255, reveal);
    float alpha = lerp(0, 255, fadeOut);
    
    fill(#FFC1C2, 70 * fadeOut);
    rect(0, 0, width, height);
    
    pushMatrix();
    translate(0, topOffset);
    fill(#030303);
    rect(0, 0, width, gridSize * 3);
    triangle(0, gridSize * 3 - 1, width, gridSize * 3 - 1, 0, gridSize * 4);
    popMatrix();
    
    tint(brightness, alpha);
    float shakeProgress = min(1, max(0, map(cutSceneTimer, 20, 10, 1, 0)));
    float shakeMagnitude = gridSize * 0.25 * shakeProgress;
    float shakeX = random(-shakeMagnitude, shakeMagnitude);
    float shakeY = random(-shakeMagnitude, shakeMagnitude);
    
    pushMatrix();
    translate(gridSize * 4 + shakeX, gridSize * 5.7 + shakeY);
    rotate(-0.1);
    image(mobImages[(roomDisData[currentRow][currentColumn] / 10 - 1) * 6 + 3],
      -gridSize * 3, -gridSize * 3, gridSize * 3.7, gridSize * 3.7);
    popMatrix();
    
    pushMatrix();
    translate(0, bottomOffset);
    rect(0, height - gridSize * 2.5, width, gridSize * 2.5);
    triangle(0, height - gridSize * 2.5 + 1, width, height - gridSize * 2.5 + 1,
      width, height - gridSize * 3.5);
    popMatrix();
      
    image(wordCards[roomDisData[currentRow][currentColumn] / 10 - 1],
      gridSize * 5, gridSize * 5.5, gridSize * 6, gridSize * 2);
    noTint();
    
    if (cutSceneTimer <= 20 && cutSceneTimer > 12)
    {
      float flashProgress = map(cutSceneTimer, 20, 12, 1, 0);
      float flashAlpha = 220 * flashProgress;
      fill(255, 250, 210, flashAlpha);
      rect(0, 0, width, height);
    }
  }
  
  private void renderMovieFrame()
  {
    float barIn = min(1, max(0, map(cutSceneTimer, 60, 45, 0, 1)));
    float barInEased = 1 - pow(1 - barIn, 3);
    
    float barOut = min(1, max(0, map(cutSceneTimer, 15, 0, 0, 1)));
    float barOutEased = pow(barOut, 2);
    
    float factor = barInEased - barOutEased;
    
    float topOffset = lerp(-gridSize * 1.5, 0, factor);
    float bottomOffset = lerp(gridSize * 1.5, 0, factor);
    
    fill(#F5A039, 30 * factor);
    rect(0, 0, width, height);
    
    fill(#000000);
    rect(0, topOffset, width, gridSize * 1.5);
    rect(0, height - gridSize * 1.5 + bottomOffset, width, gridSize * 1.5);
  }
  
  public void setCutSceneType(CutSceneType inputType) { this.cutSceneType = inputType; }
  public void updateCutSceneTimer()
  {
    this.cutSceneTimer = max(cutSceneTimer - 1, 0);
    if(cutSceneTimer == 0 && cutSceneType != null)
    {
      isPaused = false;
      cutSceneType = null;
    }
  }
}
