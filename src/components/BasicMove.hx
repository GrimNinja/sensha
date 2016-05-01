package components;

import luxe.Component;
import luxe.Sprite;
import luxe.Input;
import luxe.Vector;

import entities.*;
import states.PlayState;

class BasicMove extends Component {

  public var moving:Bool = false;
  private var speed:Float = 200;
  private var direction:Vector;
  private var target:Vector;

  private var roundmove_event:String;

  public function new(params:Dynamic) {
    super(params);
  }

  override function init() {
    roundmove_event = Luxe.events.listen('roundmove', doMove);
  }

  private function doMove(_e:Dynamic) {
    moving = true;
    target = get('controls').moveTarget;
    direction = Vector.Subtract(target, pos).normalize();

    var an = luxe.utils.Maths.radians(Vector.RotationTo(target, pos));
    entity.rotation.setFromAxisAngle(new Vector(0,0,1),an);
  }

  override function onremoved() {
      Luxe.events.unlisten(roundmove_event);
  }

  override function update(dt:Float) {
    if (moving) {
      pos = Vector.Add(pos, Vector.Multiply(direction, dt * speed));

      if (Vector.Subtract(pos, target).length < direction.length * dt * speed) {
        pos = target;
        moving = false;
        //shoot
        var bullet = PlayState.bullet_pool.get();
        bullet.reinit(cast entity);
      }
    }
  }
}
