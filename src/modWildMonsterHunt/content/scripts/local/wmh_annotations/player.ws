//#region feint instead of death
@wrapMethod(CPlayer)
function OnDeath(damageAction: W3DamageAction) {
  if (thePlayer.wmh.hunt.isInHunt()) {
    super.OnDeath( damageAction );
		this.ClearAttitudes( true, false, false );

    // 1) force the player into the unconscious state, see comments below for the
    // next step:
    this.PushState('Unconscious');
  }
  else {
    wrappedMethod(damageAction);
  }
}

// 2) wrap the hideweapon of the state to introduce timeflow & teleport the
// player back to the FeintRespawn location.
@wrapMethod(CR4PlayerStateUnconscious)
function HideWeapon() {
  wrappedMethod();

  if (thePlayer.wmh.isInHunt()) {
    this.TimeFlow();

    var destination: CEntity = theGame.GetEntityByTag('WMH_FeintRespawn');

    if (destination) {
      thePlayer.Teleport(destination.GetWorldPosition());
    }
  }
}
//#endregion