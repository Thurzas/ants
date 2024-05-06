public class HomeState extends WorkingState{
  
  float lastMax;
  boolean bringFood;
  public HomeState(Ant component,boolean food){
    super(component);
    bringFood=food;
    lastMax=0;
  }
  @Override  
  public void OnStateEnter(){
    _component.refill();
    _component.acceleration=new PVector();
    _component.destination=null;
    _component.velocity = _component.rotate(_component.velocity,180);
    _component.direction = _component.rotate(_component.direction,180);
  }
  @Override  
  public void OnStateExit(){
    
  }
  /*
    if(F>FL && F>FR
      forward
    else if F<FL && F < FR
      randomly choose FR or FL
    else if (FL< FR)
        rotate by RA
    else if (FR < FL)
        rotate left by RA
    else
      keep forward
  */
  boolean FollowTrail()
  {
    boolean b = false;
    int L=lookLeft(),R=lookRight(),F=lookForward();
      if(L==0&&R==0&&F==0)
      {
        lastMax=0;
        return false;
      }
      if(F>L&&F>R)
      {
        if(F>lastMax)
        {
          lastMax=F;
          _component.GoForward();
          b=true;
        }
      }
      else if(R==L)
      {
        _component.GoForward();
        b=true;
      }
      else if(R>L)
      {
        if(R>lastMax)
        {
          lastMax=R;
          _component.GoRight();
          b=true;
        }
      }
      else if(L>R)
      {
        if(L>lastMax)
        {
          lastMax=L;
          _component.GoLeft();
          b=true;
        }
      }    

    return b;
  }
  
    public int lookLeft(){
      int count=0;
      HashMap<PVector,Cell> cells = _component.LookLeft();
      for(Map.Entry<PVector,Cell> entry : cells.entrySet()){
        Cell c = (Cell)entry.getValue();
  
        if(c!=null)
        {
          pheromone[] k = c.getChems();
          if(k[1] instanceof GoBack)
          {
            count+=((GoBack)k[1]).intensity;
          }        
        }
      }
      
      if(cells.size()>0)
        count/=cells.size();
      return count;
  }
  
    public int lookRight(){
      int count=0;
      HashMap<PVector,Cell> cells = _component.LookRight();
      for(Map.Entry<PVector,Cell> entry : cells.entrySet()){
        Cell c = (Cell)entry.getValue();
  
        if(c!=null)
        {
          pheromone[] k = c.getChems();
          if(k[1] instanceof GoBack)
          {
            count+=((GoBack)k[1]).intensity;
          }        
        }
      }
      
      if(cells.size()>0)
        count/=cells.size();
      return count;
    }
  public int lookForward(){   
      int count=0;
      HashMap<PVector,Cell> cells = _component.LookForward();
      for(Map.Entry<PVector,Cell> entry : cells.entrySet()){
        Cell c = (Cell)entry.getValue();
  
        if(c!=null)
        {
          pheromone[] k = c.getChems();
          if(k[1] instanceof GoBack)
          {
            count+=((GoBack)k[1]).intensity;
          }        
        }
      }
      
      if(cells.size()>0)
        count/=cells.size();
      return count;
  }
   @Override  
  public void Update(){
    if(bringFood)
      _component.trail(true);
    if(_component.colony.inCircle(_component.posInWorld)){
      _component.GoTo(world.get((int)_component.colony.posInWorld.x,(int)_component.colony.posInWorld.y));
      if((int)_component.posInWorld.x==(int)_component.colony.posInWorld.x&&(int)_component.posInWorld.y==(int)_component.colony.posInWorld.y)
      {
         _component.setState(new InactiveState(_component));      
         if(bringFood)
           _component.colony.add();
      }      
      return;
    }

    _component.GoTo(world.get((int)_component.colony.posInWorld.x,(int)_component.colony.posInWorld.y));
    
    if(FollowTrail())
    {
      //println("follow ? ");
      return;
    }
    else
    {
      lastMax=0;
      HashMap<PVector,Cell> cells = _component.LineOfSight();
      for(Map.Entry<PVector,Cell> entry : cells.entrySet()){
        Cell c =(Cell) entry.getValue();
        if(c!=null)
        {
          if(_component.colony.inCircle(c.posInWorld))
          {
            _component.GoTo(c);
            return;
          }
        }
      }
      if(_component.destination==null)
        _component.wander();
    }
  }
}
