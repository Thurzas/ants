public class LumberJack extends Ant
{
    public LumberJack( PVector posInWorld,Colony colony)
    {
      super(posInWorld,colony);
    }
    @Override
    void onCreate(){
      _states = new HashMap<Integer,WorkingState>();
      _states.put(0,new InactiveState(this));
      _states.put(1,new ExploringState(this));
      _states.put(2,new LumberingState(this));
      _states.put(3,new HomeState(this,false));
      _CurrentState = _states.get(1); 
    }    
}
