class WMH_RefillableContainer extends W3AnimatedContainer {
	public editable var loot_tags: array<WMH_LootTag>;
	
	event OnSpawned( spawnData : SEntitySpawnData ) {
		super.OnSpawned(spawnData);
		
		if (spawnData.restored && this.IsEmpty()) {
			this.AddTimer('wmhRefill', 10, true);
		}
	}
	

	event OnInteractionActivated( interactionComponentName : string, activator : CEntity ) {		
		// thePlayer.DisplayHudMessage("WMH_RefillableContainer");
		super.OnInteractionActivated(interactionComponentName, activator);
	}
	
	timer function wmhRefill(delta: float, id: int) {
		var inventory: CInventoryComponent;
		
		if (!this.IsEmpty()) {
			return;
		}
		
		inventory = this.GetInventory();
		inventory.AddAnItem('Raw meat', 1);
		SetFocusModeVisibility( FMV_Interactive );
		ApplyAppearance( "1_full" );
		Enable( true );
	}
}