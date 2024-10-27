statemachine class WMH_PushArea extends CEntity {
  public editable var push_message: string;
  default push_message = "You are approaching unfinished terrain";
  hint push_message = "Set a message this push area will display when the player enters it";

  public editable var disable_on_fact: name;
  hint disable_on_fact = "If set and if the fact it points to exists, the area will no longer push the player away";

  event OnAreaEnter(area: CTriggerAreaComponent, activator: CComponent) {
    if (IsNameValid(this.disable_on_fact) && FactsDoesExist(this.disable_on_fact)) {
      return false;
    }

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
    var push_starting_position: Vector;

    WMHHUD(parent.push_message);
    push_starting_position = thePlayer.GetWorldPosition();

    while (true) {
      destination = VecInterpolate(
        thePlayer.GetWorldPosition(),
        push_starting_position,
        1.01
      );

      NP_slideEntityToPosition(
        thePlayer,
        destination,
        0.25
      );

      Sleep(0.10);
    }
  }
}

function NP_slideEntityToPosition(entity: CEntity, position: Vector, optional duration: float) {
  var movement_adjustor: CMovementAdjustor;
  var slide_ticket: SMovementAdjustmentRequestTicket;
  var translation: Vector;

  if (duration <= 0) {
    duration = 2; // two seconds
  }

  translation = position - entity.GetWorldPosition();

  movement_adjustor = ((CActor)entity)
    .GetMovingAgentComponent()
    .GetMovementAdjustor();

  // cancel any adjustement made with the same name
  movement_adjustor.CancelByName('SharedUtilsSlideToPosition');

  // and now we create a new request
  slide_ticket = movement_adjustor.CreateNewRequest('SharedUtilsSlideToPosition');

  movement_adjustor.AdjustmentDuration(
    slide_ticket,
    duration
  );

  movement_adjustor.SlideTo(
    slide_ticket,
    position,
  );

  movement_adjustor.RotateTo(
    slide_ticket,
    VecHeading(translation)
  );
}