Color[] colors;
int i = 0;
int x = 0;
int w = 1; //width of the stripes
boolean swapEverything = false;
int transFrames = 60;

int[] alphas = new int[10];
boolean finished = false;
boolean transition = false;
int transFrame = 0;


void setup(){
  size(600,600);
  
  colors = new Color[width/w];
  for(int i=0; i<colors.length; i++){
    //int r = (int) random(255);
    //int r = (int)(noise(i/100.0)*255);
    int r = (int) (sin(((float)i/(colors.length/1.0))*PI)*255);
    r = Math.abs(r);
    //colors[i] = new Color(r,r,r);
    colors[i] = new Color((int) random(255), (int) random(255), (int) random(255));
  }
  
  for(int j=0; j<alphas.length; j++){
      alphas[j] = (int) (sin((j/(alphas.length-1.0))*PI)*255);
  }
}

void draw(){
  if(!finished){
    if(transition){
      transFrame();
    }else{
      sortFrame();
    }
  }
}

//runs every frame during the sorting animation
void sortFrame(){
  for(int j=0; j < 5; j++){
    if(calculate() == false){
      return;
    }
  }
  
  background(0);
  
  for(int i=0; i<colors.length; i++){
    float posy = (colors[i].v[x]/255.0)*(height-alphas.length);
    drawStripe(i, posy);
  }
}

//does the bubble sort
boolean calculate(){
  for(int j=0; j < colors.length-i-1; j++){
    if(colors[j].v[x] > colors[j+1].v[x]){
      //swap
      if(swapEverything){
        int[] temp = colors[j].v;
        colors[j].v = colors[j+1].v;
        colors[j+1].v = temp;
      }else{
        int temp = colors[j].v[x];
        colors[j].v[x] = colors[j+1].v[x];
        colors[j+1].v[x] = temp;
      }
    }
  }
  
  i++;
  if(i>colors.length){
    i=0;
    x++;
    if(x>2){
      finished = true;
    }
    transition = true;
    transFrame = 0;
    return false;
  }
  return true;
}

//runs every frame during the transition between colors
void transFrame(){
  if(transFrame < transFrames){
    background(0);
    
    for(int i=0; i<colors.length; i++){
      float posYStart = (colors[i].v[x-1]/255.0)*(height-alphas.length);
      float posYEnd = (colors[i].v[x]/255.0)*(height-alphas.length);
      float posy = lerp(posYStart, posYEnd, transFrame/(float)transFrames);
      drawStripe(i, posy);
    }
  }
  
  transFrame++;
  if(transFrame > transFrames){
    transition = false;
  }
}

void drawStripe(int i, float posy){
  for(int j=0; j<alphas.length; j++){
    stroke(colors[i].v[0], colors[i].v[1], colors[i].v[2], alphas[j]);
    point(i*w, posy+j);
  }
}
