public class World {
  public Chunk[][] grid; 
  PVector ChunkSize=new PVector(16,16);
  public int callInspector;
  Colony colony;
  int tick;
  int H;
  int W;
  PVector size;
  float smax=0;
  float emin=100;
  final float dt=0.1;
  boolean needRedraw;
  boolean Layer1;
  boolean Gizmo;
  boolean Ants;
  boolean rect;
  NoiseInfo info;
  ArrayList<Colony> colonies;
  public World(int w, int h,NoiseInfo info){
    size=new PVector(w,h);
    W=(int)(w/ChunkSize.x) +1;
    H=(int)(h/ChunkSize.y) +1;
    Layer1=false;
    Ants=true;
    Gizmo=false;
    rect=false;
    this.info=info;
    grid=new Chunk[H][W];
    colonies=new ArrayList<Colony>();
    for(int y = 0; y <  H; y++){
      for(int x = 0; x< W; x++){
          grid[y][x]=new Chunk(new PVector(x,y),ChunkSize,info,this);
      }
    }  
  }
  public void addColony(PVector p){
    colonies.add(new Colony(p));
  }
  public void removeColonie(PVector p){
    colonies.add(new Colony(p));
  }
  public void Update(){
    callInspector=0;
    
    for(Colony c : colonies){
        c.Update();
    }

    if(needRedraw)
    {
      for(int y = 0; y <  H; y++){
        for(int x = 0; x< W; x++){
            grid[y][x]=new Chunk(new PVector(x,y),ChunkSize,info,this);
        }
      }
      needRedraw=false;      
    }
      for(int y = 0; y <  H; y++){
        for(int x = 0; x< W; x++){
          if(grid[y][x].active)
          {
            grid[y][x].Update();
          }
        }
      }
      if(tick/frameRate>=1)
      {
        for(int y = 0; y <  H; y++){
          for(int x = 0; x< W; x++){
              //grid[y][x].Update();            
              grid[y][x].setActive(true);            
          }
        }
        tick=0;
      }
      tick++;
  }
  
    
  public void setNoise(NoiseInfo info)
  {
    this.info=info;
    needRedraw=true;
  }
  public void draw(PGraphics ctx){    
  //draw world
   ctx.beginDraw();
   ctx.loadPixels();
   if(Ants){
     for(int y = 0; y < h; y++){
       for(int x = 0; x< w; x++){         
         Cell c=get(x,y);
         pheromone[] p= get(x,y).getChems();
         if(c.type.getType()>=3)
         {
           int r=c.type.r + p[0].r*2 + p[1].r*2,
               g=c.type.g + p[0].g*2 + p[1].g*2,
               b=c.type.b + p[0].b*2 + p[1].b*2;
           ctx.pixels[x+y*w]=color(r,g,b);    
         }
         else
         {
           int r= p[0].r*2 + p[1].r*2,
               g= p[0].g*2 + p[1].g*2,
               b= p[0].b*2 + p[1].b*2;
           ctx.pixels[x+y*w]=color(r,g,b);    
         }

       }
    }
  }
  else
  {
     for(int y = 0; y < h; y++){
       for(int x = 0; x< w; x++){
         Cell c=get(x,y);         
         ctx.pixels[x+y*w]=color(c.type.r,c.type.g,c.type.b);
       }
     }
  }

    for(Colony co : colonies){
     for(Ant a : co.ants)
     {
       if(Gizmo)
       {
        HashMap<PVector,Cell> cells = a.LookForward();
         for(Map.Entry<PVector,Cell> entry : cells.entrySet()){
            Cell c =(Cell) entry.getValue();
            if(c!=null)
              ctx.pixels[(int)c.posInWorld.x+(int)c.posInWorld.y*w]=color(255,255,255);
         }
         cells = a.LookLeft();
         for(Map.Entry<PVector,Cell> entry : cells.entrySet()){
            Cell c =(Cell) entry.getValue();
            if(c!=null)
              ctx.pixels[(int)c.posInWorld.x+(int)c.posInWorld.y*w]=color(255,0,0);
         }
         cells = a.LookRight();
         for(Map.Entry<PVector,Cell> entry : cells.entrySet()){
            Cell c =(Cell) entry.getValue();
            if(c!=null)
              ctx.pixels[(int)c.posInWorld.x+(int)c.posInWorld.y*w]=color(0,0,255);
         }
         
         if(a!=null&&a.destination!=null)
         {
           PVector d1= a.posInWorld.copy().add(a.velocity);
           ArrayList<PVector> l1 = line(a.posInWorld,d1);
           for(PVector p : l1){
             Cell c = world.get((int)p.x,(int)p.y);
             if(c!=null&&((int)c.posInWorld.x+(int)c.posInWorld.y*w)<ctx.pixels.length)
               ctx.pixels[(int)c.posInWorld.x+(int)c.posInWorld.y*w]=color(0,255,0);
           }
           PVector d2= a.posInWorld.copy().add(a.acceleration);
           ArrayList<PVector> l2 = line(a.posInWorld,d2);
           for(PVector p : l2){
             Cell c = world.get((int)p.x,(int)p.y);
             if(c!=null)
               ctx.pixels[(int)c.posInWorld.x+(int)c.posInWorld.y*w]=color(255,255,0);
           }
           ctx.pixels[(int)a.destination.posInWorld.x+(int)a.destination.posInWorld.y*w]=color(255,255,0);
         }
       }
       //if(a._CurrentState instanceof ExploringState)
         ctx.pixels[(int)a.posInWorld.x+(int)a.posInWorld.y*w]=color(255,255,0); 
       /*else if(a._CurrentState instanceof HomeState)
         ctx.pixels[(int)a.posInWorld.x+(int)a.posInWorld.y*w]=color(255,0,255); 
       else
         ctx.pixels[(int)a.posInWorld.x+(int)a.posInWorld.y*w]=color(255,255,255); 
        */ 
     }
     
     HashMap<PVector,Cell> circle = co.getCircle();
     for(Map.Entry<PVector,Cell> entry : circle.entrySet()){
       Cell c = entry.getValue();
       ctx.pixels[(int)c.posInWorld.x +(int)c.posInWorld.y*w]=color(255,0,255);       
     }
     
     ctx.pixels[(int)co.posInWorld.x +(int)co.posInWorld.y*w]=color(255,255,255);
   }
   if(rect)
   {     
     for(int y = 0; y <  H; y++){
      for(int x = 0; x< W; x++){
        if(grid[y][x].active)
        {
          PVector p1,p2,p3,p4;
          p1=grid[y][x].localToWorld(grid[y][x].pos);
          p2=grid[y][x].localToWorld(new PVector(grid[y][x].size.x+grid[y][x].pos.x, grid[y][x].pos.y));
          p3=grid[y][x].localToWorld(new PVector(grid[y][x].size.x+grid[y][x].pos.x, grid[y][x].pos.y+grid[y][x].size.y));
          p4=grid[y][x].localToWorld(new PVector(grid[y][x].pos.x, grid[y][x].pos.y+grid[y][x].size.y));
          ArrayList<PVector> l1=line(p1,p2);
          ArrayList<PVector> l2=line(p2,p3);
          ArrayList<PVector> l3=line(p3,p4);
          ArrayList<PVector> l4=line(p4,p1);
          for(PVector p : l1){
            if(p.x<w && p.y<h)            
              ctx.pixels[(int)p.x+(int)p.y*w]=color(0,255,0);
          }
          for(PVector p : l2){
            if(p.x<w && p.y<h)
              ctx.pixels[(int)p.x+(int)p.y*w]=color(0,255,0);
          }
          for(PVector p : l3){
            if(p.x<w && p.y<h)
              ctx.pixels[(int)p.x+(int)p.y*w]=color(0,255,0);
          }
          for(PVector p : l4){
            if(p.x<w && p.y<h)
              ctx.pixels[(int)p.x+(int)p.y*w]=color(0,255,0);
          }
        }
      }
     }
   }
   ctx.updatePixels();
   ctx.stroke(255,255,255);
   int X = mouseX/rez;
   int Y = mouseY/rez;
   Cell curr=world.get(X,Y);
   pheromone[] ph=curr.getChems();
   ctx.text("fps :" +(int)frameRate +'\n'+ curr+'\n' + "||"+ph[0]+","+ph[1]+"||",10,10);
   for(Colony c : colonies){
     ctx.text(c.ants.size()+" || " + c.food + " ( "+ (c.food-c.lastFood)+" )",c.posInWorld.x-20,c.posInWorld.y);          
   }
   ctx.endDraw();
   scale(rez);
   image(ctx,0,0);    
  }
  public ArrayList<PVector> line(PVector a,PVector p){
    ArrayList<PVector> cells=new ArrayList<PVector>();     
     int x1 =round(a.x);
     int x2 =round(p.x);
     int y1 =round(a.y);
     int y2 =round(p.y);
     int dx,dy,e;
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
             while(x1<=x2) // boucle horizontale
             {
                     
               cells.add(new PVector(x1,y1));
               e-=dy;
               if(e<0)
               {
                y1++;
  
                cells.add(new PVector(x1,y1));
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
              while(y1<=y2) // boucle  verticale
              {           
                      
                  cells.add(new PVector(x1,y1));
                e-=dx;
                if(e<0)
                {
                 x1++;
                       
                   cells.add(new PVector(x1,y1));
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
             while(x1<=x2) //horizontal
             {    
                     
                 cells.add(new PVector(x1,y1));
               e+=dy;
               if(e<0)
               {
                 y1--;

                      
                   cells.add(new PVector(x1,y1));
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
             while(y1>=y2) //vertical
             {             
                   
                 cells.add(new PVector(x1,y1));
               e+=dx;
               if(e>0)
               {
                 x1++; //diagonal
                       
                   cells.add(new PVector(x1,y1));
                 e+=dy;
               }
               y1--;
             }           
           }
         }
       }
       else // dy == 0
       {
         while(x1<=x2)
         {
               
             cells.add(new PVector(x1,y1));
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
             while(x1>=x2){ //horizontal
                     
                 cells.add(new PVector(x1,y1));
               e+=dy;
               if(e>=0)
               {
                 y1++; //diagonal
                      
                   cells.add(new PVector(x1,y1));
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
             while(y1<=y2){
                     
                 cells.add(new PVector(x1,y1));
               e+=dx;
               if(e<=0)
               {
                 x1--;
                       
                   cells.add(new PVector(x1,y1));
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
             while(x1>=x2) //horizontal
             {
                     
                 cells.add(new PVector(x1,y1));
               e-=dy;
               if(e>=0)
               {
                 y1--; //diagonal
                       
                   cells.add(new PVector(x1,y1));
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
             while(y1>=y2){
                    
                 cells.add(new PVector(x1,y1));
               e-=dx;
               if(e>=0)
               {
                 x1--;
                    
                   cells.add(new PVector(x1,y1));
                 e+=dy;
               }
               y1--;
             }
           }
         }         
       }
       else //dy = 0 et dx <0
       {
         while(x1>=x2)
         {
              
             cells.add(new PVector(x1,y1));
           x1--;           
         }
       }
     }
   }
   else
   {
     dy=y2-y1;
     if(dy!=0)
     {
       if(dy>0)
       {
         while(y1<=y2)
         {
                
             cells.add(new PVector(x1,y1));
           y1++;
         }
       }
       else
       {
         while(y1>=y2)
         {
              
             cells.add(new PVector(x1,y1));
           y1--;
         }
       }
      }
   }
   return cells;   
  }

  public Chunk getChunk(int x,int y){
     return grid[y][x];
  }
  public Chunk getChunkFrom(int x, int y){
    int X,Y;
    X=x/(int)ChunkSize.x;
    Y=y/(int)ChunkSize.y;
    
    return grid[Y][X];
  }
  public Cell get(int x, int y){
    int X,Y;
    X=x/(int)ChunkSize.x;
    Y=y/(int)ChunkSize.y;
    if(X>=W || X<0 || Y>=H || Y<0)
      return null;
      
    return grid[Y][X].get((int)(x-X*ChunkSize.x),(int)(y-Y*ChunkSize.y));
  } 
  
  public pheromone[] chems(int x, int y){
    int X,Y;
    X=x/(int)ChunkSize.x;
    Y=y/(int)ChunkSize.y;
    return grid[Y][X].get((int)(x-X*ChunkSize.x),(int)(y-Y*ChunkSize.y)).getChems();
  } 
}
