/* Game Class Starter File
 * Authors: David A & Christian Coman
 * Last Edit: 5/29/2024
 */

//import processing.sound.*;

//------------------ GAME VARIABLES --------------------//

//VARIABLES: Title Bar
String titleText = "Robots&Ships";
String extraText1 = "Points: ";
String extraText2 = " / Health: ";

//VARIABLES: Whole Game
//AnimatedSprite runningHorse;
//boolean doAnimation;

//VARIABLES: Splash Screen
Screen splashScreen;
PImage splashBg;
String splashBgFile = "images/apcsa.png";
//SoundFile song;

//VARIABLES: Level1Grid Screen
Grid level1Grid;
PImage level1Bg;
String level1BgFile = "images/skyViewImage.jpg";

PImage player1;   //Use PImage to display the image in a GridLocation
String player1File = "images/robot_placeholder.png";
int player1Row = 3;
int player1Col = 0; //Testing for full movement
int health = 3;
int points = 0;
int pointMax = 25; //Total points needed to win

PImage blaster;
String blasterFile = "images/blaster.png";

/* Testing for enemy placement */
PImage ship1;
String ship1File = "images/ship_placeholder.png";
int ship1Row = 3;
int ship1Col = 7; //Testing for full movement
//AnimatedSprite walkingChick;
Button b1 = new Button("rect", 650, 525, 100, 50, "GoToLevel2");

//VARIABLES: Level2World Pixel-based Screen
World level2World;
PImage level2Bg;
String level2BgFile = "images/sky.jpg";
Sprite player2; //Use Sprite for a pixel-based Location
String player2File = "images/zapdos.png";
int player2startX = 50;
int player2startY = 300;

//VARIABLES: EndScreen
World winScreen;
PImage endBgWin;
String endBgFileWin = "images/youwin.png";

World loseScreen;
PImage endBgLose;
String endBgFileLose = "images/youLose.jpg";

//VARIABLES: Tracking the current Screen being displayed
Screen currentScreen;
World currentWorld;
Grid currentGrid;
private int msElapsed = 0;


//------------------ REQUIRED PROCESSING METHODS --------------------//

//Required Processing method that gets run once
void setup() {

  //SETUP: Match the screen size to the background image size
  size(800,600);  //these will automatically be saved as width & height
  imageMode(CORNER);    //Set Images to read coordinates at corners
  //fullScreen();   //only use if not using a specfic bg image
  
  //SETUP: Set the title on the title bar
  surface.setTitle(titleText);

  //SETUP: Load BG images used in all screens
  splashBg = loadImage(splashBgFile);
  splashBg.resize(width, height);
  level1Bg = loadImage(level1BgFile);
  level1Bg.resize(width, height);
  level2Bg = loadImage(level2BgFile);
  level2Bg.resize(width, height);
  endBgWin = loadImage(endBgFileWin);
  endBgWin.resize(width, height);
  endBgLose = loadImage(endBgFileLose);
  endBgLose.resize(width, height);

  //SETUP: Screens, Worlds, Grids
  splashScreen = new Screen("splash", splashBg);
  level1Grid = new Grid("chessBoard", level1Bg, 6, 8);
  //level1Grid.startPrintingGridMarks();
  level2World = new World("sky", level2BgFile, 8.0, 0, 0); //moveable World constructor --> defines center & scale (x, scale, y)???
  //level2World = new World("sky", level2Bg);   //non-moving World construtor
  winScreen = new World("win", endBgWin);
  loseScreen = new World("lose",endBgLose);
  currentScreen = splashScreen;

  //SETUP: All Game objects
  //runningHorse = new AnimatedSprite("sprites/horse_run.png", "sprites/horse_run.json", 50.0, 75.0, 10.0);

  //SETUP: Level 1
  player1 = loadImage(player1File);
  player1.resize(level1Grid.getTileWidth(),level1Grid.getTileHeight());
  ship1 = loadImage(ship1File);
  ship1.resize(level1Grid.getTileWidth(),level1Grid.getTileHeight());
  blaster = loadImage(blasterFile);
  blaster.resize(level1Grid.getTileWidth(),level1Grid.getTileHeight());
  //walkingChick = new AnimatedSprite("sprites/chick_walk.png", "sprites/chick_walk.json", 0.0, 0.0, 5.0);
  //level1Grid.setTileSprite(new GridLocation (5,5), walkingChick);

 System.out.println("Done loading Level 1 ...");
  
  //SETUP: Level 2
  player2 = new Sprite(player2File, 0.25);
  //player2.moveTo(player2startX, player2startY);
  //level2World.addSpriteCopyTo(runningHorse, 100, 200);  //example Sprite added to a World at a location, with a speed
  level2World.printWorldSprites();
  System.out.println("Done loading Level 2 ...");
  
  //SETUP: Sound
  // Load a soundfile from the /data folder of the sketch and play it back
  // song = new SoundFile(this, "sounds/Lenny_Kravitz_Fly_Away.mp3");
  // song.play();
  
  println("Game started...");

} //end setup()


