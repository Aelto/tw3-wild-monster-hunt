// 
class WMH_BiomeSpawnPoint extends CGameplayEntity {
	public editable var biome_tags: WMH_BiomeTags;
	public editable var biome_tags_bypass: array<name>;
	hint biome_tags_bypass = "entities can use the tags from this list to bypass the biome_tags of this spawn point";

	public editable var is_clues_location: bool;
	hint is_clues_location = "if set to true, the spawn point can also be as a location for clues";

	public editable var allow_strong_targets: bool;
	default allow_strong_targets = false;
	hint allow_strong_targets = "supposedly strong monsters can only spawn to this spawn point if the option is set to `true`";

	public editable var allow_weak_targets: bool;
	default allow_weak_targets = true;
	hint allow_weak_targets = "supposedly weak monsters can only spawn to this spawn point if the option is set to `true`";

	public editable var prefer_wildlife: bool;
	default prefer_wildlife = false;
	hint prefer_wildlife = "if set to true, then the chances of a monster spawning there are reduced while wildlife is increased.";

	protected var respawn_ticker: WMH_Ticker;

	// stores the timestamp of the last time this spawn point spawned something
	protected var last_spawn_time: GameTime;
	// stores the timestamp of the last time this spawn point was liberated after
	// it spawned something
	protected var last_clear_time: GameTime;

	protected var spawn_priority: WMH_BiomeSpawnPoint_SpawnPriority;
	
	event OnSpawned( spawnData : SEntitySpawnData ) {
		this.respawn_ticker = (new WMH_Ticker in this).init(180.0);
	}

	public function getPointSeed(hunt_seed: int): int {
		var position: Vector = this.GetWorldPosition();

		return hunt_seed + (position.X as int) - (position.Y as int);
	}
	
	public function canRespawn(): bool {
		return this.respawn_ticker.hasExpired();
	}

	public function canSpawnMonstersInHunt(point_seed: int): bool {
		return this.spawn_priority == WMH_BSP_SP_Forced
				|| RandNoiseF(point_seed + 0, 1.0)
				<= monster_spawn_chance 
         * WMH_either::<float>(0.5, 1.0, this.prefer_wildlife)
	}
	
	// to be used when the location is used as a spawn point,
	public function consume() {
		this.respawn_ticker.lock();
		this.last_spawn_time = WMH_getEngineTimeAsSeconds();
		this.spawn_priority = WMH_BSP_SP_None;
	}

	public function liberate(optional encounter_was_killed: bool) {
		this.respawn_ticker.reset();

		if (encounter_was_killed) {
			this.last_clear_time = WMH_getEngineTimeAsSeconds();
			this.spawn_priority = WMH_BSP_SP_None;
		}
	}

	// tells the spawn point to spawn its creatures as soon as possible, even if
	// other rules would have caused it to be ignored.
	public function spawnPriorityForce() {
		this.spawn_priority = WMH_BSP_SP_Forced;
	}

	public function wasKilledSince(engine_time: float): bool {
		return engine_time < this.last_clear_time;
	}

	public function wasKilledSinceStartOfHunt(): bool {
		return WMH_getHuntManager().hasHappenedDuringHunt(this.last_clear_time);
	}
}

enum WMH_BiomeSpawnPoint_SpawnPriority {
	WMH_BSP_SP_None = 0,
	WMH_BSP_SP_Forced = 1
}