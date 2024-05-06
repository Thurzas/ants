public abstract class WorkingState
{
  Ant _component;
  String text="uninitialized yet";
  public WorkingState(Ant component){
    _component=component;
    OnStateEnter();
  }
  public abstract void OnStateEnter();
  public abstract void OnStateExit();
  public abstract void Update();
  @Override
  public String toString()
  {
    return text;
  }
}
