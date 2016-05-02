package components.controls;

import luxe.Color;
import luxe.Input;
import luxe.Quaternion;
import luxe.Vector;

import entities.Tank;

import states.PlayState;

class LocalControls extends Controls {

  private var readyForTargets: Bool = false;

  private var settingMove: Bool = false;
  private var settingShot: Bool = false;

  private var color:Color;

  private var roundwait_event:String;

  override function init() {
    super.init();
    roundwait_event = Luxe.events.listen('roundwait', function(_) {
      this.moveTarget = null;
      this.shootTarget = null;
      this.readyForTargets = true;
    });

    color = cast(entity, Tank).color;
  }

  override function onremoved() {
    Luxe.events.unlisten(roundwait_event);
  }

  override function onmousedown(e: MouseEvent) {
    if (  e.pos.x < PlayState.map_camera.viewport.x ||
          e.pos.x > PlayState.map_camera.viewport.x + PlayState.map_camera.viewport.w ||
          e.pos.y < PlayState.map_camera.viewport.y ||
          e.pos.y > PlayState.map_camera.viewport.y + PlayState.map_camera.viewport.h ) {
            return;
    }
    var viewPos = Vector.Subtract(e.pos, new Vector(PlayState.map_camera.viewport.x, PlayState.map_camera.viewport.y));
    if (this.readyForTargets) {
      if (this.moveTarget == null) {
        this.moveTarget = PlayState.map_camera.screen_point_to_world(viewPos);
        this.settingMove = true;
      } else if (this.shootTarget == null) {
        this.shootTarget = PlayState.map_camera.screen_point_to_world(viewPos);
        this.settingShot = true;
      } else if (Vector.Subtract(PlayState.map_camera.screen_point_to_world(viewPos), moveTarget).length < 50) {
        this.settingMove = true;
      } else if (Vector.Subtract(PlayState.map_camera.screen_point_to_world(viewPos), shootTarget).length < 50) {
        this.settingShot = true;
      } else {
        trace(moveTarget, shootTarget);
        this.ready = true;
        this.readyForTargets = false;
      }
    }
  }

  override function onmousemove(e: MouseEvent) {
    if (  e.pos.x < PlayState.map_camera.viewport.x ||
          e.pos.x > PlayState.map_camera.viewport.x + PlayState.map_camera.viewport.w ||
          e.pos.y < PlayState.map_camera.viewport.y ||
          e.pos.y > PlayState.map_camera.viewport.y + PlayState.map_camera.viewport.h ) {
            return;
    }
    var viewPos = Vector.Subtract(e.pos, new Vector(PlayState.map_camera.viewport.x, PlayState.map_camera.viewport.y));
    if (this.settingMove) {
      this.moveTarget = PlayState.map_camera.screen_point_to_world(viewPos);
    } else if (this.settingShot) {
      this.shootTarget = PlayState.map_camera.screen_point_to_world(viewPos);
    }
  }

  override function onmouseup(e: MouseEvent) {
    if (this.readyForTargets) {
      this.settingMove = false;
      this.settingShot = false;
    }
  }

  override function update(dt: Float) {
    if (this.readyForTargets) {
      if (this.moveTarget != null) {
        var an = luxe.utils.Maths.radians(Vector.RotationTo(this.moveTarget, pos));
        var q = new Quaternion().setFromAxisAngle(new Vector(0,0,1),an);

        Luxe.draw.line({
            immediate: true,
            p0: new Vector(entity.pos.x, entity.pos.y),
            p1: new Vector(this.moveTarget.x, this.moveTarget.y),
            color: new Color(1,1,1,1),
            depth: 4,
            batcher: PlayState.map_batcher
        });

        Luxe.draw.box({
          immediate: true,
          x: this.moveTarget.x,
          y: this.moveTarget.y,
          rotation: q,
          w : Tank.SIZE,
          h : Tank.SIZE,
          depth: 5,
          color : new Color(this.color.r, this.color.g, this.color.b, 0.75),
          origin : new Vector(Tank.SIZE / 2, Tank.SIZE / 2),
          batcher: PlayState.map_batcher
        });
      }
      if (this.shootTarget != null) {
        Luxe.draw.line({
          immediate: true,
          p0: new Vector(this.moveTarget.x, this.moveTarget.y),
          p1: new Vector(this.shootTarget.x, this.shootTarget.y),
          color: new Color(1,1,1,1),
          depth: 4,
          batcher: PlayState.map_batcher
        });

        Luxe.draw.circle({
          immediate: true,
          x: this.shootTarget.x,
          y: this.shootTarget.y,
          r: 10,
          depth: 5,
          color: new Color(1,1,1,0.75),
          batcher: PlayState.map_batcher
        });
      }
    }
  }
}
