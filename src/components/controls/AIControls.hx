package components.controls;

import luxe.Vector;

class AIControls extends Controls {

  private var roundwait_event:String;

  override function init() {
    super.init();
    roundwait_event = Luxe.events.listen('roundwait', setTargets);
  }

  override function onremoved() {
    Luxe.events.unlisten(roundwait_event);
  }

  private function setTargets(e:Dynamic) {
    moveTarget = new Vector(Math.random() * 1400 + 50, Math.random() * 1400 + 50);
    shootTarget = new Vector(Math.random() * 1400 + 50, Math.random() * 1400 + 50);
    ready = true;
  }
}
