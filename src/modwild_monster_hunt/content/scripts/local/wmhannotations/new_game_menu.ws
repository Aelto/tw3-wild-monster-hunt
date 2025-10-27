@wrapMethod(IngameMenuStructureCreator)
function CreateNewGameListArray(): CScriptedFlashArray {
  var l_ChildMenuFlashArray: CScriptedFlashArray;
  var l_DataFlashObject: CScriptedFlashObject;
  var output: CScriptedFlashArray;

  output = wrappedMethod();

  // then inject our own NewGame option
  l_DataFlashObject = CreateMenuItem(
    "NewGame",
    "new_game_wmh1",
    NameToFlashUInt('WildMonsterHunt'),
    // IMPORTANT: pick a random number above 27 that is not 100.
    //
    // This number is then passed as the `actionType` in the wrapper below,
    // you must then check against that number to detect when your NewGame is
    // used.
    76,
    false,
    "newgame_difficulty"
  );

  l_ChildMenuFlashArray = CreateDifficultyListArray(IGMC_EP1_Save);
  l_DataFlashObject.SetMemberFlashArray("subElements", l_ChildMenuFlashArray);
  l_DataFlashObject.SetMemberFlashString(
    "description",
    GetLocStringByKeyExtExt("panel_mainmenu_start_wmh_description")
  );
  
  output.PushBackFlashObject(l_DataFlashObject);

  return output;
}

@wrapMethod(CR4IngameMenu)
function OnItemActivated(actionType: int, menuTag: int): void {
  // see the IMPORTANT comment above explaining this random number,
  // if the number matches then we may launch a new game using our .redgame file
  if (actionType == 76) {
    fetchNewGameConfigFromTag(menuTag);

    theGame.SetDifficultyLevel(currentNewGameConfig.difficulty);
    theGame.RequestNewGame("levels\wmh_lv1\wmh_lv1.redgame");
    theGame.HideHardwareCursor();
    theGame.GetGuiManager().RequestMouseCursor(false);
    OnPlaySoundEvent("gui_global_game_start");
    GetRootMenu().CloseMenu();
  }
  // otherwise let the vanilla scripts, or any other wrapper handle the other
  // values 
  else {
    wrappedMethod(actionType, menuTag);
  }
}