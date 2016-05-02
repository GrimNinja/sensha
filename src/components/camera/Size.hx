package components.camera;

import luxe.Camera;
import luxe.Component;
import luxe.Rectangle;
import luxe.Vector;

class Size extends Component {

  var camera: Camera;
  var size: Float;
  var offset: Float;

  override function onadded() {
    //called when initialising the component
    camera = cast entity;
    size = Main.h * 0.9;
    offset = Main.h * 0.05;

    camera.viewport = new Rectangle(offset, offset, size, size);

    camera.minimum_zoom = size / 1500;
    camera.zoom = size / 1500;
    camera.center = new Vector(size / 2 / camera.zoom, size / 2 / camera.zoom);
  }

  override function update(dt:Float) {
    //called every frame for you
  }

  override function onreset() {
    //called when the scene starts or restarts
  }

}
