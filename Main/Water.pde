public class Water extends Element{
  @Override  
  public void Update(){

  }  
  @Override
  public void onCreate(){
    r=0;
    g=92;
    b=127; 
  }
  @Override
  public boolean equals(Object o){
    if(o instanceof Water)
    {
      return true;
    }
    return false;
  }
  @Override
  public int getType()
  {
    return 0;
  }
  @Override
  public boolean canMove(Cell B)
  {
    return true;
  }
    @Override
  public Element clone(){
    return new Water();
  }
  @Override
  public String toString()
  {
    return "Water";
  }
}
