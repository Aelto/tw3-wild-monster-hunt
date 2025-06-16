statemachine class WMH_AreaSpawnPoint extends CGameplayEntity {
  editable var template_paths: array<string>;
  hint template_paths = "paths to the w2ent this point can spawn.";

  editable var spawn_count_max: int;
  default spawn_count_max = 1;

  editable var spawn_count_min: int;
  default spawn_count_min = 1;

  editable var respawn_cooldown: int;
  hint respawn_cooldown = "time in seconds between two spawns created by this spawn point.";
  default respawn_cooldown = 600;

  editable var entity_tags: array<name>;
  hint entity_tags = "tags that should be given to the spawned entities.";

  /// store the timestamp of the last time, when compared to the current timestamp
  /// and with this.respawn_cooldown this will be used to detect when a respawn is
  /// allowed.
  private var spawn_timestamp: float;

  private var entities: array<CNewNPC>;

  event OnSpawned(spawnData: SEntitySpawnData) {
    super.OnSpawned(spawnData);

    this.GotoState('Idle');
  }

  event OnAreaEnter(area: CTriggerAreaComponent, activator: CComponent) {
    if (activator.GetEntity() != thePlayer) {
      return false;
    }

    if (this.canRespawn() && this.GetCurrentStateName() != 'Spawning') {
      this.spawn_timestamp = theGame.GetEngineTimeAsSeconds();
      this.GotoState('Spawning');
    }
  }

  private function canRespawn(): bool {
    var now: float = theGame.GetEngineTimeAsSeconds();
    var delta: float = now - this.spawn_timestamp;

    return this.spawn_timestamp <= 0 || delta >= this.respawn_cooldown;
  }
}

state Idle in WMH_AreaSpawnPoint {}
state Spawning in WMH_AreaSpawnPoint {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    this.Spawning_main();
  }

  entry function Spawning_main() {
    var resource: CEntityTemplate;
    var template_path: string;
    var entity: CEntity;
    var count: int;
    
    count = this.calculateSpawnCount();
    if (count <= 0) {
      parent.GotoState('Idle');
      return;
    }

    while (count > 0) {
      count -= 1;

      // there is an obvious flaw here, if a resource for a template_path was
      // already loaded in a previous iteration this will load it again when
      // it could have been cached.
      //
      // Hopefully the engine does it for us under the hood, otherwise we'll
      // have to write a bit of code to handle that if it becomes problematic
      template_path = this.getRandomTemplate();
      resource = (CEntityTemplate)LoadResourceAsync(template_path, true);
      entity = theGame.CreateEntity(
        resource,
        // position:
        parent.GetWorldPosition() + VecRingRand(0.0, 5.0),

        // rotation:
        VecToRotation(VecRingRand(1, 2)),,,,

        // persistance, whether entities stays between reloads
        PM_DontPersist,

        parent.entity_tags
      );
    }

    parent.GotoState('Idle');
  }

  private function calculateSpawnCount(): int {
    if (parent.spawn_count_max == parent.spawn_count_min) {
      return parent.spawn_count_max;
    }

    return RandRange(parent.spawn_count_max, parent.spawn_count_min);
  }

  private function getRandomTemplate(): string {
    var index: int = RandRange(parent.template_paths.Size());

    return parent.template_paths[index];
  }
}