class WMH_NoticeBoard extends W3NoticeBoard {
  private var oneliners: array<SU_OnelinerEntity>;
  private var contract_manager: WMH_ContractManager;

  private var update_cooldown: WMH_Ticker;

  event OnAreaEnter(area: CTriggerAreaComponent, activator: CComponent) {
    super.OnAreaEnter(area, activator);

    this.setupContractOneliners(thePlayer.wmh.hunt.contract);
  }

  event OnInteractionActivated(interactionComponentName : string, activator : CEntity) {
    super.OnInteractionActivated(interactionComponentName, activator);

    WMHTUTOFACT(
      'WMH_NoticeBoard',
      "Monster Hunts",
      "The noticeboard displays up to 5 targets for your monster hunts. "
      + "Slaying the designated targets during your hunts will allow you to "
      + "complete the contracts, netting you crowns and experience while also "
      + "immediately receiving a new target in return the next time you get back "
      + "to camp."
      + "<br/><br/>"
      + "Every now and then an usual creature may be listed, when it appears, "
      + "hunting it should be your first priority as experience gain from "
      + "regular contracts is halted until the target is no more."
    );

    if (activator == thePlayer) {
      this.setupContractOneliners(thePlayer.wmh.hunt.contract);
    }
  }

  public function setupContractOneliners(contract_manager: WMH_ContractManager) {
    this.contract_manager = contract_manager;

    if (!this.update_cooldown) {
      this.update_cooldown = (new WMH_Ticker in this).init(5.0);
    }

    this.AddTimer('setupContractOnelinersTimer', 2.0);
  }

  private timer function setupContractOnelinersTimer(delta: float, id: int) {
    var target_names: array<string> = this.contract_manager.getPendingTargetsNameHtml();
    var oneliner: SU_OnelinerEntity;
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
  }

  private function unregisterOneliners() {
    var oneliner: SU_OnelinerEntity;
    var i: int;

    for (i = 0; i < this.oneliners.Size(); i += 1) {
      oneliner = this.oneliners[i];
      oneliner.unregister();
    }

    this.oneliners.Clear();
  }
}