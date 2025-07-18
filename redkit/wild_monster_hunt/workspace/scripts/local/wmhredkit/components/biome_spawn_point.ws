﻿// 
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

	public editable var hunt_fact_on_spawn: string;
	hint hunt_fact_on_spawn = "A hunt_fact to add to the HuntFactsDb when this spawn point is consumed.";

	public editable var hunt_fact_on_clear: string;
	hint hunt_fact_on_clear = "A hunt_fact to add to the HuntFactsDb when this spawn point is liberated.";

	public editable var hunt_fact_remove_on_state_change: bool;
	default hunt_fact_remove_on_state_change = false;
	hint hunt_fact_remove_on_state_change = "If set to true, the hunt_facts are removed whenever the state clear/consumed changes. Leaving only the most recent hunt_fact.";

	protected var respawn_ticker: WMH_Ticker;
	protected var wildlife_ticker: WMH_Ticker;

	// stores the timestamp of the last time this spawn point spawned something
	protected var last_spawn_time: float;
	// stores the timestamp of the last time this spawn point was liberated after
	// it spawned something
	protected var last_clear_time: float;
	protected var last_clues_time: float;

	protected var spawn_priority: WMH_BiomeSpawnPoint_SpawnPriority;
	
	event OnSpawned( spawnData : SEntitySpawnData ) {
		super.OnSpawned(spawnData);

		this.reset();
	}

	// reset the spawn point to mark it as available right now
	public function reset() {
		this.respawn_ticker = (new WMH_Ticker in this).init(1200.0);
		this.wildlife_ticker = (new WMH_Ticker in this).init(300.0);
		this.last_spawn_time = 0;
		this.last_clear_time = 0;
		this.last_clues_time = 0;
		this.spawn_priority = WMH_BSP_SP_None;
	}

	// restart the spawn point to mark it as UNavailable until the respawn timer
	// has passed.
	public function restart() {
		this.respawn_ticker.restart();
	}

	public function getPointSeed(hunt_seed: int): int {
		return WMH_seedPositionOffset(hunt_seed, this.GetWorldPosition());
	}
	
	public function canRespawn(): bool {
		return this.respawn_ticker.hasExpired();
	}

	public function canSpawnMonstersInHunt(
		point_seed: int,
		monster_spawn_chance: float
	): bool {
		var chances: float = monster_spawn_chance;

		if (this.isSpawnForced()) {
			return true;
		}

		if (this.prefer_wildlife) {
			chances *= 0.5;
		}

		return RandNoiseF(point_seed + 0, 1.0) <= chances;
	}

	public function canSpawnClues(): bool {
		return !WMH_getHuntManager().hasHappenedDuringHunt(this.last_clues_time);
	}

	public function canSpawnWildlife(): bool {
		return this.wildlife_ticker.hasExpired();
	}

	public function isSpawnForced(): bool {
		return this.spawn_priority == WMH_BSP_SP_Forced;
	}

	public function isOccupied(): bool {
		return this.respawn_ticker.isLocked();
	}

	public function isWaitingForRespawn(): bool {
		return this.respawn_ticker.isWaitingToExpire();
	}
	
	// to be used when the location is used as a spawn point,
	public function consume() {
		this.respawn_ticker.lock();
		this.last_spawn_time = WMH_getEngineTimeAsSeconds();
		this.spawn_priority = WMH_BSP_SP_None;

		if (this.hunt_fact_on_spawn != "") {
			WMH_getHuntFactsDb().insert(this.hunt_fact_on_spawn);
		}

		if (
			this.hunt_fact_remove_on_state_change
			&& this.hunt_fact_on_clear != ""
		) {
			WMH_getHuntFactsDb().remove(this.hunt_fact_on_clear);
		}

		WMH_getSpawnPointManager().onBiomeSpawnPointConsumed(this);
	}

	public function consumeForClues() {
		this.last_clues_time = WMH_getEngineTimeAsSeconds();
	}

	public function consumeForWildlife() {
		// NOTE: that it doesn't lock the ticker but resets it, the wildlife 
		// encounter still being alive won't prevent new wildlife encounters from
		// respawning
		this.wildlife_ticker.restart();
	}

	public function liberate(optional encounter_was_killed: bool) {
		if (encounter_was_killed) {
			this.respawn_ticker.restart();
			this.last_clear_time = WMH_getEngineTimeAsSeconds();
			this.spawn_priority = WMH_BSP_SP_None;

			if (this.hunt_fact_on_clear != "") {
				WMH_getHuntFactsDb().insert(this.hunt_fact_on_clear);
			}

			if (
				this.hunt_fact_remove_on_state_change
				&& this.hunt_fact_on_spawn != ""
			) {
				WMH_getHuntFactsDb().remove(this.hunt_fact_on_spawn);
			}
		}
		else {
			this.respawn_ticker.reset();
		}

		WMH_getSpawnPointManager().onBiomeSpawnPointLiberated(this);
	}

	public function liberateForClues() {
		this.last_clues_time = 0;
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

	public function wasSpawnedSinceStartOfHunt(): bool {
		return WMH_getHuntManager().hasHappenedDuringHunt(this.last_spawn_time);
	}
}

enum WMH_BiomeSpawnPoint_SpawnPriority {
	WMH_BSP_SP_None = 0,
	WMH_BSP_SP_Forced = 1
}

/// Sub-type of BiomeSpawnPoints to be a fallback encounter to spawn
class WMH_BiomeSpawnPointFallback extends WMH_BiomeSpawnPoint {
	public editable var forbidden_hunt_fact: string;
	hint forbidden_hunt_fact = "Supplied hunt_fact must NOT exist in the HuntFactsDb for the point to be considered available.";

	public editable var required_hunt_fact: string;
	hint required_hunt_fact = "supplied hunt_fact MUST exist in the HuntFactsDb for the point to the considered available.";

	public function canSpawnMonstersInHunt(
		point_seed: int,
		monster_spawn_chance: float
	): bool {
		var chances: float = monster_spawn_chance;
		var db: WMH_HuntFactsDb = WMH_getHuntFactsDb();

		return this.isSpawnForced()
			|| (
				this.forbidden_hunt_fact == "" || !db.contains(this.forbidden_hunt_fact)
			)
			&& (
				this.required_hunt_fact == "" || db.contains(this.required_hunt_fact)
			)
			&& super.canSpawnMonstersInHunt(point_seed, monster_spawn_chance);
	}
}