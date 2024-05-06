public class testState extends WorkingState{

  PVector destination;
  public testState(Ant component){
    super(component);
  }
  @Override  
  public void OnStateEnter(){
    text="space, the final frontier";
    _component.refill();
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
    //if(destination !=null)
     // _component.arrive(destination);
    
  }  
}
