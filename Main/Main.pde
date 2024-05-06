import java.util.*; 
int timer;
int rez = 4;
int w;
int h;
float min=100;
int fillers=0;
PGraphics ctx;
PVector k;
int fps=60;
int frames;
int radius=5;
boolean squares=false;
PImage img;  // Declare a variable of type PImage
int speed= 100;
//Menu menu;
//Menu radiusMenu;
Direction dir=Direction.LEFT;
World world ;
NoiseInfo info;
float noiseScale=1000;
float persistance=0.6;
int octaves=8;
float lacunarity=2.5;
float Max=5;
float Min=0;
float riverRange=1.5;
float riverDeepness=0.0028400002;
//int seed =164571;
int seed=(int)random(1000000);
int XOffset=0;
int YOffset=0;
float ZOffset=0.2;
int maxChem=2500;
int quantity=maxChem;
int dissipation=10;
boolean colony = false;

LumberJack a;
Colony colonie;
void setup() { 
  
  //fullScreen(P3D);
  size(1280,1024,P3D);
  w = 1+width/rez;
  h = 1+height/rez;
  ctx=createGraphics(w,h);
  surface.setLocation(0,0);
  /*
  colonie = new Colony(new PVector(100,150));
  a=new LumberJack(new PVector(15,15),colonie);
  a.setState(new testState(a));
  colonie.ants.add(a);
  */
  ((PGraphicsOpenGL)g).textureSampling(2); // Prevent Processing from applying smoothing/filtering when we scale stuff
  info = new NoiseInfo(noiseScale, persistance,octaves, lacunarity, Max, Min, riverRange, riverDeepness,XOffset,YOffset,ZOffset, seed);
  noiseSeed(seed);
  world = new World(w,h,info); 
  //world.colonies.add(colonie);
  println(w + " " + h);
  println(world.grid.length + " " + world.grid[0].length); 
  println("seed : "+ seed);
  //frameRate(30);
  colonie = new Colony(new PVector(random(w),random(h)));
  //world.colonies.add(colonie);
  }
  //Update world
  public void draw(){   
   //colonie.food=0;
   //println(world.get(0,0).type.heat + " " + world.get(254,254).type.heat);
   frames=(int)frameRate;
   world.Update();
   world.draw(ctx);  
   if(colonie!=null)
   {
     if(colonie.ants.size()<=0){
        world.colonies.remove(colonie);
        colonie = new Colony(new PVector(random(w),random(h)));
        world.colonies.add(colonie);
        XOffset=(int)random(1000000);
        YOffset=(int)random(1000000);
        println("reset colony, now at " + XOffset + " , " + YOffset);
        info = new NoiseInfo(noiseScale, persistance,octaves, lacunarity, Max, Min, riverRange, riverDeepness,XOffset,YOffset,ZOffset, seed);
        world.setNoise(info);
     }
   }
  }
    
    
void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  noiseScale+=20*e;
  if(noiseScale<1)
    noiseScale=1; 
  info = new NoiseInfo(noiseScale, persistance,octaves, lacunarity, Max, Min, riverRange, riverDeepness,XOffset,YOffset,ZOffset, seed);
  world.setNoise(info);  
}

void keyPressed() {
  if(key==CODED)
  {
    switch(keyCode)
    {
      case LEFT:
        XOffset-=speed;
        break;
      case RIGHT:
        XOffset+=speed;
        break;
      case UP:
        YOffset-=speed;
        break;
      case DOWN:
        YOffset+=speed;
        break;
    }    
    info = new NoiseInfo(noiseScale, persistance,octaves, lacunarity, Max, Min, riverRange, riverDeepness,XOffset,YOffset,ZOffset, seed);
    world.setNoise(info);
  }
  if(key=='&' || key=='1')
  {
    world.Layer1=!world.Layer1;
    println(world.Layer1);
  }
  if(key=='é' || key=='2')
  {
    world.Ants=!world.Ants;
    println(world.Ants);
  }
  if(key=='"' || key=='3')
  {
    riverDeepness+=0.001;
    println(riverDeepness);
    info = new NoiseInfo(noiseScale, persistance,octaves, lacunarity, Max, Min, riverRange, riverDeepness,XOffset,YOffset,ZOffset, seed);
    world.setNoise(info);    
  }
  if(key=='\'' || key=='4')
  {
    riverDeepness-=0.001;
    println(riverDeepness);
    info = new NoiseInfo(noiseScale, persistance,octaves, lacunarity, Max, Min, riverRange, riverDeepness,XOffset,YOffset,ZOffset, seed);
    world.setNoise(info);    
  }
  if(key=='(' || key=='5')
  {
    riverRange+=0.1;
    println(riverRange);
    info = new NoiseInfo(noiseScale, persistance,octaves, lacunarity, Max, Min, riverRange, riverDeepness,XOffset,YOffset,ZOffset, seed);
    world.setNoise(info);    
  }
  if(key=='-' || key=='6')
  {
    riverRange-=0.1;
    println(riverRange);
    info = new NoiseInfo(noiseScale, persistance,octaves, lacunarity, Max, Min, riverRange, riverDeepness,XOffset,YOffset,ZOffset, seed);
    world.setNoise(info);    
  }
  if(key=='m')
  {
    println(seed);
  }
  if(key=='p')
  {
    world.Gizmo=!world.Gizmo;
    //println(world.Gizmo);
    //world.rect=!world.rect;
  }
}

