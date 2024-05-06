public class Rock extends Impassable{
  @Override  
  public void Update(){

  }  
  @Override
  public void onCreate(){
    r=77;
    g=77;
    b=77; 
  }
  @Override
  public boolean equals(Object o){
    if(o instanceof Rock)
    {
      return true;
    }
    return false;
  }
  @Override
  public int getType()
  {
    return 4;
  }

  @Override
  public boolean canMove(Cell B)
  {
    return true;
  }
    @Override
  public Element clone(){
    return new Rock();
  }
  @Override
  public String toString()
  {
    return "Rock";
  }
}
