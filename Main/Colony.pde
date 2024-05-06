public class Colony
{
  PVector posInWorld;
  int food;
  ArrayList<Ant> ants;
  int size=3,max=600,ColonyRange=60,limit,timer,completeFrame,n=200;
  boolean newBorn;
  HashMap<PVector,Cell> circle;
  int lastFood;
  final int min = 30;
  public Colony(PVector posInWorld){
    food=10;
    ants = new ArrayList<Ant>();
    this.posInWorld = posInWorld;
    completeFrame=fps;
    limit=30;
    for(int i =0;i<n;i++){
      ants.add(new LumberJack(posInWorld,this));
    }
    Filler f = new Filler(w,h,world.get((int)posInWorld.x,(int)posInWorld.y),size);
    while(!f.workComplete())
    {
      f.Work();
    }
    
    circle =((Selector)f.func).getTargets();
  }
    
  public HashMap<PVector,Cell> getCircle()
  {
    return circle;
  }
  
  public boolean inCircle(PVector pos){
    return (pos.x-posInWorld.x)*(pos.x-posInWorld.x) + ( pos.y-posInWorld.y )*( pos.y-posInWorld.y )<=size*size;
  }
  public boolean UnAllowedFarming(PVector pos){
    return (pos.x-posInWorld.x)*(pos.x-posInWorld.x) + ( pos.y-posInWorld.y )*( pos.y-posInWorld.y )<=ColonyRange*ColonyRange;
  } 
  public void Update(){
    if(timer>=completeFrame)
    {        
      lastFood=food;
      food-=ants.size()*0.1;
      timer=0;
      if(food<0&&ants.size()>0)
      {
        int i = 0;
        while(i<abs(food*0.1)&&ants.size()>0){
         ants.remove(0);
         i++;
        }
      } 
      newBorn=false;
    }
    if(food>=min)
    {
      newBorn();
    }
     
    for(Ant a : ants){
      a.Update();
    }    
    timer++;
  }
  
  public void newBorn(){
    if(!newBorn&&ants.size()<max)
    {
      int n = (int)(food*0.1);
      if(n>10)
        n=10;
      if(n<1)
        n=1;

      if(n+ants.size()>max)
        n=max-ants.size();
      
      for(int i =0;i<n;i++){
        ants.add(new LumberJack(posInWorld,this));
      }
      newBorn=true;
    }
  }
  
  public void add(){
    food+=5;
  }
  public void Farming(Cell c){
    if(c.type instanceof Grass && food>=20 && !UnAllowedFarming(c.posInWorld))
    {        
      food--;     
      c.setType(new seed());
    }
  }
}
