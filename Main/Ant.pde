public abstract class Ant{
  PVector posInWorld;
  PVector direction;
  WorkingState _CurrentState;
  int range=6;
  float rotation=3;
  float halfRad=45;
  PVector velocity;
  PVector acceleration;
  float maxSpeed=1;
  float maxForce=0.5;
  float wand=0.7;
  float steerStrength=0.5;
  float wRad=64;
  int depletion=3;
  Colony colony;
  Cell destination;
  int quantity;
  int energy;
  boolean Moving;
  PVector lastPos;  
  HashMap<Integer, WorkingState> _states;
  int count;
  public Ant(PVector posInWorld,Colony colony){
    this.direction=Polar(random(360f)*PI/180,range);
    this.posInWorld=posInWorld;
    this.colony=colony;
    this.acceleration=new PVector();
    this.velocity=new PVector();
    quantity=maxChem;
    onCreate();
    Moving=false;
    count=0;
  }  
  abstract void onCreate();
  
  public void setState(WorkingState state){
    if(_CurrentState!=null)
    {
      _CurrentState.OnStateExit();      
    }
    _CurrentState=state;
  }
  
  public void trail(boolean Home)
  {
    Cell c = world.get(round(posInWorld.x),round(posInWorld.y));      
    if(Home)
    {
      c.addRecruit(quantity);
      quantity-=depletion;
    }
    else
    {
      c.addGoBack(quantity);
      quantity-=depletion;
    } 
    if(quantity<0)
      quantity=0;
  }
  
  public void refill()
  {
    energy=100;
    quantity=(int)(maxChem*0.5);
  }
  public boolean handleTree(){
    if(destination!=null && destination.type instanceof Tree)
      return true;
    else
      return false;
  }
  public PVector rotate(PVector p, float angle){
    float a = angle*PI/180;        
    return new PVector(p.x*PApplet.cos(a)-p.y*PApplet.sin(a),p.x*PApplet.sin(a)+p.y*PApplet.cos(a));    
  }
  
  void seek(PVector target) {
    PVector desired = PVector.sub(target,posInWorld);
    desired.normalize();
    desired.mult(maxSpeed);
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(maxForce);
    ApplyForce(steer);
  }
  void arrive(PVector target) {
    PVector desired = PVector.sub(target,posInWorld); 
    float d = desired.mag();
    desired.normalize();
    desired.mult(maxSpeed);
    if (d < range) {
      float m = map(d,0,range,0,maxSpeed);
      if(m>0 && m<0.5)
      {
        m=0.5;
      }      
      desired.limit(m);
    }
    else
     desired.limit(maxSpeed);
    PVector steer = PVector.sub(desired,velocity); 
    steer.limit(maxForce);
    ApplyForce(steer);
  }
  public void Update(){    
      world.getChunkFrom((int)posInWorld.x,(int)posInWorld.y).setActive(true);
      _CurrentState.Update();      
      velocity.add(acceleration);
      velocity.limit(maxSpeed);      
      if(!ApplyVelocity())
      {
        velocity.mult(-1f);
        destination=null;
        println("doh !" + (destination!=null?destination.type:"out"));
        setState(new ExploringState(this));
      }
      PVector p = posInWorld.copy().sub(lastPos);
      if(p.x!=0 || p.y!=0)
      {
        direction=p;
        direction.normalize();
        direction.mult(range);
      }
      if(destination!=null)
      {
        if(destination.posInWorld.equals(posInWorld))
        {
          destination=null;
          velocity.mult(0);
        }
        else
        {
          seek(destination.posInWorld);
        }
      }
      else
      {
        Moving=false;
      }
      count++;
  }

  public void wander(){
    float rad=10;
    PVector p =Polar((velocity.heading()+random(360))*PI/180,rad/2);
    PVector target=velocity.copy();
    target.setMag(range);
    target.add(posInWorld);
    target.add(p);
    //p.limit(wand);
    seek(target);
  }
  PVector Polar(float a, float r ){    
    //float a = angle*PApplet.PI / 180;        
    float dx=r*cos(a),dy=r*sin(a);
    return new PVector(dx,dy);
  }
  public void GoTo(Cell c)
  {
    if(c!=null)
    {
      destination=c;
      Moving=true;     
    }
  }
  public void forward(){
    PVector target = direction.copy();
    target.setMag(4);
    GoTo(world.get((int)target.x,(int)target.y));
  }
  
  public HashMap<PVector,Cell> LineOfSight(){
    int n =14;
    PVector[] rays=new PVector[n];
    float e=(halfRad*2)/n;
    Cell c = world.get(round(posInWorld.x),round(posInWorld.y));
    PVector start=new PVector(direction.x,direction.y);
    HashMap<PVector,Cell> cells=c.line(new PVector(posInWorld.x+start.x,posInWorld.y+start.y));
    for(int i =0;i<n;i++){
      rays[i]=rotate(start,e*(i+1));
      HashMap<PVector,Cell> ce = c.line(new PVector(posInWorld.x+rays[i].x,posInWorld.y+rays[i].y));
      for(Map.Entry<PVector,Cell> entry : ce.entrySet())
      {
        if(entry.getValue()!=null&& !entry.getValue().posInWorld.equals(posInWorld));
        {
            cells.put(entry.getKey(),entry.getValue());
        }
      }
    }
    return cells;
  }
  public HashMap<PVector,Cell> LookForward(){
    int n =5;
    PVector[] rays=new PVector[n];
    float e=(halfRad*2)/(n*3); 
    PVector start= direction.copy();
    start.setMag(range*0.5);
    Cell c = world.get((int)posInWorld.x,(int)posInWorld.y);
    HashMap<PVector,Cell> cells=c.line(new PVector(posInWorld.x+start.x,posInWorld.y+start.y));
    for(int i =0;i<n;i++){
      rays[i]=rotate(start,e*(i+1));   
      HashMap<PVector,Cell> ce = c.line(new PVector(posInWorld.x+rays[i].x,posInWorld.y+rays[i].y));
      for(Map.Entry<PVector,Cell> entry : ce.entrySet())
      {
        if(entry.getValue()!=null&& !entry.getValue().posInWorld.equals(posInWorld));
          cells.put(entry.getKey(),entry.getValue());
      }
    }
    
    /*
    PVector start=direction.copy();    
    start.setMag(range*0.5);
    start.add(posInWorld);
    Cell c = world.get((int)start.x,(int)start.y);
    Filler f = new Filler(w,h,c,3);
    while(!f.workComplete())
    {
      f.Work();
    }
    
    HashMap<PVector,Cell> cells =((Selector)f.func).getTargets();
    
    */
    return cells;
  } 
  public HashMap<PVector,Cell> LookLeft(){
    int n =5;
    PVector[] rays=new PVector[n];
    float e=(halfRad*2)/(n*3); 
    PVector start=rotate(direction,-halfRad);
    start.setMag(range*0.5);
    Cell c = world.get((int)posInWorld.x,(int)posInWorld.y);
    HashMap<PVector,Cell> cells=c.line(new PVector(posInWorld.x+start.x,posInWorld.y+start.y));
    for(int i =0;i<n;i++){
      rays[i]=rotate(start,e*(i+1));   
      HashMap<PVector,Cell> ce = c.line(new PVector(posInWorld.x+rays[i].x,posInWorld.y+rays[i].y));
      for(Map.Entry<PVector,Cell> entry : ce.entrySet())
      {
        if(entry.getValue()!=null&& !entry.getValue().posInWorld.equals(posInWorld));
          cells.put(entry.getKey(),entry.getValue());
      }
    }
    
    /*
    PVector start=rotate(direction,-halfRad*1.2);
    start.setMag(range*0.5);
    start.add(posInWorld);
    Cell c = world.get((int)start.x,(int)start.y);
    Filler f = new Filler(w,h,c,3);
    while(!f.workComplete())
    {
      f.Work();
    }
    
    HashMap<PVector,Cell> cells =((Selector)f.func).getTargets();
    */
    return cells;
  } 
  public HashMap<PVector,Cell> LookRight(){
    int n =5;
    PVector[] rays=new PVector[n];
    float e=(halfRad*2)/(n*3); 
    PVector start=rotate(direction,halfRad);
    start.setMag(range*0.5);
    Cell c = world.get((int)posInWorld.x,(int)posInWorld.y);
    HashMap<PVector,Cell> cells=c.line(new PVector(posInWorld.x+start.x,posInWorld.y+start.y));
    for(int i =0;i<n;i++){
      rays[i]=rotate(start,e*(i+1));   
      HashMap<PVector,Cell> ce = c.line(new PVector(posInWorld.x+rays[i].x,posInWorld.y+rays[i].y));
      for(Map.Entry<PVector,Cell> entry : ce.entrySet())
      {
        if(entry.getValue()!=null&& !entry.getValue().posInWorld.equals(posInWorld));
          cells.put(entry.getKey(),entry.getValue());
      }
    }
    /*
    PVector start=rotate(direction,halfRad*1.2);    
    start.setMag(range*0.5);
    start.add(posInWorld);
    Cell c = world.get((int)start.x,(int)start.y);
    Filler f = new Filler(w,h,c,3);
    while(!f.workComplete())
    {
      f.Work();
    }
    
    HashMap<PVector,Cell> cells =((Selector)f.func).getTargets();
    */
    return cells;
  } 
  public boolean canMove(Cell c){
    if(c==null)
      return false;
      
    PVector p = c.posInWorld;
    if(p.x<0||p.x>=w||p.y<0||p.y>=h)
      return false;

    if( c.type instanceof Impassable)
      return false;
    else
      posInWorld=c.posInWorld;
    return true;
  }

  public void GoLeft()
  {
    PVector target=rotate(direction,-halfRad*1.2);
    target.setMag(range*0.5);
    target.add(posInWorld);
    GoTo(world.get((int)target.x,(int)target.y));
  }
  
  public void GoRight()
  {
    PVector target=rotate(direction,halfRad*1.2);
    target.setMag(range*0.5);
    target.add(posInWorld);
    GoTo(world.get((int)target.x,(int)target.y));
  }
  
  public void GoForward()
  {
    PVector target=direction.copy();
    target.setMag(range*0.5);
    target.add(posInWorld);
    GoTo(world.get((int)target.x,(int)target.y));
  }
  void ApplyForce(PVector p)
  {
    acceleration.add(p);
  }
  /*
  public boolean ApplyVelocity(){
    PVector u = velocity.copy().add(posInWorld);
    acceleration.mult(0);
    Cell c = world.get((int)u.x,(int)u.y);
     return canMove(c);
  }
 */
  public boolean ApplyVelocity(){
     PVector u = new PVector(0,0);
     lastPos=posInWorld;
     
     u.add(velocity);
     u.add(posInWorld);
     int x1,x2,y1,y2,dx,dy,e;   
     x1 = (int)posInWorld.x;
     y1 = (int)posInWorld.y;
     x2 = round(u.x);
     y2 = round(u.y);
     dx=x2-x1;
     dy=y2-y1;
     Cell c = world.get(round(posInWorld.x),round(posInWorld.y));
     boolean movable=true;
     Cell current=null;
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
               current=c.inMatrix(x1,y1);
               if(current!=null&&movable){
                 movable=canMove(current);
                 c=current;
               }
               else
               {
                 return false; 
               }
               e-=dy;
               if(e<0)
               {
                y1++;
               current=c.inMatrix(x1,y1);
               if(current!=null&&movable){
                 movable=canMove(current);
                 c=current;
               }
               else
                 return false; 
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
               current=c.inMatrix(x1,y1);
               if(current!=null&&movable){
                 movable=canMove(current);
                 c=current;
               }
               else
                 return false; 
               e-=dx;
               if(e<0)
               {
                 x1++;
                 current=c.inMatrix(x1,y1);
                 if(current!=null&&movable){
                   movable=canMove(current);
                   c=current;
                 }
                 else
                    return false;     
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
               current=c.inMatrix(x1,y1);
               if(current!=null&&movable){
                 movable=canMove(current);
                 c=current;
               }
               else               
                 return false; 
               e+=dy;
               if(e<0)
               {
                 y1--;
                 current=c.inMatrix(x1,y1);
                 if(current!=null&&movable){
                   movable=canMove(current);
                   c=current;
                 }
                 else
                   return false; 
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
               current=c.inMatrix(x1,y1);
               if(current!=null&&movable){
                 movable=canMove(current);
                 c=current;
               }
               else
                 return false; 
               e+=dx;
               if(e>0)
               {
                 x1++; //diagonal
                 current=c.inMatrix(x1,y1);
                 if(current!=null&&movable){
                   movable=canMove(current);
                   c=current;
                 }
                 else
                   return false; 
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
           current=c.inMatrix(x1,y1);
           if(current!=null&&movable){
             movable=canMove(current);
             c=current;
           }
           else
             return false;            
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
               current=c.inMatrix(x1,y1);
               if(current!=null&&movable){
                 movable=canMove(current);
                 c=current;
               }
               else
                 return false;
               e+=dy;
               if(e>=0)
               {
                 y1++; //diagonal
                 current=c.inMatrix(x1,y1);
                 if(current!=null&&movable){
                   movable=canMove(current);
                   c=current;
                 }
                 else
                   return false;
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
               current=c.inMatrix(x1,y1);
               if(current!=null&&movable){
                 movable=canMove(current);
                 c=current;
               }
               else
                 return false;    
               e+=dx;
               if(e<=0)
               {
                 x1--;
               current=c.inMatrix(x1,y1);
               if(current!=null&&movable){
                 movable=canMove(current);
                 c=current;
               }
               else
                 return false; 
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
               current=c.inMatrix(x1,y1);
               if(current!=null&&movable){
                 movable=canMove(current);
                 c=current;
               }
               else
                 return false; 
               e-=dy;
               if(e>=0)
               {
                 y1--; //diagonal
                 current=c.inMatrix(x1,y1);
                 if(current!=null&&movable){
                   movable=canMove(current);
                   c=current;
                 }
                 else
                   return false; 
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
               current=c.inMatrix(x1,y1);
               if(current!=null&&movable){
                 movable=canMove(current);
                 c=current;
               }
               else
                 return false; 
               e-=dx;
               if(e>=0)
               {
                 x1--;
                 current=c.inMatrix(x1,y1);
                 if(current!=null&&movable){
                   movable=canMove(current);
                   c=current;
                 }
                 else
                    return false;  
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
             current=c.inMatrix(x1,y1);
             if(current!=null&&movable){
               movable=canMove(current);
               c=current;
             }
             else
               return false; 
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
           current=c.inMatrix(x1,y1);
           if(current!=null&&movable){
             movable=canMove(current);
             c=current;
           }
           else
             return false; 
           y1++;
         }
       }
       else
       {
         while(y1>=y2)
         {
           current=c.inMatrix(x1,y1);
           if(current!=null&&movable){
             movable=canMove(current);
             c=current;
           }
           else
             return false; 
           y1--; 
         }
       }
      }
   }   
   if(current!=null &&  destination!=null)
   {
     //println("current : "+ current.posInWorld +"   " + u + "   " +destination.posInWorld + "   " + velocity);
     if(destination.isNeighboredBy(current))
     {       
       canMove(destination); 
     }
   }
   acceleration.mult(0);
   return true;
  }

}
