  public enum Direction{
    TOP(0,-1,"TOP"),
    DOWN(0,1,"DOWN"),
    LEFT(-1,0,"LEFT"),
    RIGHT(1,0,"RIGHT"),
    TOPLEFT(-1,-1,"TOP-LEFT"),
    DOWNRIGHT(1,1,"DOWN-RIGHT"),
    DOWNLEFT(-1,1,"DOWN-LEFT"),
    TOPRIGHT(1,-1,"TOP-RIGHT");
    
    public final int x,y;
    public final String label;
    private Direction(int x, int y,String label){
      this.x=x;
      this.y=y;
      this.label=label;
    }
    
    public static Direction rotate(Direction curr,Direction rotate)throws Exception
    {
      switch(rotate){
        case LEFT:
        switch(curr){
          case TOP:
            return Direction.LEFT;
          case LEFT:
            return Direction.DOWN;
          case DOWN:
            return Direction.RIGHT;
          case RIGHT:
            return Direction.TOP;
          default:
            throw new Exception("Bad rotation argument");
        }
        case RIGHT:
        switch(curr){
          case TOP:
            return Direction.RIGHT;
          case RIGHT:
            return Direction.DOWN;
          case DOWN:
            return Direction.LEFT;
          case LEFT:
            return Direction.TOP;
          default:
            throw new Exception("Bad rotation argument");
        }
        default:
          throw new Exception("can't rotate this");
      }
    }
    @Override
    public String toString(){
      return label;
    }
  }
