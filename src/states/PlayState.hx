package states;

import luxe.Entity;
import luxe.States;
import luxe.Scene;
import luxe.Input;
import luxe.Color;
import luxe.Vector;
import luxe.collision.shapes.*;
import luxe.collision.Collision;
import luxe.structural.Pool;
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
      startPos: new Vector(100, 100)
    });
    players.push(player1);

    var player2 = new Tank({
      player:2,
      control: TankControl.AI,
      color: new Color(0,0,1,1),
      startPos: new Vector(Main.w - 100, 100)
    });
    players.push(player2);

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
