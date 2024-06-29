// 
class WMH_BiomeSpawnPoint extends CGameplayEntity {
	public editable var biome_tags: WMH_BiomeTags;
	
	protected var respawn_ticker: WMH_Ticker;
	
	event OnSpawned( spawnData : SEntitySpawnData ) {
		this.respawn_ticker = (new WMH_Ticker in this).init(180.0);
	}
	
	public function canRespawn(): bool {
		return this.respawn_ticker.hasExpired();
	}
	
	public function consume() {
		this.respawn_ticker.reset();
	}
}