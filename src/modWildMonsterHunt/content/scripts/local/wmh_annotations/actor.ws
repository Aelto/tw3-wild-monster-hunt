@addMethod(CActor)
function WMH_addEffect(effect: WMH_Effect) {
  this.effectManager.wmh_effects.PushBack(effect);
}


@addMethod(CActor)
function WMH_hasEffect(tag: name): bool {
  var i: int;

  for (i = 0; i < this.effectManager.wmh_effects.Size(); i += 1) {
    if (this.effectManager.wmh_effects[i].tag == tag) {
      return true;
    }
  }

  return false;
}

@addMethod(CActor)
function WMH_getEffectsByTag(tag: name): array<WMH_Effect> {
  var output: array<WMH_Effect>;
  var i: int;

  for (i = 0; i < this.effectManager.wmh_effects.Size(); i += 1) {
    if (this.effectManager.wmh_effects[i].tag == tag) {
      output.PushBack(this.effectManager.wmh_effects[i]);
    }
  }

  return output;
}

@addMethod(CActor)
function WMH_removeEffect(tag: name) {
  var to_remove: array<WMH_Effect>;
  var i: int;

  for (i = 0; i < this.effectManager.wmh_effects.Size(); i += 1) {
    if (this.effectManager.wmh_effects[i].tag == tag) {
      to_remove.PushBack(this.effectManager.wmh_effects[i]);
    }
  }

  for (i = 0; i < to_remove.Size(); i += 1) {
    this.effectManager.wmh_effects.Remove(to_remove[i]);
  }
}