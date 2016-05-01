
import luxe.Input;
import luxe.Camera;
import luxe.Screen;
import luxe.States;
import luxe.Vector;
import states.*;

class Main extends luxe.Game {

    // Game design resolution
    public static var w: Int = 1280;
    public static var h: Int = 720;

    public static var machine:States;

    override function config(config:luxe.AppConfig) {

        return config;

    } //config

    override function ready() {

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

    override function onwindowsized ( e:WindowEvent ) {
      Luxe.camera.viewport = new luxe.Rectangle( 0, 0, e.x, e.y);
    }

} //Main