//Required Processing method that automatically loops
//(Anything drawn on the screen should be called from here)
void draw() {

  updateTitleBar();
  updateScreen();

  //simple timing handling
  if (msElapsed % 300 == 0) {
    //sprite handling
    populateSprites();
    moveSprites();
    moveBlasters();
  }
  msElapsed +=100;
  currentScreen.pause(100);

  //check for end of game
  if(isGameOver()){
    endGame();
  }

} //end draw()

//------------------ USER INPUT METHODS --------------------//


//Known Processing method that automatically will run whenever a key is pressed
void keyPressed(){

  //check what key was pressed
  System.out.println("\nKey pressed: " + keyCode); //key gives you a character for the key pressed

  //What to do when a key is pressed?
  
  //KEYS FOR LEVEL1
  if(currentScreen == level1Grid){

    //set [W] key to move the player1 up & avoid Out-of-Bounds errors
    if(keyCode == 87 && player1Row != 0){
    
      //Store old GridLocation
      GridLocation playerLoc = new GridLocation(player1Row, player1Col);
      
      //Erase image from previous location
      level1Grid.clearTileImage(playerLoc);

      //store a GridLocation for UP
      GridLocation aboveLoc = new GridLocation(ship1Row-1,ship1Col);

      //check the tile UP to see if a ship is there
      //PImage above = level1Grid.getTileImage(enemyLoc);


      if(ship1.equals(level1Grid.getTileImage(aboveLoc))){
        health--;
      }

      //change the field for player1Row
      player1Row--;
      //checkCollision(playerLoc, aboveLoc);
    }


    else if(keyCode == 83 && player1Row != 5){
      GridLocation oldLoc = new GridLocation(player1Row, player1Col);
      level1Grid.clearTileImage(oldLoc);
      player1Row++;
      //checkCollision(oldLoc, ship1);
    }

    //blaster
    if(keyCode == 80) {
      System.out.println("Pressed P");
      GridLocation b = new GridLocation(player1Row,1);
      System.out.println("got gridlocadtion");

      level1Grid.setTileImage(b,blaster);
      System.out.println("SetTileImage happened");

    }

    //Reset game
    // if(keyCode == 10) {
    //   System.out.println("Pressed Enter");
    //   points = 0;
    //   health = 3;
    //   System.out.println("Health: " + health + "\tpoints: " + points);
    //   currentScreen = level1Grid;
    //   System.out.println("level1Grid Set");
    //   updateScreen();
    // }
    // else if (keyCode == 68) {
    //   GridLocation oldLoc = new GridLocation(player1Row, player1Col);
    //   level1Grid.clearTileImage(oldLoc);
    //   player1Col++;
    // }
    // else if (keyCode == 65) {
    //   GridLocation oldLoc = new GridLocation(player1Row, player1Col);
    //   level1Grid.clearTileImage(oldLoc);
    //   player1Col--;
    // }



  }

  //CHANGING SCREENS BASED ON KEYS
  //change to level1 if 1 key pressed, level2 if 2 key is pressed
  if(key == '1'){
    currentScreen = level1Grid;
  } else if(key == '2'){
    currentScreen = level2World;
  }

  /* Testing for full movement
  //Down movement [s]
  if(keyCode == 115) {
    GridLocation oldLoc = new GridLocation(player1Row, player1Col);

    //Erase image from previous location
    

    //change the field for player1Row
    player1Row++;
  }
  //Left Movement [a]
  if(keyCode == 97) {
    GridLocation oldLoc = new GridLocation(player1Row, player1Col);

    player1Col--;
  }
  //Right Movement [d]
  if(keyCode == 100) {
    GridLocation oldLoc = new GridLocation(player1Row, player1Col);

    player1Col++;
  }
  */


}

//Known Processing method that automatically will run when a mouse click triggers it
void mouseClicked(){
  
  //check if click was successful
  System.out.println("\nMouse was clicked at (" + mouseX + "," + mouseY + ")");
  if(currentGrid != null){
    System.out.println("Grid location: " + currentGrid.getGridLocation());
  }

  //what to do if clicked? (Make player1 jump back?)
  


  //Toggle the animation on & off
  //doAnimation = !doAnimation;
  // System.out.println("doAnimation: " + doAnimation);
  // if(currentGrid != null){
  //   currentGrid.setMark("X",currentGrid.getGridLocation());
  // }

}



//------------------ CUSTOM  GAME METHODS --------------------//

//method to update the Title Bar of the Game
public void updateTitleBar(){

  if(!isGameOver()) {
    //set the title each loop
    surface.setTitle(titleText + "    " + extraText1 + " " + points + extraText2 + health);

    //adjust the extra text as desired
  
  }
}

