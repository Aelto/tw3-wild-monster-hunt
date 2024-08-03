class WMH_HerbalistContainer extends W3AnimatedContainer {
  event OnStreamIn() {
    super.OnStreamIn();
  }

  event OnInteractionActivated( interactionComponentName : string, activator : CEntity ) {
    super.OnInteractionActivated(interactionComponentName, activator);
  }
}