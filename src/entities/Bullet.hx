package entities;

import luxe.Color;
import luxe.Entity;
import luxe.Vector;
import luxe.collision.shapes.*;

import phoenix.Batcher;

import components.*;
import entities.*;
import states.PlayState;

class Bullet extends Entity {
  public static inline var RADIUS:Float = 10;
  public static inline var SPEED:Float = 1000;

  public var collider: Collider;
  public var movement: Movement;

  public function new() {
    super({
      name: 'bullet',
      name_unique: true
    });

    collider = new Collider({
      name: 'collider',
      against: 'tank',
      shape: new Circle(pos.x, pos.y, RADIUS)
    });

    this.add(collider);

    movement = new Movement({
      name: 'movement'
    });

    this.events.listen('hit', function(e) {
      this.active = false;
      this.remove('movement');
      this.remove('collider');
      PlayState.bullet_pool.put(this);
		});
  }

  public function reinit(tank:Tank) {
    var shootDir:Vector = Vector.Subtract(tank.get('controls').shootTarget, tank.pos).normalize();
    this.collider.ignore = cast tank;
    this.pos = Vector.Add(tank.pos, Vector.Multiply(shootDir, 50));
    this.movement.target = tank.get('controls').shootTarget.clone();
    this.movement.vel = shootDir.multiplyScalar(SPEED);
    this.add(movement);
    this.add(collider);
    this.active = true;
  }

  override public function update(dt: Float) {
    if (this.active) {
      Luxe.draw.circle({
        immediate: true,
        x : this.pos.x,
        y : this.pos.y,
        r : RADIUS,
        depth: 3,
        color : new Color(1,1,0,1),
        batcher: PlayState.map_batcher
      });
    }
  }

}
