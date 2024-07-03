class WMH_SettlementAreaTrigger extends CEntity {
	private editable var unlock_fact: string;
	hint unlock_fact = "If provided, points to a fact that must be defined for the area to trigger";

	event OnAreaEnter(area: CTriggerAreaComponent, activator: CComponent) {
		if (this.canTrigger()) {
			thePlayer.wmh.onSettlementEnter();
		}
	}

	event OnAreaExit(area: CTriggerAreaComponent, activator: CComponent) {
		if (this.canTrigger()) {
			thePlayer.wmh.onSettlementExit();
		}
	}
	
	private function canTrigger(): bool {
		return StrLen(this.unlock_fact) <= 0
			|| FactsDoesExist(this.unlock_fact);
	}
}
