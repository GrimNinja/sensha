package states;

import luxe.Camera;
import luxe.Entity;
import luxe.Rectangle;
import luxe.States;
import luxe.Scene;
import luxe.Input;
import luxe.Color;
import luxe.Vector;
import luxe.collision.shapes.*;
import luxe.collision.Collision;
import luxe.structural.Pool;

import phoenix.Batcher;

import entities.Bullet;
import entities.Tank;


typedef PlayStateArgs = {
  name: String
}

enum GameState {
  WAITING;
  MOVING;
  READY;
}

class PlayState extends State {

  public static var bullet_pool:Pool<Bullet>;
  public static var map_batcher: Batcher;
  public static var map_camera: Camera;

  var players:Array<Tank>;
  var gamestate:GameState;

  public function new( _data:PlayStateArgs ) {
    super({ name:_data.name });
  }

  override function init() {

  } //init

  override function onleave<T>( _value:T ) {
    for (player in players) {
      player.destroy();
    }
    players = null;
    bullet_pool = null;
  } //onleave

  override function onenter<T>( _value:T ) {

    map_camera = new Camera({name:'map_camera'});

    map_batcher = Luxe.renderer.create_batcher({name:'map_batcher', camera:map_camera.view});

    var cam_size = new components.camera.Size({name:'camerasize'});

    map_camera.add(cam_size);

    trace(map_camera.viewport);

  //  var map_xy = Luxe.camera.world_point_to_screen(new Vector(map_camera.viewport.x, map_camera.viewport.y));
    //var map_wh = Luxe.camera.world_point_to_screen(new Vector(map_camera.viewport.x, map_camera.viewport.y));

    Luxe.draw.rectangle({
      x : map_camera.viewport.x,
      y : map_camera.viewport.y,
      w : map_camera.viewport.w,
      h : map_camera.viewport.h,
      color : new Color(1,1,1,1),
      depth: 10
    });

    bullet_pool = new Pool<Bullet>(4, function():Bullet {
			var entity = new Bullet();
			entity.active = false;
			return entity;
		});

    players = new Array();

    var player1 = new Tank({
      player:1,
      control: TankControl.LOCAL,
      color: new Color(1,0,0,1),
      startPos: new Vector(50, 50)
    });
    players.push(player1);

    var player2 = new Tank({
      player:2,
      control: TankControl.AI,
      color: new Color(0,0,1,1),
      startPos: new Vector(1450, 50)
    });
    players.push(player2);

    var player3 = new Tank({
      player:3,
      control: TankControl.AI,
      color: new Color(0,1,0,1),
      startPos: new Vector(50, 1450)
    });
    players.push(player3);

    var player4 = new Tank({
      player:4,
      control: TankControl.AI,
      color: new Color(1,1,0,1),
      startPos: new Vector(1450, 1450)
    });
    players.push(player4);

    gamestate = GameState.READY;
  } //onenter

  override function update(dt:Float) {
    switch (gamestate) {
      case GameState.READY: {
        Luxe.events.fire('roundwait');
        gamestate = GameState.WAITING;
      }
      case GameState.WAITING: {
        if (Lambda.foreach(players, function(t) { return t.isReady();})) {
          Luxe.events.fire('roundmove');
          gamestate = GameState.MOVING;
        }
      }
      case GameState.MOVING: {
        var bullets = new Array<Entity>();
        Luxe.scene.get_named_like('bullet', bullets);

        if (Lambda.foreach(bullets, function(b) { return !b.active;}) && Lambda.foreach(players, function(t) { return !t.isMoving();})) {
          Luxe.events.fire('roundready');
          gamestate = GameState.READY;
        }
      }
    }
  }
}
