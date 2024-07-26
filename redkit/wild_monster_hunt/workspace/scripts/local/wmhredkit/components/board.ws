class WMH_NoticeBoard extends W3NoticeBoard {
  private var oneliners: array<SU_OnelinerEntity>;
  private var contract_manager: WMH_ContractManager;

  event OnAreaEnter(area: CTriggerAreaComponent, activator: CComponent) {
    super.OnAreaEnter(area, activator);

    this.setupContractOneliners(thePlayer.wmh.hunt.contract);
  }

  event OnInteractionActivated(interactionComponentName : string, activator : CEntity) {
    if (activator == thePlayer) {
      this.setupContractOneliners(thePlayer.wmh.hunt.contract);
    }
  }

  public function setupContractOneliners(contract_manager: WMH_ContractManager) {
    this.contract_manager = contract_manager;

    this.AddTimer('setupContractOnelinersTimer', 2.0);
  }

  private timer function setupContractOnelinersTimer(delta: float, id: int) {
    var target_names: array<string> = this.contract_manager.getPendingTargetsName();
    var oneliner: SU_OnelinerEntity;
    var i: int = 0;

    var position: Vector;
    var forward: Vector;
    var left: Vector;

    var rot_forward: EulerAngles;
    var mesh: CComponent;

    mesh = this.GetComponentByClassName('CStaticMeshComponent');

    if (mesh) {}
    else {
      return;
    }

    this.unregisterOneliners();
    WMHINFO("WMH_NoticeBoard::setupContractOneliners()");

    forward = this.GetHeadingVector();
    rot_forward = this.GetLocalRotation();
    left = VecFromHeading(AngleNormalize180(this.GetHeading() - 90));

    for (i = 0; i < target_names.Size(); i += 1) {
      WMHINFO("target_name = " + target_names[i] + " i = " + i);

      oneliner = SU_onelinerEntity(
        target_names[i],
        this
      );

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