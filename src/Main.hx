import luxe.Camera;
import luxe.Input;
import luxe.States;
import luxe.Vector;
import states.*;

class Main extends luxe.Game {

    // Game design resolution
    public static var w: Float;// = Luxe.screen.width;
    public static var h: Float;// = Luxe.screen.height;

    public static var machine:States;

    override function config(config:luxe.AppConfig) {

        return config;

    } //config

    override function ready() {

      w = Luxe.screen.width;
      h = Luxe.screen.height;

      Luxe.camera.size = new Vector(Main.w, Main.h);
      Luxe.camera.size_mode = SizeMode.fit;

      machine = new States({name: 'stateachine'});
      machine.add(new PlayState({name: 'playstate'}));

      machine.set('playstate');

    } //ready

    override function onkeyup( e:KeyEvent ) {

        if(e.keycode == Key.escape) {
            Luxe.shutdown();
        }
        if(e.keycode == Key.key_r) {
          Luxe.scene.reset();
        }

    } //onkeyup

    override function update(dt:Float) {

    } //update

} //Main
