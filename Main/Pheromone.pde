public abstract class pheromone extends Element
{
  float alpha;
  float intensity;
  int max =maxChem;

  @Override
  public boolean canMove(Cell B)
  {
    return true;
  }  
}
