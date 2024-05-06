import processing.core.PGraphics;
public abstract class Element
{
  byte r;
  byte g;
  byte b;
  PVector velocity;
  PVector acceleration;
  int maxSpeed=5;
  PVector lastPos;
  float maxForce=0.1;
  Cell component;
  public Element(){
    this.velocity=new PVector();
    this.lastPos=new PVector();
    this.acceleration=new PVector();
    onCreate();
  }
  public void setCell(Cell c)
  {
    this.component=c;
  }
  public abstract void onCreate();
  public abstract void Update();
  public abstract boolean canMove(Cell B);
  public boolean Move(Cell B)
  {     
     if(canMove(B)){
      Element t = component.type;
      component.setType(B.type);
      B.setType(t);
      component.moved=true;
      B.moved=true;
      return true;
     }
     Chunk c = component.getChunkFrom((int)component.posInWorld.x,(int)component.posInWorld.y);
     c.moved=true;
     return false;
  }
  public abstract Element clone();  
  public abstract int getType();
  public boolean hasMoved(){
    return lastPos.x!=component.posInWorld.x||lastPos.y!=component.posInWorld.y;
  }
 
  public boolean applyVelocity(){
     PVector u = new PVector(0,0);
     u.add(velocity);
     u.add(component.posInWorld);
     int x1,x2,y1,y2,dx,dy,e;   
     x1 = round(component.posInWorld.x);
     y1 = round(component.posInWorld.y);
     x2 = round(u.x);
     y2 = round(u.y);
     dx=x2-x1;
     dy=y2-y1;
     Cell c = component;
     boolean movable=true;
     Cell current;
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
                 movable=Move(current);
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
                 movable=Move(current);
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
                 movable=Move(current);
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
                   movable=Move(current);
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
                 movable=Move(current);
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
                   movable=Move(current);
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
                 movable=Move(current);
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
                   movable=Move(current);
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
             movable=Move(current);
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
                 movable=Move(current);
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
                   movable=Move(current);
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
                 movable=Move(current);
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
                 movable=Move(current);
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
                 movable=Move(current);
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
                   movable=Move(current);
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
                 movable=Move(current);
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
                   movable=Move(current);
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
               movable=Move(current);
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
             movable=Move(current);
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
             movable=Move(current);
             c=current;
           }
           else
             return false; 
           y1--; 
         }
       }
      }
   }
   acceleration.mult(maxForce);
   velocity.sub(acceleration);
   return true;
  }
}
