class NoiseInfo
{
    float noiseScale;
    float persistance;
    int octaves;
    float lacunarity;
    float Max;
    float Min;
    float riverRange;
    float riverDeepness;
    float XOffset;
    float YOffset;
    float ZOffset;
    int seed;
    
    public NoiseInfo(float noiseScale, float persistance, int octaves, float lacunarity, float Max, float Min, float riverRange,float riverDeepness,float XOffset,float YOffset,float ZOffset, int seed){
      this.noiseScale = noiseScale;
      this.persistance = persistance;
      this.octaves = octaves;
      this.lacunarity =lacunarity;
      this.Max=Max;
      this.Min=Min;
      this.riverRange = riverRange;
      this.riverDeepness=riverDeepness;
      this.seed=seed;
      this.ZOffset=ZOffset;
      this.XOffset=XOffset;
      this.YOffset=YOffset;
    }
}
