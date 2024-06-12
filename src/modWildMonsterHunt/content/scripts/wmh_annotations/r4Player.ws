@addField(CR4Player)
public saved var wmh: WMH_Master;

@wrapMethod(CR4Player)
function OnSpawned(spawnData : SEntitySpawnData) {
  wrappedMethod(spawnData);

  if (!this.wmh) {
    this.wmh = new WMH_Master in this;
    this.wmh.onCreate();
  }

  this.wmh.onLoad();
}