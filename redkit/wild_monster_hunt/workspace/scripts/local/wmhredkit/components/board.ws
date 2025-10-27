function WMH_findNearbyNoticeboards(): array<WMH_NoticeBoard> {
  var entities: array<CGameplayEntity>;
  var output: array<WMH_NoticeBoard>;
  var board: WMH_NoticeBoard;
  var i: int;

  FindGameplayEntitiesInRange(
    entities,
    (CNode)thePlayer,
    25,
    10, // max results
    'WMH_NoticeBoard'
  );

  for (i = 0; i < entities.Size(); i += 1) {
    board = (WMH_NoticeBoard)entities[i];

    if (board) {
      output.PushBack(board);
    }
  }

  return output;
}

class WMH_NoticeBoard extends W3NoticeBoard {
  private var oneliners: array<SU_OnelinerEntity>;
  private var general_oneliner: SU_OnelinerEntity;
  private var contract_manager: WMH_ContractManager;

  private var update_cooldown: WMH_Ticker;

  event OnAreaEnter(area: CTriggerAreaComponent, activator: CComponent) {
    super.OnAreaEnter(area, activator);

    this.setupContractOneliners();
  }

  event OnInteraction(actionName: string, activator: CEntity) {
    WMH_getContractManager().GotoState('DialogChoice');
  }

  event OnInteractionActivated(interactionComponentName : string, activator : CEntity) {
    super.OnInteractionActivated(interactionComponentName, activator);

    WMHTUTOFACT(
      'WMH_NoticeBoard',
      GetLocStringByKeyExt("wmh_tutorial_board_interaction_activated_title"),
      GetLocStringByKeyExt("wmh_tutorial_board_interaction_activated_description")
    );

    if (activator == thePlayer) {
      this.setupContractOneliners();
    }
  }

  public function setupContractOneliners(optional force: bool) {
    this.contract_manager = WMH_getContractManager();

    if (!this.update_cooldown) {
      this.update_cooldown = (new WMH_Ticker in this).init(5.0);
    }

    if (force) {
      this.update_cooldown.reset();
    }

    this.AddTimer('setupContractOnelinersTimer', 2.0);
  }

  private timer function setupContractOnelinersTimer(delta: float, id: int) {
    var target_names: array<string> = this.contract_manager.getPendingTargetsNameHtml();
    var oneliner: SU_OnelinerEntity;
    var contract_level: WMH_Level;
    var general_text: string;
    var i: int = 0;

    var position: Vector;
    var forward: Vector;
    var left: Vector;

    var rot_forward: EulerAngles;
    var mesh: CComponent;

    if (!this.update_cooldown.validate()) {
      this.AddTimer('setupContractOnelinersTimer', 1.0);
      return;
    }

    mesh = this.GetComponentByClassName('CStaticMeshComponent');

    if (mesh) {}
    else {
      return;
    }

    while (this.oneliners.Size() < target_names.Size()) {
      this.oneliners.PushBack(
        SU_onelinerEntity(
          "",
          this
        )
      );
    }

    WMHINFO("WMH_NoticeBoard::setupContractOneliners()");

    forward = this.GetHeadingVector();
    rot_forward = this.GetLocalRotation();
    left = VecFromHeading(AngleNormalize180(this.GetHeading() - 90));

    for (i = 0; i < target_names.Size(); i += 1) {
      WMHINFO("target_name = " + target_names[i] + " i = " + i);

      oneliner = this.oneliners[i];
      oneliner.text = target_names[i];
      oneliner.render_distance = 5;

      oneliner.offset = MatrixGetTranslation(
        MatrixBuiltRotation(
          EulerAngles(
            AngleNormalize180(rot_forward.Pitch + i * -45),
            AngleNormalize180(rot_forward.Yaw + 1 * 90),
            AngleNormalize180(rot_forward.Roll + 0 * -90)
          )
        )
        * MatrixBuiltTranslation(forward * 0.8)
      );

      oneliner.offset.W = 0;
      oneliner.offset.Z += 1.0;
      oneliner.update();
    }

    contract_level = WMH_getStorage().general.level;
    general_text = StrReplace(
      GetLocStringByKeyExt("wmh_reputation_level_oneliner"),
      "{{level}}",
      FloorF(contract_level.value)
    );

    if (this.general_oneliner) {
      this.general_oneliner.text = general_text;
      this.general_oneliner.update();
    }
    else {
      this.general_oneliner = SU_onelinerEntity(
        general_text,
        this
      );
    }

     this.general_oneliner.offset = Vector(0, 0, 2.0);
     this.general_oneliner.render_distance = 5;
  }

  private function unregisterOneliners() {
    var oneliner: SU_OnelinerEntity;
    var i: int;

    for (i = 0; i < this.oneliners.Size(); i += 1) {
      oneliner = this.oneliners[i];
      oneliner.unregister();
    }

    this.oneliners.Clear();

    if (this.general_oneliner) {
      this.general_oneliner.unregister();
      delete this.general_oneliner;
    }
  }
}