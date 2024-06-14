/* Button Class - Used to add a button into a Game
 * Author: Joel Bianchi
 * Last Edit: 6/11/2024
 * Ability to turn highlights on/off
 * Ability to adjust font size
 */


public class Button {

    //------------------ BUTTON FIELDS --------------------//
    private String caption;
    private float fontFactor;
    private String shape;
    private float shapeX, shapeY;     //coordinates of CENTER of button shape
    private float shapeW, shapeH;     //size of shape in pixels
    private color baseColor;
    private color hoverColor;
    private color clickColor;
    private color currentColor;
    private boolean isVisible;
    private boolean doesHoverHighlight;
    private boolean doesClickHighlight;


    //------------------ BUTTON CONSTRUCTORS --------------------//

    //Button Constructor #1
    public Button(String shape, float x, float y, float w, float h, String txt) {
        //super(null,1.0, x, y,false);
        this.shape = shape;
        this.shapeW = w;
        this.shapeH = h;
        this.shapeX = x + (shapeW/2);
        this.shapeY = y + (shapeH/2);
        
        this.caption = txt;
        this.fontFactor = 0.9;
        this.baseColor = color(255, 255, 0);   //yellow
        this.doesHoverHighlight = true;
        this.hoverColor = color(0,0,255); //blue
        this.doesClickHighlight = true;
        this.clickColor = color(255,0,0); //red
        this.currentColor = baseColor;
        this.isVisible = true;


    }


    //------------------ BUTTON METHODS --------------------//

    //Button method to be called each cycle -- ie. inside draw() or updateScreen() 
    void show() {
        
        //Sets outline stroke around button (3 pixels, BLACK)
        strokeWeight(2);
        stroke(0);

        //Sets color of button based on Mouse hover
        if (doesClickHighlight && isClicked()) {
            currentColor = clickColor;
        } else if (doesHoverHighlight && isMouseOverButton()){
            currentColor = hoverColor;
        } else {
            currentColor = baseColor;
        }

        //Set color inside Button
        fill(currentColor);

        //Only show the button if visible
        if(isVisible){

            //Draws particular Button Shape
            if(shape.equals("circle")){
                ellipseMode(CENTER);
                ellipse(shapeX, shapeY, shapeW, shapeH);
            //     System.out.println("circle shape");
            } else if(shape.equals("rect")){
                rectMode(CENTER);
                rect(shapeX, shapeY, shapeW, shapeH);
                // System.out.println("rect shape");
            } else {
                System.out.println("Wrong shape String.  Type \"rect\" or \"circle\"");
                return;
            }

            //Set Text inside Button
            fill(0); //set font color to black
            float fontSize = shapeH/2 * fontFactor;
            textSize(fontSize);
            float tw = textWidth(caption);
            float tx = shapeX - (tw/2);
            float ty = shapeY + (fontSize / 2);
            text(caption, tx, ty);

        }
    }


    //------------------ BUTTON HOVERING METHODS --------------------//

    public boolean isClicked(){
        if (isMouseOverButton() && mousePressed) {
            System.out.println("Button Clicked");
            return true;
        } else{
            return false;
        }
    }
    
    public boolean isMouseOverButton(){ //move to Sprite class eventually
        if(shape.equals("rect")){
            return isOverRect();
        } else if(shape.equals("circle")){
            return isOverCircle();
        } else {
            return false;
        }
    }
    
    private boolean isOverRect(){
        if(mouseX >= shapeX-shapeW/2 && mouseX <= shapeX+shapeW/2
            && mouseY >= shapeY-shapeH/2 && mouseY <= shapeY+shapeH/2){
            return true;
        } else {
            return false;
        }
    }

    private boolean isOverCircle(){
        float diameter = shapeH;
        float disX = shapeX - mouseX;
        float disY = shapeY - mouseY;
        if (sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
            return true;
        } else {
            return false;
        }
    }

//------------------ BUTTON MUTATOR METHODS --------------------//

    public void setText(String caption){
        this.caption = caption;
    }
    public void setFontFactor(float ff){
        this.fontFactor = ff;
    }
    public void setButtonColor(color c){
        this.baseColor = c;
    }
    public void setHoverHighlight(boolean b){
        this.doesHoverHighlight = b;
    }

    //Method to pass in a Processing color or null
    //ie. color(0,0,255) for blue
    public void setHoverColor(Integer hoverColor){
        if(hoverColor != null){
            setHoverHighlight(true);
            this.hoverColor = hoverColor;
        } else {
            setHoverHighlight(false);
        }
    }
    public void setClickHighlight(boolean b){
        this.doesClickHighlight = b;
    }

    //Method to pass in a Processing color or null
    //ie. color(0,0,255) for blue
    public void setClickColor(Integer clickColor){
        if(clickColor != null){
            setClickHighlight(true);
            this.clickColor = clickColor;
        } else {
            setClickHighlight(false);
        }
    }
    public void setVisible(boolean b){
        this.isVisible = b;
    }


    public String toString(){
        return "Button shape " + this.shape + " with text \"" + this.caption + "\" @loc " + this.shapeX +","+this.shapeY + " w:"+this.shapeW+" h:"+this.shapeH;
    }



} //end Button class