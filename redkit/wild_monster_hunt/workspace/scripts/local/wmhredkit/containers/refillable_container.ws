class WMH_RefillableContainer extends W3AnimatedContainer {
	public editable var loot_tags: array<WMH_LootTag>;
	hint loot_tags = "Define the kind of items that can be added to the container, multiple tags can result in multiple items being added with diminishing returns";

	// each hunt gets a unique seed, and chests are refilled every hunt using that
	// seed.
	private var previous_refill_seed: int;
	default previous_refill_seed = 0;
	
	event OnStreamIn() {
		super.OnStreamIn();
		
		WMHINFO("WMH_RefillableContainer, OnStreamIn(), this.previous_refill_seed = " + this.previous_refill_seed);
		
		if (this.IsEmpty() || this.previous_refill_seed <= 0) {
			this.AddTimer('maybeRefillForHunt', 10, true);
		}
	}
	

	event OnInteractionActivated( interactionComponentName : string, activator : CEntity ) {		
		super.OnInteractionActivated(interactionComponentName, activator);
	}

	timer function maybeRefillForHunt(delta: float, id: int) {
		var inventory: CInventoryComponent;
		var position: Vector;
		var hunt_seed: int;
		var self_seed: int;

		hunt_seed = WMH_getHuntSeedFact();
		if (hunt_seed > 0 && this.previous_refill_seed == hunt_seed) {
			return;
		}

		position = this.GetWorldPosition();
		self_seed = hunt_seed + (int)position.X + (int)position.Y;

		inventory = this.GetInventory();
		inventory.RemoveAllItems();

		thePlayer.wmh.submitOnContainerRefill(
			this,
			inventory,
			self_seed
		);

		SetFocusModeVisibility( FMV_Interactive );
		ApplyAppearance( "1_full" );
		Enable( true );

		this.previous_refill_seed = hunt_seed;
	}
}