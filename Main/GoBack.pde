public class GoBack extends pheromone
{
  public GoBack()
  {
    super();
  }
  public GoBack(int intensity)
  {
    super();
    this.intensity=intensity;
  }
  
  @Override
  public void onCreate(){
    max=maxChem;

    r=0;
    g=0;
    intensity=max;
    alpha=(intensity/max); 
    b=(byte)(126*alpha);
  }
  @Override  
  public void Update(){
    component.getChunkFrom((int)component.posInWorld.x,(int)component.posInWorld.y).setActive(true);
    intensity-=dissipation;
    if(intensity>0)
      alpha=(intensity/max);   
      
    b=(byte)(126*alpha);
    if(intensity<=0)
        component.nullifyGoBack();
  }  

  @Override
  public boolean equals(Object o){
    if(o instanceof GoBack)
    {
      return true;
    }
    return false;
  }
  @Override
  public int getType()
  {
    return 7;
  }
  
  @Override
  public boolean canMove(Cell B)
  {
    return true;
  }
    @Override
  public Element clone(){
    return new GoBack();
  }
  @Override
  public String toString()
  {
    return "GoBack(" + intensity + ")";
  } 
}
