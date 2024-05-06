public class InactiveState extends WorkingState{
  public InactiveState(Ant component){
    super(component);
  }
  @Override  
  public void OnStateEnter(){
    _component.velocity = _component.rotate(_component.velocity,180);
    _component.acceleration=new PVector();
    _component.destination=null;
    _component.velocity = _component.rotate(_component.velocity,180);
    _component.direction = _component.rotate(_component.direction,180);
    text="sleeping";
  }
  @Override  
  public void OnStateExit(){   
  }
   @Override  
  public void Update(){
     _component.setState(new ExploringState(_component));
  }  
}