public void mouseClicked(){
  /*if(mouseButton==LEFT){
     int X = mouseX/rez;
     int Y = mouseY/rez;
     Cell c = world.get(X,Y);     
     Filler f = new Filler(w,h,c,2);
     while(!f.workComplete())
     {
       f.Work();
     }
     println(f.count);
     for(Map.Entry<PVector,Cell> entry : ((Selector)f.func).getTargets().entrySet())
     {
       Cell cc = entry.getValue();
       cc.addRecruit(maxChem);
     }
  }*/
  
  if(mouseButton==LEFT)
  {
     int X = mouseX/rez;
     int Y = mouseY/rez;
     PVector p = new PVector(X,Y);
     if(!colony)
     {
       world.addColony(p);
       colony = true;
     }
  }
  
  /*
  if(mouseButton==LEFT)
  {
     int X = mouseX/rez;
     int Y = mouseY/rez;
     a.GoTo(world.get(X,Y));
  }
  */
}
public void mouseDragged()
{
  
  if(mouseButton==RIGHT){
     int X = mouseX/rez;
     int Y = mouseY/rez;
     Cell c = world.get(X,Y);     
     Filler f = new Filler(w,h,c,2);
     while(!f.workComplete())
     {
       f.Work();
     }
     println(f.count);
     for(Map.Entry<PVector,Cell> entry : ((Selector)f.func).getTargets().entrySet())
     {
       Cell cc = entry.getValue();
       cc.addGoBack(quantity);
       quantity-=2;
     }
  }
  
  if(mouseButton==CENTER){
     int X = mouseX/rez;
     int Y = mouseY/rez;
     Cell c = world.get(X,Y);     
     Filler f = new Filler(w,h,c,2);
     while(!f.workComplete())
     {
       f.Work();
     }
     println(f.count);
     for(Map.Entry<PVector,Cell> entry : ((Selector)f.func).getTargets().entrySet())
     {
       Cell cc = entry.getValue();
       cc.addRecruit(quantity);
       quantity-=2;
     }
  }
 /* if(mouseButton==LEFT){
     int X = mouseX/rez;
     int Y = mouseY/rez;
     Cell c = world.get(X,Y);     
     Filler f = new Filler(w,h,c,20);
     while(!f.workComplete())
     {
       f.Work();
     }
     for(Map.Entry<PVector,Cell> entry : ((Selector)f.func).getTargets().entrySet())
     {
       Cell cc = entry.getValue();
       cc.addRecruit(maxChem);
     }
  }*/
  /*
  if(mouseButton==LEFT)
  {
     int X = mouseX/rez;
     int Y = mouseY/rez;
     a.GoTo(world.get(X,Y));  
  }
  */  
}
public void mouseReleased(){
  k=null;
  quantity=maxChem;
}

public HashMap<PVector,Cell> circle(int x, int y,Cell c){  
  Cell cc = world.get((int)x,(int)y);
  Filler f = new Filler(w, h,cc,20); 
  while(f.queue.size()>0)
  {
    f.Work();
  } 
  c=((Selector)f.func).origin;
  return ((Selector)f.func).getTargets();  
}

