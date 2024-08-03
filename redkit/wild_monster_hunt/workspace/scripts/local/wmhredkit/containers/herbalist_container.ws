class WMH_HerbalistContainer extends W3AnimatedContainer {
  event OnStreamIn() {
    super.OnStreamIn();
  }

  event OnInteractionActivated( interactionComponentName : string, activator : CEntity ) {
    super.OnInteractionActivated(interactionComponentName, activator);
  }

	public function addItem(item: name) {
		this.GetInventory().AddAnItem(item);
		ApplyAppearance( "1_full" );
		Enable( true );
	}
}