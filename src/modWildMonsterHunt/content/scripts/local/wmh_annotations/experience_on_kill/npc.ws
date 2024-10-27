@wrapMethod(CNewNPC)
function CalculateExperiencePoints(optional skipLog: bool): int {
  var output: int =  wrappedMethod(skipLog);

  if (this.HasTag('WildMonsterHuntEntity')) {
    output += 5 + RoundF((output as f32) * 0.5);
  }

  return output;
}