@wrapMethod(CNewNPC)
function CalculateExperiencePoints(optional skipLog: bool): int {
  var output: int;

  output = wrappedMethod(skipLog);

  if (this.HasTag('WildMonsterHuntEntity')) {
    output += 5 + RoundF((float)output * 0.5);

    // the bookshelf also adds some flat XP bonus to every kills for each level
    // of the upgrade
    output += WMH_experienceBonusOnKill(this);
  }

  return output;
}