//method to update what is drawn on the screen each frame
public void updateScreen(){

  //UPDATE: Background of the current Screen
  if(currentScreen.getBg() != null){
    background(currentScreen.getBg());
  }

  //UPDATE: splashScreen
  if(currentScreen == splashScreen && splashScreen.getScreenTime() > 3000 && splashScreen.getScreenTime() < 5000){
    System.out.print("s");
    currentScreen = level1Grid;
  }

  //UPDATE: level1Grid Screen
  if(currentScreen == level1Grid){
    System.out.print("1");
    currentGrid = level1Grid;

    //Display the Player1 image
    GridLocation player1Loc = new GridLocation(player1Row,0);
    level1Grid.setTileImage(player1Loc, player1);
    
    //update other screen elements
    level1Grid.showGridImages();
    level1Grid.showGridSprites();
    level1Grid.showWorldSprites();

    //move to next level based on a button click
    //b1.show();
    //if(b1.isClicked()){
    //   System.out.println("\nButton Clicked");
    //   currentScreen = level2World;
    // }
  
  }
  
  //UPDATE: level2World Scren
  if(currentScreen == level2World){
    System.out.print("2");
    currentWorld = level2World;
    currentGrid = null;
    
    level2World.moveBgXY(-3.0, 0);
    level2World.show();

    player2.show();

    level2World.showWorldSprites();

  }

  //UPDATE: End Screen

  //UPDATE: Any Screen
  // if(doAnimation){
  //   runningHorse.animateHorizontal(5.0, 10.0, true);
  // }


}

//Method to populate enemies or other sprites on the screen
public void populateSprites(){

  //What is the index for the last column?
      //Display the ship


  //Loop through all the rows in the last column
  if(points <= pointMax && health >= 0) {
    for (int r = 0; r < level1Grid.getNumRows(); r++) {

      GridLocation shipPlace = new GridLocation(r,level1Grid.getNumCols()-1) ;


      if(Math.random() < 0.2) {
        level1Grid.setTileImage(shipPlace,ship1);
      }
    }
  }
  

    //Generate a random number


    //10% of the time, decide to add an enemy image to a Tile
    

}

//Method to move around the enemies/sprites on the screen
public void moveSprites(){

//Loop through all of the rows & cols in the grid
for(int r = 0; r < level1Grid.getNumRows();r++) {
  for(int c = 0; c < level1Grid.getNumCols();c++){
    //int ran = (int) Math.random()*6;
    GridLocation loc = new GridLocation(r,c);
    GridLocation leftLoc = new GridLocation(r,c-1);

    if (ship1.equals(level1Grid.getTileImage(loc))) {
      level1Grid.clearTileImage(loc);

      //handling ships to the right of the robot
      if(c>=1){
    
        if(player1.equals(level1Grid.getTileImage(leftLoc))){
          health--;
        }
        else if(blaster.equals(level1Grid.getTileImage(leftLoc))){
          points++;
        }
        else{
          level1Grid.setTileImage(leftLoc,ship1);
        }
      }
      //handling ships in the first column
      if (c == 0){
        level1Grid.clearTileImage(loc);


      }

      //ran = (int) Math.random()*6;
    }
  }
}
}



//Method to move around the enemies/sprites on the screen
public void moveBlasters(){

  //Loop through all of the rows & cols in the grid
  for(int r = 0; r < level1Grid.getNumRows();r++) {
    for(int c = level1Grid.getNumCols()-2; c >= 1 ;c--){
      //int ran = (int) Math.random()*6;
      GridLocation loc = new GridLocation(r,c);
      GridLocation rightLoc = new GridLocation(r,c+1);
      
      if (blaster.equals(level1Grid.getTileImage(loc))) {
        level1Grid.clearTileImage(loc);
        
        //if something there --> obliterate ship and get points
        if( ship1.equals(level1Grid.getTileImage(rightLoc)) ) {
          level1Grid.clearTileImage(rightLoc);
          points++;
        } 
        //move to right if nothing is there
        else {
          level1Grid.setTileImage(rightLoc,blaster);
        }

        //ran = (int) Math.random()*6;
      }
    }
  }
}

//Method to check if there is a collision between Sprites on the Screen
public boolean checkCollision(GridLocation loc, GridLocation nextLoc){

  //Check what image/sprite is stored in the CURRENT location
  PImage image = level1Grid.getTileImage(loc);
  // AnimatedSprite sprite = grid.getTileSprite(loc);
  // float distance = dist(loc.getGridLocation(), nextLoc.getGridLocation());
  // if(distance == 0) {
  //   level1Grid.clearTileImage(nextLoc);
  // health = 0;
  // return true;
  // }
  // else{
  //   return false;
  // }
  //if empty --> no collision

  //Check what image/sprite is stored in the NEXT location
  // getGridLocation(nextLoc)
  //if empty --> no collision
  // if()
  //check if enemy runs into player

    //clear out the enemy if it hits the player (using cleartTileImage() or clearTileSprite() from Grid class)

    //Update status variable

  //check if a player collides into enemy

  return false; //<--default return
}



//method to indicate when the main game is over
public boolean isGameOver(){
  if (points > pointMax) {
    return true;
  } else if (health >= 0) {
    return false;
  }
  return true;
   //by default, the game is never over
}

//method to describe what happens after the game is over
public void endGame(){

  System.out.println("Game Over!");
  //Update the title bar
  if (points > pointMax && health >= 0) {
    currentScreen = winScreen;
  } else {
    currentScreen = loseScreen;
  }
    //Show any end imagery

}
