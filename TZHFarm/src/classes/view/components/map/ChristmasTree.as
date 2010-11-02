package classes.view.components.map {
    import classes.utils.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;
	
	/**
	 * 圣诞树
	 * 这里有活动
	 */ 
    public class ChristmasTree extends MapObject {

        private var light_players:Array;
        private var _is_christmas:Boolean = false;
        private var colors:Dictionary;
        private var animation_mode:Number = 0;

        public function ChristmasTree(data:Object){
            _is_christmas = (data.is_christmas) ? true : false;
            super(data);
        }
        override protected function init_asset():void{
            var light:MovieClip;
            var player:TimelinePlayer;
            super.init_asset();
            if (!mc.lights){
                return;
            }
            var i:Number = 0;
            while (i < mc.lights.numChildren) {
                light = (mc.lights.getChildAt(i) as MovieClip);
                light.gotoAndStop(1);
                player = new TimelinePlayer(light);
                player.addEventListener(TimelinePlayer.FINISH, lightFinish);
                player.play(random_color(player));
                light_players.push(player);
                i++;
            }
        }
        
        public function has_lights():Boolean{
            if (!mc){
                return (false);
            };
            if (!mc.lights){
                return (false);
            };
            return (true);
        }
        
        public function highlight_presents(color:uint=0xFFCC00):void{
            if (mc){
                Effects.glow(mc.presents, color);
            }
        }
        
        private function refresh_light_anim(player:TimelinePlayer):void{
            switch (animation_mode){
                case 0:
                    player.set_fps(20);
                    player.play(random_color(player, colors[player]));
                    break;
                case 1:
                    player.set_fps(80);
                    player.play(random_color(player));
                    break;
                case 2:
                    player.set_fps(20);
                    player.play(next_color(player, 500));
                    break;
                case 3:
                    player.play([1], false);
                    return;
                case 4:
                    player.play([21], false);
                    return;
                case 5:
                    player.play([41], false);
                    return;
            }
        }
        
        private function next_color(player:Object, delay:Number=1000):Array{
            var lights:Array = [1, 2, 3];
            var c:Number = (colors[player] - 1);
            var index:Number = lights.indexOf((c + 1));
            colors[player] = ((index)==2) ? 1 : (c + 2);
            return ([[((c * 20) + 1), ((c * 20) + 20)], -(delay)]);
        }
        
        private function random_color(player:Object, exclude:Number=0):Array{
            var lights:Array = [1, 2, 3];
            if (exclude){
                lights.splice(lights.indexOf(exclude), 1);
            };
            var c:Number = (lights[Algo.rand(0, (lights.length - 1))] - 1);
            colors[player] = (c + 1);
            return ([[((c * 20) + 1), ((c * 20) + 20)]]);
        }
        
        private function refresh_lights():void{
            var player:TimelinePlayer;
            var i:Number = 0;
            while (i < light_players.length) {
                player = (light_players[i] as TimelinePlayer);
                if (animation_mode == 2){
                    colors[player] = 1;
                };
                player.stop(false);
                refresh_light_anim(player);
                i++;
            };
        }
        
        private function lightFinish(e:Event):void{
            var player:TimelinePlayer = (e.target as TimelinePlayer);
            refresh_light_anim(player);
        }
        
        override public function kill():void{
            var i:Number = 0;
            while (i < light_players.length) {
                TimelinePlayer(light_players[i]).stop(false);
                i++;
            };
            light_players = new Array();
            super.kill();
        }
        
        public function clear_highlight():void{
            if (mc){
                Effects.clear(mc.presents);
            };
        }
        
        public function is_christmas():Boolean{
            return (_is_christmas);
        }
        
        public function change_animation():void{
            animation_mode++;
            if (animation_mode > 5){
                animation_mode = 0;
            };
            refresh_lights();
        }
        
        public function lights_over():Boolean{
            var clickPoint:Point;
            var p:Point;
            if (mc){
                if (!mc.presents_hit_area){
                    return (true);
                };
                clickPoint = new Point(mc.presents_hit_area.mouseX, mc.presents_hit_area.mouseY);
                p = mc.presents_hit_area.localToGlobal(clickPoint);
                return (!(mc.presents_hit_area.hitTestPoint(p.x, p.y, true)));
            };
            return (true);
        }
        
        override protected function init():void{
            super.init();
            light_players = new Array();
            colors = new Dictionary();
            loader.cache_swf = true;
        }

    }
}
