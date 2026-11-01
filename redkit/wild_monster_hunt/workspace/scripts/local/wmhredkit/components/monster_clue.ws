statemachine class WMH_MonsterClue extends W3MonsterClue {
  // defines the localized name of the creature
  public var localized_entry_name: string;
  default localized_entry_name = "Unknown";

  public var target_bentry: WMH_BestiaryEntry;

  event OnInteraction(
    actionName: string,
    activator: CEntity
  ) {
    if (
      activator == thePlayer &&
      thePlayer.IsActionAllowed(EIAB_InteractionAction)
    ) {
      super.OnInteraction(actionName, activator);

      if (this.GetCurrentStateName() != 'Interacting') {
        this.GotoState('Interacting');
      }
    }
  }

  private var hunt_lock_hunting_experience: WMH_HuntLock;

  public function increaseHuntingExperience() {
    var was_used_in_hunt: bool = WMH_huntLockTryUse(
      this.hunt_lock_hunting_experience
    );

    if (!was_used_in_hunt) {
      return;
    }

    this.target_bentry.hunting_experience.onClueInteracted();
  }
}

state Waiting in WMH_MonsterClue {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    WMHINFO("WMH_MonsterClue - State Waiting");
  }
}

state Interacting in WMH_MonsterClue {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    WMHINFO("WMH_MonsterClue - State Interacting");
    this.start();
  }

  entry function start() {
    this.displayHudText(parent.localized_entry_name);
    this.playAnimation();

    parent.GotoState('Waiting');
  }

  latent function playAnimation() {
    parent.interactionAnim = PEA_ExamineGround;
    parent.PlayInteractionAnimation();
    parent.increaseHuntingExperience();
  }

  function displayHudText(entry_name: string) {
    WMHHUD(
      StrReplace(
        GetLocStringByKeyExt(
          "WMH_tracks_examine_hud_message"
        ),
        "{{species}}",
        entry_name
      )
    );
  }
}
