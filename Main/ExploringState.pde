public class ExploringState extends WorkingState{

  float lastMax;
  public ExploringState(Ant component){
    super(component);
    lastMax=0;
  }
  @Override  
  public void OnStateEnter(){
    text="space, the final frontier";
    _component.refill();
    _component.acceleration=new PVector();
    _component.destination=null;
    _component.velocity = _component.rotate(_component.velocity,180);
    _component.direction = _component.rotate(_component.direction,180);
  }
  @Override  
  public void OnStateExit(){
    text="something lovely";
  }  
  
  public boolean NeedToLumber()
  {
    if(world.get((int)_component.posInWorld.x,(int)_component.posInWorld.y).type instanceof Tree)
      return true;
     
    return false;
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
          if(k[0] instanceof Recruit)
          {
            count+=((Recruit)k[0]).intensity;
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
          if(k[0] instanceof Recruit)
          {
            count+=((Recruit)k[0]).intensity;
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
          if(k[0] instanceof Recruit)
          {
            count+=((Recruit)k[0]).intensity;
          }        
        }
      }
      
      if(cells.size()>0)
        count/=cells.size();
      return count;
  }
  
  boolean handleTree()
  {
    return _component.handleTree();
  }
  void arrive(){
    _component.arrive(_component.destination.posInWorld);
  }
  @Override  
  public void Update()  
  {
    
    if(_component.quantity<=0)
      _component.setState(new HomeState(_component,false));
    
    _component.trail(false);
    if(NeedToLumber()){
      _component.setState(new LumberingState(_component));
      return;
    }
    if(FollowTrail())
    {
      return;
    }
    else
    {
      lastMax=0;
      HashMap<PVector,Cell> cells = _component.LineOfSight();
      for(Map.Entry<PVector,Cell> entry : cells.entrySet()){
        Cell c =(Cell) entry.getValue();
        if(c!=null && c.type instanceof Tree)
        {
           if(!c.reserved)
           {
             _component.GoTo(c);
             c.reserved=true;
             return;
           }
        }
      }
      if(_component.destination==null)
        _component.wander();
    }
  }  
}
