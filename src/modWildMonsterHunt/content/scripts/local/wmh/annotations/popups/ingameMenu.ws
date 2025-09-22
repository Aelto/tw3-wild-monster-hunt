@wrapMethod(CR4IngameMenu)
protected function prepareBigMessage( epIndex : int ) {
  if (!WMH_isInWmhLevel()) {
    wrappedMethod(epIndex);
  }
}