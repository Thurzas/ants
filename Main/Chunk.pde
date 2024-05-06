  class Chunk{
    Cell[][] grid;
    boolean active;
    PVector size;
    PVector pos;
    World world;
    boolean moved;
    int timer=0;
    boolean carved;
    public Chunk(PVector pos,PVector size,NoiseInfo Info,World w){
      this.pos=pos;
      this.size=size;
      this.world=w;
      active=true;
      grid=new Cell[(int)size.y][(int)size.x];
      for(int i = 0; i <  size.y; i++)
      {
        for(int j = 0; j< size.x; j++)
        {
            float frequency=1;
            float amplitude=5;
            float noiseHeight=0;
            PVector local=localToWorld(new PVector(j,i)); 
            for(int o = 0; o<Info.octaves;o++){
              int x = (int)local.x+1000000+XOffset;
              int y = (int)local.y+1000000+YOffset;
              float X = x / Info.noiseScale * frequency;
              float Y = y / Info.noiseScale * frequency;
              noiseHeight += (noise(X,Y)*2-1)*amplitude+Info.ZOffset;
              //noiseHeight += (noise(X,Y)*2 -1)*amplitude+Info.ZOffset;
              amplitude *= Info.persistance;
              frequency *= Info.lacunarity;
            }
          
            float offset = .9;
            float prev = 1;
            float river=0;
            float amp=5;
            for(int o=0 ; o < Info.octaves ; o++) {
              float n = ridge(noiseHeight/Info.riverRange + Info.ZOffset, offset);
              //float n = abs(noiseHeight/Info.riverRange + Info.ZOffset);
              river += n*amp;
              river += n*amp*prev;
              prev = n;
              frequency *= Info.lacunarity;
              amp *= Info.persistance;
            }
           offset = 0.9;
           prev = 1;
           float river2=0;
           amp=5;
           for(int o=0 ; o < Info.octaves ; o++) {
                float n = ridge(noiseHeight/(Info.riverRange)*0.4 + Info.ZOffset, offset);
                //float n = abs(noiseHeight/Info.riverRange + Info.ZOffset);
                river2 += n*amp;
                river2 += n*amp*prev;
                prev = n;
                frequency *= Info.lacunarity;
                amp *= Info.persistance;
           }
           //this noise make a start from sea to rivers.
           if(noiseHeight>(river/Info.riverDeepness))
            {
              if(noiseHeight<w.smax)
                w.smax=noiseHeight;
              noiseHeight=river; 
            }
            //noise creating rivers/swamps
            if(noiseHeight>(river2/(Info.riverDeepness*2)))
            {            
              if(noiseHeight<w.emin)
                w.emin=noiseHeight;
              noiseHeight=river2;
            }
            if(noiseHeight>Info.Max)
            {
              noiseHeight=Info.Max;
            }
            if(noiseHeight<Info.Min)
            {
               noiseHeight=Info.Min;
            }
            Element e = IntToElement((int)noiseHeight);

            grid[i][j]=new Cell(new PVector(j+pos.x*size.x,i+pos.y*size.y),e ,w);
            //grid[i][j].posInWorld.z=noiseHeight;         
        }
      }
    }
    
    float ridge(float h, float offset){
        h = abs(h);
        h = offset - h;
        h = h * h;
        return h;
    }

    Element IntToElement(int i){
      switch(i)
      {
        case 0: 
          return new Water();
        case 1: 
          return new Sand();
        case 2: 
          return new Grass();
        case 3: 
          return new Tree();
        case 4: 
          return new Rock();
        case 5: 
          return new Snow();
        default:
          return new AIR();
      }      
    }
    
    public Chunk get(Direction dir)
    {
      PVector p = new PVector(pos.x+dir.x,pos.y+dir.y);
      if(isFree(p))
        return world.getChunk((int)p.x,(int)p.y);
      else return null;
    }
    
    public boolean isFree(PVector p){
      if(p.x<0||p.y<0||p.x>=world.grid[0].length||p.y>=world.grid.length)
        return false;
        
      return true;
    } 
    public Cell get(int x,int y){
      if(x>=0&&y>=0&&x<grid[0].length &&y<grid.length)
      {
        return grid[y][x];
      }
      else
        return null;
    }

    public PVector localToWorld(PVector p){
      return new PVector(p.x +pos.x*size.x,p.y + pos.y*size.y);
    }
    public void setActive(boolean active){
      this.active=active;
    }

    public void Update(){    
      if(timer/frameRate>=1)
      {
        for(int y = 0; y<size.y ; y++){
          for(int x = 0; x<size.x; x++){
            Cell c = grid[y][x];
            c.reserved=false;
            this.active=true;
          }
        }
        timer=0;
      }
      timer++;
      for(int y = (int)size.y-1; y>=0 ; y--){
        for(int x = (int)size.x-1; x>=(int)(size.x*0.5); x--){
          Cell c1 = grid[y][x];
          c1.type.Update();
          c1.goBack.Update();
          c1.recruit.Update();
        }
        for(int x = 0; x<round(size.x*0.5); x++){
          Cell c1 = grid[y][x];
          c1.type.Update();
          c1.goBack.Update();
          c1.recruit.Update();
        } 
      }
    }
 
    @Override
    public String toString(){
      return "Chunk : " + pos+ "||" + size; 
    }
  }
