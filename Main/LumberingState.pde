public class LumberingState extends WorkingState
{
  final int timer=1;
  final int farm=5;
  int count;
  int fail;
  
  public LumberingState(Ant component){
    super(component);
  }
  @Override  
  public void OnStateEnter(){
    text="lumbering";
  }
  @Override  
  public void OnStateExit(){
    
  }
   @Override  
  public void Update(){
    Cell c =world.get((int)_component.posInWorld.x,(int)_component.posInWorld.y);
    if(c.type instanceof Tree)
    {
      c.reserved=true;
      if(count/frameRate>=timer)
      {
        c.setType(new Grass());        
        c.reserved=false;
        _component.setState(new HomeState(_component,true));    
      }
    }
    else
    {
      HashMap<PVector,Cell> cells = _component.LineOfSight();
      for(Map.Entry<PVector,Cell> entry : cells.entrySet()){
        Cell cc =(Cell) entry.getValue();
        if(cc!=null && cc.type instanceof Tree)
        {
           if(!cc.reserved)
           {
             _component.GoTo(cc);
             fail=0;
             return;
           }
        }
      }
      if(_component.destination==null)
      {
        if(c.type instanceof Grass)
        {
          _component.colony.Farming(c);
        }
        if(fail/frameRate>=farm)
          _component.setState(new HomeState(_component,false));
        fail++;
        
        _component.wander();
      }
    }
    count++;
  }  
}
