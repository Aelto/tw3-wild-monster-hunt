@addField(W3EffectManager)
var wmh_effects: array<WMH_Effect>;

@wrapMethod(W3EffectManager)
function PerformUpdate(delta: float) {
  var i: int;

  for (i = 0; i < this.wmh_effects.Size(); i += 1) {
    if (this.wmh_effects[i].tick(delta)) {
      this.wmh_effects.EraseFast(i);

      i -= 1;
    }
  }

  wrappedMethod(delta);
}
