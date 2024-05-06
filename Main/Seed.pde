public class seed extends Element
{
  final int timer=60;
  int count;
  @Override  
  public void Update(){
    if(count/frameRate>=timer)
      component.setType(new Tree());
    count++;
  }  
  @Override
  public void onCreate(){
    r=111;
    g=127;
    b=66; 
  }
  @Override
  public boolean equals(Object o){
    if(o instanceof Tree)
    {
      return true;
    }
    return false;
  }
  @Override
  public int getType()
  {
    return 3;
  }
 
  @Override
  public boolean canMove(Cell B)
  {
    return true;
  }
    @Override
  public Element clone(){
    return new Tree();
  }
  @Override
  public String toString()
  {
    return "Tree";
  }

}
