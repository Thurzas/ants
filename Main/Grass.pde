public class Grass extends Element{
  @Override  
  public void Update(){
  }  
  @Override
  public void onCreate(){
    r=58;
    g=111;
    b=0; 
  }
  @Override
  public boolean equals(Object o){
    if(o instanceof Grass)
    {
      return true;
    }
    return false;
  }
  @Override
  public int getType()
  {
    return 2;
  }

  @Override
  public boolean canMove(Cell B)
  {
    return true;
  }
  @Override
  public Element clone(){
    return new Grass();
  }
  @Override
  public String toString()
  {
    return "Grass";
  }
}
