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
    moveTarget = new Vector(Math.random() * Main.w, Math.random() * Main.h);
    shootTarget = new Vector(Math.random() * Main.w, Math.random() * Main.h);
    ready = true;
  }
}