public void line(int x, int y,Element type){
      PVector u = new PVector(x,y);
     if(k==null)
       k=u;
     int x1,x2,y1,y2,dx,dy,e;        
     x1 = round(k.x);
     x2 = round(u.x);
     y1 = round(k.y);
     y2 = round(u.y);      
     dx=x2-x1;
     dy=y2-y1;
     if(dx!=0)
     {
      if(dx>0)
      {
       if(dy!=0)
       {
         if( dy>0)
         {
           //valeur oblique dans le premier quadran.
           if(dx>=dy)
           {           
             //Vecteur diagonal ou oblique proche de l'horizontale, dans le premier octant
             e=dx;
             dy*=2;
             dx*=2;
             while(x1<x2) // boucle horizontale
             {
                world.get(x1,y1).addGoBack(maxChem);
               e-=dy;
               if(e<0)
               {
                y1++;
                 world.get(x1,y1).addGoBack(maxChem);
                e+=dx;
               }
               x1++;
             }
           }       
           else //oblique proche de la vertical du 2em octant
            {    
              e=dy;
              dy*=2;
              dx*=2;
              while(y1<y2) // boucle  verticale
              {                
                 world.get(x1,y1).addGoBack(maxChem);
                e-=dx;
                if(e<0)
                {
                 x1++;
                  world.get(x1,y1).addGoBack(maxChem);
                 e+=dy;
                }
                y1++;
              }        
            }         
         }
         else // dy<0 et dx >0
         {
           if(dx>=-dy) // diagonal ou oblique proche de l'horizontale du 8° octant
           {
             e=dx;
             dx*=2;
             dy*=2;
             while(x1<x2) //horizontal
             {             
                world.get(x1,y1).addGoBack(maxChem);
               e+=dy;
               if(e<0)
               {
                 y1--;
                  world.get(x1,y1).addGoBack(maxChem);
                 e+=dx;
               }
               x1++;
             }
           }
           else //vecteur oblique proche de la verticale, 7em octant
           {
             e=dy;
             dx*=2;
             dy*=2;
             while(y1>y2) //vertical
             {             
                world.get(x1,y1).addGoBack(maxChem);
               e+=dx;
               if(e>0)
               {
                 x1++; //diagonal
                  world.get(x1,y1).addGoBack(maxChem);
                 e+=dy;
               }
               y1--;
             }           
           }
         }
       }
       //jee ne rentree JAMAIS dans cette condition ?? :/
       
       else // dy == 0
       {
         while(x1<x2)
         {
           world.get(x1,y1).addGoBack(maxChem);
           x1++;
         }         
       }
     }
     else //dx < 0
     {
       dy=y2-y1;
       if(dy!=0)
       {
         if(dy>0) // oblique 2° quadran
         {
           if(-dx>=dy) //diagonal ou oblique proche de l'horizontale du 4° octant
           {
             e=dx;
             dx*=2;
             dy*=2;
             while(x1>x2){ //horizontal
                world.get(x1,y1).addGoBack(maxChem);
               e+=dy;
               if(e>=0)
               {
                 y1++; //diagonal
                  world.get(x1,y1).addGoBack(maxChem);
                 e+=dx;
               }
               x1--;
             }
           }
           else //oblique proche de la vertical du 3° octant
           {
             e=dy;
             dx*=2;
             dy*=2;
             while(y1<y2){
                world.get(x1,y1).addGoBack(maxChem);
               e+=dx;
               if(e<=0)
               {
                 x1--;
                  world.get(x1,y1).addGoBack(maxChem);
                 e+=dy;
               }
               y1++;
             }             
           }
         }
         else //dy < 0 et dx <0
         {
           if(dx<=dy) // 5°octant
           {
             e=dx;
             dx*=2;
             dy*=2;
             while(x1>x2) //horizontal
             {
                world.get(x1,y1).addGoBack(maxChem);
               e-=dy;
               if(e>=0)
               {
                 y1--; //diagonal
                  world.get(x1,y1).addGoBack(maxChem);
                 e+=dx;
               }
               x1--;
             }
           }
           else //6° octant
           {
             e=dy;
             dx*=2;
             dy*=2;
             while(y1>y2){
                world.get(x1,y1).addGoBack(maxChem);
               e-=dx;
               if(e>=0)
               {
                 x1--;
                  world.get(x1,y1).addGoBack(maxChem);
                 e+=dy;
               }
               y1--;
             }
           }
         }         
       }
       else //dy = 0 et dx <0
       {
         while(x1>x2)
         {
           world.get(x1,y1).addGoBack(maxChem);
           x1--;           
         }
       }
     }
   }
   else //dx==0
   {
     dy=y2-y1;
     if(dy!=0)
     {
       if(dy>0)
       {
         while(y1<y2)
         {
            world.get(x1,y1).addGoBack(maxChem);
           y1++;
         }
       }
       else
       {
         while(y1>y2)
         {
            world.get(x1,y1).addGoBack(maxChem);
           y1--;
         }
       }
      }
   }
  k=u; 
}
