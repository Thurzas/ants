public class Sand extends Element{
  @Override  
  public void Update(){

  }  
  @Override
  public void onCreate(){
    r=127;
    g=121;
    b=4;     
  }
  @Override
  public boolean equals(Object o){
    if(o instanceof Sand)
    {
      return true;
    }
    return false;
  }
  @Override
  public int getType()
  {
    return 1;
  }

  @Override
  public boolean canMove(Cell B)
  {
    return true;
  }
    @Override
  public Element clone(){
    return new Sand();
  }
  @Override
  public String toString()
  {
    return "Sand";
  }
}
