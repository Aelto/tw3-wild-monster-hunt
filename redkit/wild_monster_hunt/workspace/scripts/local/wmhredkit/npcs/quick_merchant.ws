// A type of merchant that doesn't use a scene to open its selling menu, interacting
// with it goes straight to the menu.
class WMH_QuickMerchant extends W3MerchantNPC {
	private var quickMerchantScenePlayer: WMH_QuickMerchantScenePlayer;
	event OnInteraction(actionName: string, activator: CEntity) {
		this.quickMerchantScenePlayer = new WMH_QuickMerchantScenePlayer in this;
		this.quickMerchantScenePlayer.entity = (CGameplayEntity)this;
		this.quickMerchantScenePlayer.start();
	}
}

statemachine class WMH_QuickMerchantScenePlayer {
	var entity: CGameplayEntity;
	
	public function start() {
		this.GotoState('Playing');
	}
}

state Waiting in WMH_QuickMerchantScenePlayer {}
state Playing in WMH_QuickMerchantScenePlayer {
	event OnEnterState(previous_state: name) {
		super.OnEnterState(previous_state);
		this.Playing_main();
	}
	
	entry function Playing_main() {
		var initDataObject : W3InventoryInitData = new W3InventoryInitData in theGame.GetGuiManager();
		var shopInventory: CInventoryComponent = parent.entity.GetInventory();
		
		if (shopInventory) {
			shopInventory.AutoBalanaceItemsWithPlayerLevel();
		}
		
		LogChannel('WMH', "QuickMerchantStatemachine: OpenInventory");
			
		initDataObject.containerNPC = (CGameplayEntity)parent.entity;
		OpenGUIPanelForScene( 'InventoryMenu', 'CommonMenu', parent.entity, initDataObject );
	}
}