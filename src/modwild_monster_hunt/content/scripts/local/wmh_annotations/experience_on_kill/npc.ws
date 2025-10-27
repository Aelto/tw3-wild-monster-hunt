@wrapMethod(CNewNPC)
function CalculateExperiencePoints(optional skipLog: bool): int {
  var output: int;

  output = wrappedMethod(skipLog);

  if (this.HasTag('WildMonsterHuntEntity')) {
    output += 5 + RoundF((float)output * 0.5);
  }

  return output;
}