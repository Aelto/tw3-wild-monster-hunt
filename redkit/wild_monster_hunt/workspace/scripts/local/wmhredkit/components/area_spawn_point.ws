statemachine class WMH_AreaSpawnPoint extends WMH_BiomeSpawnPoint {
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
}
