public class Tree extends Element{
  @Override  
  public void Update(){

  }  
  @Override
  public void onCreate(){
    r=11;
    g=91;
    b=0; 
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
