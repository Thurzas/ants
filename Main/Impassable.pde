public class Impassable extends Element
{
  @Override  
  public void Update(){

  }  
  @Override
  public void onCreate(){
    r=120;
    g=0;
    b=0; 
  }
  @Override
  public boolean equals(Object o){
    if(o instanceof Impassable)
    {
      return true;
    }
    return false;
  }
  @Override
  public int getType()
  {
    return 6;
  }
  
  @Override
  public boolean canMove(Cell B)
  {
    return true;
  }
    @Override
  public Element clone(){
    return new Impassable();
  }
  @Override
  public String toString()
  {
    return "Impassable";
  }
}
