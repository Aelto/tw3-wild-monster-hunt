@addMethod(W3PlayerWitcher)
function WMH_isRecipeKnown(recipe: name): bool {
  return this.alchemyRecipes.Contains(recipe);
}

@addMethod(W3PlayerWitcher)
function WMH_isSchematicKnown(schematic: name): bool {
  return this.craftingSchematics.Contains(schematic);
}