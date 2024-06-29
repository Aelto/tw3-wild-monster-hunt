
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