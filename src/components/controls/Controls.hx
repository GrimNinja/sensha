package components.controls;

import luxe.Component;
import luxe.Vector;

class Controls extends Component {

  public var moveTarget:Vector;
  public var shootTarget:Vector;

  public var ready:Bool = false;

  public function new() {
    super({name:'controls'});
  }

  override function init() {
    Luxe.events.listen('roundmove', function(_e:Dynamic) { ready = false; });
  }

}
