package entities;

import luxe.Color;
import luxe.Entity;
import luxe.Vector;
import luxe.collision.shapes.*;

import components.*;
import components.controls.*;

enum TankControl {
  AI;
  LOCAL;
  NETWORK;
}

typedef TankOptions = {
  var player: Int;
  var control: TankControl;
  var color: Color;
  @:optional var startPos: Vector;
}

class Tank extends Entity {

  public static inline var SIZE:Float = 100;

  public var collider: Collider;
  public var movement: BasicMove;
  public var controls: Controls;

  public var color:Color;

  public function new(options:TankOptions) {
    super({
      name: 'tank',
      name_unique: true
    });

    if (options.startPos != null) {
      pos = options.startPos;
    }

    color = options.color;

    switch (options.control) {
      case TankControl.LOCAL:
        controls = new LocalControls();
      case TankControl.AI:
        controls = new AIControls();
      default:
        controls = new AIControls();
    }
    this.add(controls);

    collider = new Collider({
      name: 'collider',
      shape: Polygon.square(pos.x, pos.y, SIZE, true)
    });
    this.add(collider);

    movement = new BasicMove({
      name: 'movement'
    });
    this.add(movement);

    this.events.listen('hit', function(e) {
      Luxe.camera.shake(10);
      //this.remove('movement');
      //this.remove('controls');
      //this.remove('collider');
      //this.active = false;
		});
  }

  public function isReady() {
    if (!this.active) {
      return true;
    }
    return get('controls').ready;
  }

  public function isMoving() {
    if (!this.active) {
      return false;
    }
    return get('movement').moving;
  }

  override function update(dt:Float) {
    Luxe.draw.box({
      immediate: true,
      x: this.pos.x,
      y: this.pos.y,
      rotation: this.rotation.clone(),
      w : SIZE,
      h : SIZE,
      depth: 5,
      color : this.color,
      origin : new Vector(SIZE / 2, SIZE / 2)
    });
  }

}
