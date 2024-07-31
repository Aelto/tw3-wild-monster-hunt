enum WMH_LootTag {
  WMH_LootTag_Food = 0,
  WMH_LootTag_Gear = 1,
  WMH_LootTag_Herb = 2,
  WMH_LootTag_Alchemy = 3,
  WMH_LootTag_Material = 4,
  WMH_LootTag_Ore = 5,

  // these two shouldn't be used in containers as they are obtained from other
  // mechanics, but they're available in case it is needed.
  WMH_LootTag_Recipe = 6,
  WMH_LootTag_Schematic = 7
}