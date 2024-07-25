// 
class WMH_BiomeSpawnPoint extends CGameplayEntity {
	public editable var biome_tags: WMH_BiomeTags;
	public editable var biome_tags_bypass: array<name>;
	hint biome_tags_bypass = "entities can use the tags from this list to bypass the biome_tags of this spawn point";

	public editable var is_clues_location: bool;
	hint is_clues_location = "if set to true, the spawn point can also be as a location for clues";
	
	protected var respawn_ticker: WMH_Ticker;
	
	event OnSpawned( spawnData : SEntitySpawnData ) {
		this.respawn_ticker = (new WMH_Ticker in this).init(180.0);
	}
	
	public function canRespawn(): bool {
		return this.respawn_ticker.hasExpired();
	}
	
	// to be used when the location is used as a spawn point,
	public function consume() {
		this.respawn_ticker.lock();
	}

	public function liberate() {
		this.respawn_ticker.reset();
	}
}