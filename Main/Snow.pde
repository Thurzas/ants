public class Snow extends Element{
  @Override  
  public void Update(){

  }  
  @Override
  public void onCreate(){
    r=127;
    g=127;
    b=127; 
  }
  @Override
  public boolean equals(Object o){
    if(o instanceof Snow)
    {
      return true;
    }
    return false;
  }
  @Override
  public int getType()
  {
    return 5;
  }
  
  @Override
  public boolean canMove(Cell B)
  {
    return true;
  }
    @Override
  public Element clone(){
    return new Snow();
  }
  @Override
  public String toString()
  {
    return "Snow";
  }
}
