// A type of merchant that doesn't use a scene to open its selling menu, interacting
// with it goes straight to the menu.
class WMH_HerbalistNPC extends W3MerchantNPC {
  private var quickMerchantScenePlayer: WMH_QuickMerchantScenePlayer;

  event OnInteraction(actionName: string, activator: CEntity) {
    var inventory: CInventoryComponent;
    
    inventory = this.GetInventory();
    
    // notice the switch between `inventory` and `this` sometimes.
    if (!inventory.HasTag('Merchant')) {
      inventory.AddTag('Merchant');
    }
    
    if (this.HasTag('Merchant')) {
      this.AddTag('Merchant');
    }
    
    this.quickMerchantScenePlayer = new WMH_QuickMerchantScenePlayer in this;
    this.quickMerchantScenePlayer.entity = (CGameplayEntity)this;
    this.quickMerchantScenePlayer.start();
  }
}

// a custom class that controls the price of selling/buying items
class WMH_HerbalistGuiShopInventoryComponent extends W3GuiShopInventoryComponent {
  protected function ShopHasInfiniteFunds(): bool {
    return true;
  }

  // Shop is selling Item to the Player
  public function GiveItem( itemId : SItemUniqueId, customer : W3GuiBaseInventoryComponent, optional quantity : int, optional out newItemID : SItemUniqueId ) : bool
  {
    var customerMoney : int;
    var itemPrice : int;
    var success : bool;
    var invItem : SInventoryItem;

    success = false;
    
    if( quantity < 1 )
    {
      quantity = 1;
    }

    customerMoney = customer._inv.GetMoney();

    invItem = _inv.GetItem( itemId );
    
    // items are bought for 5 crowns, it acts as a small gold sink.
    itemPrice = 5; // _inv.GetInventoryItemPriceModified( invItem, false ) * quantity;
    
    if ( customerMoney >= itemPrice )
    {
      success = super.GiveItem( itemId, customer, quantity, newItemID );
      if ( success )
      {
        customer._inv.RemoveMoney( itemPrice );
        
        // if ( !ShopHasInfiniteFunds() )
        // {
        //   _inv.AddMoney( itemPrice );
        // }
      }
    }
    return success;
  }

  // Shop is purchasing Item from the Player; Giver = Player
  public function ReceiveItem( itemId : SItemUniqueId, giver : W3GuiBaseInventoryComponent, optional quantity : int, optional out newItemID : SItemUniqueId ) : bool
  {
    // this is a copy of the vanilla code, except for the place where it gets
    // the item's price.
    var shopMoney : int;
    var itemCost : int;
    var success : bool;
    var invItem : SInventoryItem;

    shopMoney = _inv.GetMoney();

    invItem = giver._inv.GetItem( itemId );
    
    // items are always sold for 1 crown
    itemCost = 1; // _inv.GetInventoryItemPriceModified( invItem, true ) * quantity;

    success = false;

    if ( itemCost >= 0 && ( shopMoney >= itemCost || ShopHasInfiniteFunds() ) )
    {
      success = super.ReceiveItem( itemId, giver, quantity, newItemID );
      if ( success )
      {
        // if ( !ShopHasInfiniteFunds() )
        // {
        //   _inv.RemoveMoney( itemCost );
        // }
        giver._inv.AddMoney( itemCost );
      }
    }
    return success;
  }
}