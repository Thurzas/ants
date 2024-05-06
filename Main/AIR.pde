public class AIR extends Element{
  @Override  
  public void Update(){

  }  
  @Override
  public void onCreate(){
    r=0;
    g=0;
    b=0; 
  }
  @Override
  public boolean equals(Object o){
    if(o instanceof AIR)
    {
      return true;
    }
    return false;
  }
  @Override
  public int getType()
  {
    return -1;
  }
  
  @Override
  public boolean canMove(Cell B)
  {
    return true;
  }
    @Override
  public Element clone(){
    return new AIR();
  }
  @Override
  public String toString()
  {
    return "Air";
  }
}
