class WMH_BiomeAreaTrigger extends CEntity {
	public editable var biome_tags: WMH_BiomeTags;

	event OnAreaEnter(area: CTriggerAreaComponent, activator: CComponent) {
		// thePlayer.DisplayHudMessage("" + this.biome_tags.roomWide);
	}
	event OnAreaExit(area: CTriggerAreaComponent, activator: CComponent) {}
}
