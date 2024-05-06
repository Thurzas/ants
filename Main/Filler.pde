import java.util.*;
public class Filler<T>{
 LinkedList<Cell> queue;
 boolean[][] visited;
 int filled;
 int [] dx = {0,   1,  1, 1, 0, -1, -1, -1};
 int [] dy = {-1, -1,  0, 1, 1, 1, 0, -1};
 //int [] dx = {0,   1,  0, -1 };
 //int [] dy = {-1, 0,  1, 0 };
 int w;
 int h;
 int count;
 boolean depth;
 Cell start;
 public java.util.function.Function func;
 public Filler(int w, int h,Cell c, java.util.function.Function<Cell,T> func){
   fillers++;
   queue = new LinkedList<Cell>();   
   visited = new boolean[w][h];
   this.w=w;
   this.h=h;
   this.func=func;
   this.count=0;
   Fill(c);
   this.start=c;
   depth=false;
 }
 
 
 public Filler(int w, int h, Cell c, int size)
 {
   fillers++;
   queue = new LinkedList<Cell>();   
   visited = new boolean[w][h];
   this.w=w;
   this.h=h;
   this.func = new Selector(c,size,this);
   Fill(c);   
 }
 public Filler(int w, int h,Cell c,Element target,Element newtype){
   fillers++;
   queue = new LinkedList<Cell>();   
   visited = new boolean[w][h];
   this.w=w;
   this.h=h;
   this.func = new DefaultFunct(target,newtype);
   Fill(c);
 }
 public void Work(){
   if(queue.size()>0)
   {     
     Cell c = queue.peek();
     if(c!=null)
     {       
       Fill(c);
       count++;
     }
     queue.remove();
   }
 }

 public boolean workComplete(){
   if(queue.size()>0)
     return false;
   
   return true;
 }
 public void Fill(Cell curr)
 {
   if( curr==null || curr.posInWorld.x<0 || curr.posInWorld.y<0 || curr.posInWorld.x >= w || curr.posInWorld.y >= h  || visited[(int)curr.posInWorld.x ][(int)curr.posInWorld.y])
     return;
     
    if(func.apply(curr.type)==null) 
      return;
    
    if(!((Selector)func).apply(curr.type))
      return;
    
    else
    {    
      filled++;
      for(int  i=0;i<dx.length;i++){
        Cell c = curr.inMatrix((int)curr.posInWorld.x+dx[i],(int)curr.posInWorld.y+dy[i]);
        if(c!=null&&!visited[(int)c.posInWorld.x ][(int)c.posInWorld.y]&&!c.equals(curr)&&!queue.contains(c))
          queue.add(c);
      }     
    }    
    visited[(int)curr.posInWorld.x][(int)curr.posInWorld.y]=true;      
  }
}

public class DefaultFunct implements java.util.function.Function<Main.Element,Main.Element>
  {
    Main.Element target;
    Main.Element change;
    public DefaultFunct(Element target, Main.Element change){
      this.target=target;
      this.change=change;
    }
    @Override
    public Main.Element apply(Element e)
    {
      if(!(e.equals(target))){
         //curr.setType(new WATER());
         return null;
      }
      else
      {
        e.component.setType(change);
        return change;
      }
    }
 }
 
 public class Selector implements java.util.function.Function<Main.Element,Boolean>
  {
    int dist;
    HashMap<PVector,Cell> targets;
    Cell origin;
    Filler f;
    
    public Selector(Cell origin,int dist,Filler f){  
      this.origin=origin;
      this.dist=dist;
      this.f=f;
      targets =new HashMap<PVector,Cell>();
    }
 
    @Override
    public Boolean apply(Element e)
    {
      if(f.visited[(int)e.component.posInWorld.x][(int)e.component.posInWorld.y])
        return false;
        
      if(round(e.component.posInWorld.dist(origin.posInWorld))<dist)
      {          
        targets.put(e.component.posInWorld,e.component);
        return true;
      }
      else
      {
        return false;
      }
    }
    
    public HashMap<PVector,Cell> getTargets(){
      return targets;
    }
  }
 
public class SegregatedSelector implements java.util.function.Function<Main.Element,HashMap<PVector,Cell>>
  {
    Main.Element targetType;
    int dist;
    HashMap<PVector,Cell> targets;
    Cell origin;
    public SegregatedSelector(Element target,Cell origin){   
      this.origin=origin;
      this.targetType=target;
      this.dist=-1;
      targets =new HashMap<PVector,Cell>();
    }
    public SegregatedSelector(Element target,Cell origin,int dist){  
      this.origin=origin;
      this.dist=dist;
      this.targetType=target;
      targets =new HashMap<PVector,Cell>();
    }
    @Override
    public HashMap<PVector,Cell> apply(Element e)
    {
      if(e.component.explored)
        return null;
        
      if(dist<=-1){
        if(e.equals(targetType)){
          targets.put(e.component.posInWorld,e.component);
        }
        else
         return null;
      }
      else
      {
        if(round(e.component.posInWorld.dist(origin.posInWorld))<dist)
        {
          if(!(e.equals(targetType))){
             //curr.setType(new WATER());
             return null;
          }
          else
          {
            targets.put(e.component.posInWorld,e.component);
            return targets;
          }
        }
        else
          return null;
      }
    e.component.explored=true;
    return targets;
    }
    
    public HashMap<PVector,Cell> getTargets(){
      return targets;
    }
  }
  

public class CarveRiver implements java.util.function.Function<Main.Element,Main.Element>
  {
    Main.Element target;
    Main.Element change;
    public CarveRiver(Element target, Main.Element change){
      this.target=target;
      this.change=change;
    }
    @Override
    public Main.Element apply(Element e)
    {
      if(!(e.equals(target))){
         //curr.setType(new WATER());
         return null;
      }
      else
      {
        e.component.setType(change);
        return change;
      }
    }
 }
