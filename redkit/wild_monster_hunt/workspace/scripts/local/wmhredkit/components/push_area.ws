statemachine class WMH_PushArea extends CEntity {
  event OnAreaEnter(area: CTriggerAreaComponent, activator: CComponent) {
		if (this.GetCurrentStateName() != 'Pushing') {
      this.GotoState('Pushing');
    }
	}

	event OnAreaExit(area: CTriggerAreaComponent, activator: CComponent) {
		if (this.GetCurrentStateName() == 'Pushing') {
      this.GotoState('Waiting');
    }
	}
}

state Waiting in WMH_PushArea {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    thePlayer
      .GetMovingAgentComponent()
      .GetMovementAdjustor()
      .CancelByName('SharedUtilsSlideToPosition');
  }
}
state Pushing in WMH_PushArea {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    this.Pushing_main();
  }

  entry function Pushing_main() {
    var destination: Vector;

    WMHHUD("You are approaching unfinished terrain");

    while (true) {
      SleepOneFrame();

      destination = VecInterpolate(
        parent.GetWorldPosition(),
        thePlayer.GetWorldPosition(),
        1.01
      );

      SUH_slideEntityToPosition(
        thePlayer,
        destination,
        0.5
      );
    }
  }
}