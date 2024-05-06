public class Recruit extends pheromone
{
  public Recruit(){
    super();
  }
  public Recruit(int intensity)
  {
    super();
    this.intensity=intensity;
  }
  
  @Override  
  public void Update(){
    component.getChunkFrom((int)component.posInWorld.x,(int)component.posInWorld.y).setActive(true);
    intensity-=dissipation;
    if(intensity>0)
      alpha=intensity/max;
    r=(byte)(126*alpha);

    if(r<12)
      r=12;

    if(intensity<=0)
        component.nullifyRecruit();
  }  
  @Override
  public void onCreate(){
    max=maxChem;
    b=0;
    g=0;
    intensity=max;
    alpha=(intensity/max); 
    r=(byte)(126*alpha);
  }
  
  @Override
  public boolean equals(Object o){
    if(o instanceof Recruit)
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
    return new Recruit();
  }
  @Override
  public String toString()
  {
    return "Recruit(" + intensity + ")";
  } 
}
