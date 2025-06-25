@wrapMethod(IngameMenuStructureCreator)
function CreateNewGameListArray(): CScriptedFlashArray {
  var difficulties: CScriptedFlashArray;
  var difficulty: CScriptedFlashObject;
  var l_DataFlashObject: CScriptedFlashObject;
  var output: CScriptedFlashArray;

  output = wrappedMethod();

  // then inject our own NewGame option
  l_DataFlashObject = CreateMenuItem(
    "new_game_wmh1",
    "new_game_wmh1",
    NameToFlashUInt('WildMonsterHunt'),
    IGMActionType_MenuHolder,
    false,
    "newgame_difficulty"
  );

  difficulties = m_flashValueStorage.CreateTempFlashArray();

  difficulty = m_flashValueStorage.CreateTempFlashObject();
  difficulty = m_flashValueStorage.CreateTempFlashObject();
  difficulty.SetMemberFlashString("id", "mainmenu_Tutorials");
  difficulty.SetMemberFlashUInt("tag", 0); // tag
  difficulty.SetMemberFlashString("label", "Fresh Start");
  difficulty.SetMemberFlashString(
    "description",
    "A completely fresh start with a level 0 Geralt"
  );
  difficulties.PushBackFlashObject(difficulty);

  l_DataFlashObject.SetMemberFlashArray("subElements", difficulties);

  l_DataFlashObject.SetMemberFlashString(
    "description",
    "Start a new Wild Monster Hunt playthrough"
  );
  
  output.PushBackFlashObject(l_DataFlashObject);

  return output;
}

@addField(CR4IngameMenu)
var wmh_is_newgame_selected: bool;

@wrapMethod(CR4IngameMenu)
function OnOptionSelectionChanged(optionName: name, value: bool) {
  if (value && optionName != 'mainmenu_Tutorials') {
    this.wmh_is_newgame_selected = optionName == 'WildMonsterHunt'
                                || optionName == 'new_game_wmh1';
  }

  return wrappedMethod(optionName, value);
}

exec function wmhstart() {
  theGame.SetDifficultyLevel(EDM_Medium);
  theGame.RequestNewGame("levels\wmh_lv1\wmh_lv1.redgame");
  theGame.HideHardwareCursor();
  theGame.GetGuiManager().RequestMouseCursor(false);
  // OnPlaySoundEvent("gui_global_game_start");
  // GetRootMenu().CloseMenu();
}

@wrapMethod(CR4IngameMenu)
function OnItemActivated(actionType: InGameMenuActionType, menuTag: int): void {
  if (this.wmh_is_newgame_selected) {
    fetchNewGameConfigFromTag(menuTag);

    theGame.SetDifficultyLevel(EDM_Medium);
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