
struct WMH_BiomeTags {
  editable var roomWide: bool;
  editable var altitudeHigh: bool;
  editable var humidityHigh: bool;
  editable var vegetationHigh: bool;
  
  editable var lightLow: bool;
  hint lightLow = "Set to true for dark areas";
  
  editable var structuresHigh: bool;
  hint structuresHigh = "Set to true for human structures or ruins";
  
  editable var underground: bool;
}

function WMH_mergeBiomeTags(a: WMH_BiomeTags, b: WMH_BiomeTags): WMH_BiomeTags {
	return WMH_BiomeTags(
		a.roomWide || b.roomWide,
		a.altitudeHigh || b.altitudeHigh,
		a.humidityHigh || b.humidityHigh,
		a.vegetationHigh || b.humidityHigh,
		a.lightLow || b.lightLow,
		a.structuresHigh || b.structuresHigh,
		a.underground || b.underground
	);
}

function WMH_biomeTagsEmpty(tags: WMH_BiomeTags): bool {
  return !tags.roomWide
      && !tags.altitudeHigh
      && !tags.humidityHigh
      && !tags.vegetationHigh
      && !tags.lightLow
      && !tags.structuresHigh
      && !tags.underground;
}