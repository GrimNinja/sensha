package components;

import luxe.Component;
import luxe.Entity;
import luxe.collision.Collision;
import luxe.collision.shapes.Shape;
import luxe.options.ComponentOptions;

typedef ColliderOptions = {
  > ComponentOptions,

  @:optional var against: String;
  var shape: Shape;
}

class Collider extends Component {
  public var against: String;
	public var shape: Shape;
  public var ignore: Entity;

	override public function new(_options: ColliderOptions) {
		super(_options);

		against = (_options.against != null) ? _options.against : '';
		shape = _options.shape;
	}

  override public function onadded() {
    this.shape.x = entity.pos.x;
		this.shape.y = entity.pos.y;
  }

  override public function update(dt: Float) {
		this.shape.x = entity.pos.x;
		this.shape.y = entity.pos.y;

		if (entity.active && against.length > 0) {

			var targets = new Array<Entity>();
			Luxe.scene.get_named_like(against, targets);

			for (target in targets) {
				if (target.active
				&&  target.has('collider')
        &&  target != ignore){

					var target_collider = target.get('collider');

					if (Collision.shapeWithShape(shape, target_collider.shape) != null) {
						// trace(entity.name + ' hit ' + target.name);
						target.events.fire('hit');
						entity.events.fire('hit');
					}
				}
			}
		}
	}
}
