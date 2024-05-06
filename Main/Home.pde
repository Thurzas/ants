public class Home extends Element
{
  @Override  
  public void Update(){

  }  
  @Override
  public void onCreate(){
    r=120;
    g=0;
    b=120; 
  }
  @Override
  public boolean equals(Object o){
    if(o instanceof Home)
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
    return new Home();
  }
  @Override
  public String toString()
  {
    return "Home";
  }  
}
