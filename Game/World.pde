/* World Class - Used to describe the screen of a pixel-based game
 * Subclass of a Screen, includes an ArrayList of Sprite objects
 * Authors: Joel Bianchi, Nathan Santos, Clive Sherwood, Vanessa Balbuena
 * Last Edit: 6/14/2024
 * methods to make looping through the Sprites easier:
 *   int getNumSprites()
 *   Sprite getSprite(int index)
 *   Sprite removeSprite(int index)
 *   void removeSprite(Sprite sprite)
 * Method to clear all sprites for a restart
 */

import java.util.ArrayList;

public class World extends Screen{

  //------------------ WORLD FIELDS --------------------//
  //private static World currentWorld = null; //static variable to track the current world
  private ArrayList<Sprite> sprites = new ArrayList<Sprite>();
  long lastSpriteUpdateTime = 0;

  //------------------ WORLD CONSTRUCTORS --------------------//
  //World Constructor #1
  public World(String name, PImage bgImg) {
    super(name, bgImg);
  }
  //World Constructor #2
  public World(String name) {
    this(name, null);
  }
    //World Constructor #3
  public World() {
    this("default world", null);
  }

  //World Constructor #4 for Moveable Backgrounds
  public World(String name, String movingBgFile, float scale, float x, float y) {
     super(name, movingBgFile, scale, x, y);
  }


  //------------------ WORLD SPRITE METHODS --------------------//
  public ArrayList<Sprite> getSprites(){
      return sprites;
  }

  //method to add a sprite to the world
  public void addSprite(Sprite sprite) {
    if (!sprites.contains(sprite)) {
      sprites.add(sprite);
    }
  }

  //method to add a copy of a sprite to a specific coordinate in the world
  public void addSpriteCopyTo(Sprite sprite, float x, float y) {
    if(sprite.getIsAnimated()){
      sprites.add( ((AnimatedSprite)sprite).copyTo(x,y));
    }
    sprites.add(sprite.copyTo(x,y));
  }

  //method to add a copy of a sprite to the world
  public void addSpriteCopy(Sprite sprite) {
    if(sprite.getIsAnimated()){
      sprites.add(((AnimatedSprite)sprite).copy());
    }
    sprites.add(sprite.copy());
  }

  //method to add a copy of a sprite to a specific coordinate in the world
  public void addSpriteCopyTo(Sprite sprite, float x, float y, float aSpeed) {
    if(sprite.getIsAnimated()){
      sprites.add( ((AnimatedSprite)sprite).copyTo(x, y, aSpeed));
    }
    sprites.add(sprite.copyTo(x,y));
  }
  
    //method to remove return the number of sprites in a World
  public int getNumSprites(){
    return sprites.size();
  }

  //method to get a specific Sprite based on its index
  public Sprite getSprite(int index){
    return sprites.get(index);
  }

  //method to remove a sprite from the world
  public void removeSprite(Sprite sprite) {
    if (sprites.contains(sprite)) {
      sprites.remove(sprite);
    }
  }

  //method to remove a sprite from the world based on its index in the ArrayList
  public Sprite removeSprite(int index) {
      return sprites.remove(index);
  }

  //Remove all current Sprites from World (useful for restarting a level) -Vanessa Balbuena 2024
  public void clearAllSprites(){
    for(int i = 0; i < sprites.size(); i++){
      removeSprite(i);
    }
  }

  //method to display all the sprites on the screen
  public void showWorldSprites(){
    //System.out.println("showing sprites...");
    //Loop through all the sprites
    for(Sprite sprite : sprites){
      if(sprite.getIsAnimated()){
        AnimatedSprite aSprite = (AnimatedSprite) sprite;
        aSprite.animate();
        //System.out.println("aSprite: " + aSprite.getJsonFile() + "\t" + aSprite.iBucket + "\t" + aSprite.aSpeed);
      } else{
        sprite.show();
      }
    }
  }
  //to deprecate
  public void showSprites(){
    showWorldSprites();
  }

  //method to print out list of sprites
  public void printWorldSprites(){
      for(Sprite sprite: sprites){
          System.out.println(sprite);
      }
  }
  //to deprecate
  public void printSprites(){
    printWorldSprites();
  }


   
   



  //------------------ WORLD MUTATOR METHODS --------------------//
  
  //method to update all sprites in the world each cycle
  public void update() {
    long deltaTime = getTimeSince(lastSpriteUpdateTime);
    for (Sprite sprite : sprites) {
      sprite.update(deltaTime);
    }
    lastSpriteUpdateTime = getScreenTime();
  }

}
