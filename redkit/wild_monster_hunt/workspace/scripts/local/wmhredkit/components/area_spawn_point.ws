statemachine class WMH_AreaSpawnPoint extends WMH_BiomeSpawnPoint {
  protected editable var spawn_time_flags: WMH_TimeRangeFlags;

  protected editable var nearby_spawn_points_requirement_intensity: float;
  default nearby_spawn_points_requirement_intensity = 0.0f;
  hint nearby_spawn_points_requirement_intensity = "how much impact nearby spawn points have the chances for this point to be cancelled. If too many enemies are in the area and this value isn't at 0 then it may be cancelled. With a value of 1.0, a creature closer than 30m won't prevent a spawn, but one closer than 30m and any other in a ~100m radius will.";


  event OnAreaEnter(area: CTriggerAreaComponent, activator: CComponent) {
    var bentry: WMH_BestiaryEntry;

    if (activator.GetEntity() != thePlayer) {
      return false;
    }

    // perform a reset the first time it's visited in a hunt
    if (!this.wasSpawnedSinceStartOfHunt()) {
      this.reset();
    }

    if (!this.canRespawn()) {
      return false;
    }

    if (this.getRandomBestiaryEntry(bentry)) {
      WMH_getBestiary().onSpawnAreaSpawnPoint(this, bentry);
      this.consume();
    }
  }

  private function getRandomBestiaryEntry(out bentry: WMH_BestiaryEntry): bool {
    var new_bentry: WMH_BestiaryEntry;
    var index: int;
    var size: int;
    var tag: name;

    size = this.biome_tags_bypass.Size();
    if (size <= 0) {
      return false;
    }

    // save a randnoise call if there is only one entry
    if (size == 1) {
      index = 0;
    }
    else {
      index = (int)RandNoiseF(this.getPointSeed(WMH_getHuntSeedFact()), size);
    }

    tag = this.biome_tags_bypass[index];
    new_bentry = WMH_getBestiary()
      .getEntryByBiomeTagByPass(tag);

    if (new_bentry) {
      bentry = new_bentry;
      return true;
    }

    return false;
  }

  private function isTimeValid(): bool {
    var hours: int = WMH_getBiomeManager().getDayHour();

    return WMH_getTimeFlag(this.spawn_time_flags, hours);
  }

  private function isThereEnoughRoom(): bool {
    var spawn_points: WMH_SpawnPointManager;
    var altered_chance: float;
    var counts: WMH_Int4;

    if (this.nearby_spawn_points_requirement_intensity <= 0) {
      return true;
    }

    spawn_points = WMH_getSpawnPointManager();
    counts = spawn_points.countAllOccupiedSpawnPoints(this.GetWorldPosition());

    altered_chance = 1.0
      - counts.a * 0.8 * this.nearby_spawn_points_requirement_intensity
      - counts.b * 0.6 * this.nearby_spawn_points_requirement_intensity
      - counts.c * 0.4 * this.nearby_spawn_points_requirement_intensity
      - counts.d * 0.2 * this.nearby_spawn_points_requirement_intensity;

    return altered_chance >= 0;
  }

  public function canRespawn(): bool {
    return super.canRespawn() && this.isTimeValid() && this.isThereEnoughRoom();
  }
}
