public class neutral extends pheromone
{
  @Override
  public void Update(){
  }
  @Override
  public void onCreate(){
    r=0;
    g=0;
    b=0; 
    intensity=0;
    alpha=0;
  }

  @Override
  public boolean equals(Object o){
    if(o instanceof neutral)
    {
      return true;
    }
    return false;
  }

  @Override
  public int getType()
  {
    return 9;
  }
  
  @Override
  public boolean canMove(Cell B)
  {
    return true;
  }
    @Override
  public Element clone(){
    return new neutral();
  }
  @Override
  public String toString()
  {
    return "--";
  } 
}
