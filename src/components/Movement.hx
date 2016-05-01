package components;

import luxe.Component;
import luxe.Vector;

class Movement extends Component {
  public var vel: Vector;
  public var target: Vector;

  override function update(dt:Float) {
    pos.x += this.vel.x * dt;
    pos.y += this.vel.y * dt;

    if (vel.lengthsq == 0 || Vector.Subtract(pos, target).length < vel.length * dt) {
      entity.events.fire('hit');
    }
  }
}
