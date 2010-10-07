package classes.view.components.map {
    import flash.events.*;
    import classes.utils.*;
    import flash.display.*;
    import com.greensock.*;
    import com.greensock.easing.*;

	/**
	 * 小蜜蜂
	 */ 
    public class BeesSwarm extends Sprite {

        public const ON_POLLINATE:String = "onPollinate";

        private var timeline:TimelineMax;
        private var scale:Number = 1;
        public var target:Plant;
        private var return_tween:TweenMax;
        private var tween_time:Number;
        private var hive_changed:Boolean = false;
        private var last_coords:Object;
        private var zigzag_min_width:Number;
        private var zigzags:Number;
        private var oscillator:Oscillator;
        public var hive:Hive;
        private var pollination_failed:Boolean = false;
        private var zigzag_max_width:Number;
        private var swarm:Sprite;

        public function BeesSwarm(hive:Hive, target:Plant, scale:Number=1){
            super();
            this.scale = scale;
            this.hive = hive;
            this.target = target;
            init();
        }
        
        private function hiveOnChange(e:Event):void{
            hive_changed = true;
        }
        
        private function check_position(tween:String="out"):void{
            var angle:Number;
            var i:Number;
            var bee:MovieClip;
            if (tween == "in"){
                if (hive_changed){
                    timeline.stop();
                    refresh_path();
                    hive_changed = false;
                    return;
                };
            }
            var index:String = "swarm";
            if (last_coords[index]){
                if ((((swarm.y == last_coords[index].y)) && ((swarm.x == last_coords[index].x)))){
                    return;
                };
                angle = Math.atan2((swarm.y - last_coords[index].y), (swarm.x - last_coords[index].x));
                i = 0;
                while (i < swarm.numChildren) {
                    bee = (swarm.getChildAt(i) as MovieClip);
                    if (Math.cos(angle) > 0){
                        bee.scaleX = ((swarm.scaleX)<0) ? 1 : -1;
                    } else {
                        bee.scaleX = ((swarm.scaleX)<0) ? -1 : 1;
                    }
                    i++;
                }
            }
            last_coords[index] = {
                x:swarm.x,
                y:swarm.y
            };
        }
        
        private function get _target():Object{
            var obj:Object = new Object();
            if (hive.is_flipped()){
                obj.x = (target.x - ((target.width / 3) * scale));
            } else {
                obj.x = (target.x + ((target.width / 3) * scale));
            };
            obj.y = (target.y - ((target.height / 2) * scale));
            return (obj);
        }
        
        private function init():void{
            oscillator = new Oscillator();
            swarm = new Sprite();
            swarm.x = (hive.x / scale);
            swarm.y = (hive.y / scale);
            swarm.addChild(hive.bee1);
            swarm.addChild(hive.bee2);
            swarm.addChild(hive.bee3);
            hive.bee1.gotoAndPlay(1);
            hive.bee2.gotoAndPlay(1);
            hive.bee3.gotoAndPlay(1);
            addChild(swarm);
            if (hive.is_flipped()){
                swarm.scaleX = -1;
            }
            hive.addEventListener(hive.BEES_ARE_OUT, beesAreOut);
            hive.addEventListener(hive.ON_CHANGE, hiveOnChange);
            hive.goOut();
            last_coords = new Object();
        }
        
        private function generate_zigzag(origin:Object, target:Object):Array{
            var obj:Object;
            var b:Number;
            var c:Number;
            var d:Number;
            var a:Number;
            var angle:Number = Math.atan2(((target.y / scale) - (origin.y / scale)), ((target.x / scale) - (origin.x / scale)));
            var distance:Number = get_distance((origin.x / scale), (origin.y / scale), (target.x / scale), (target.y / scale));
            zigzags = Math.max(1, (distance / 150));
            zigzag_min_width = ((5 * distance) / 100);
            zigzag_max_width = (zigzag_min_width + 20);
            var points:Array = new Array();
            var sign:Number = ((Algo.rand(0, 1))==1) ? 1 : -1;
            var i:Number = 1;
            while (i < (zigzags + 1)) {
                obj = new Object();
                b = ((i * distance) / (zigzags + 1));
                c = Algo.rand(zigzag_min_width, zigzag_max_width);
                d = Math.sqrt(((b * b) + (c * c)));
                a = Math.atan((c / b));
                obj.x = ((origin.x / scale) + (Math.cos((angle + (sign * a))) * d));
                obj.y = ((origin.y / scale) + (Math.sin((angle + (sign * a))) * d));
                sign = (sign * -1);
                points.push(obj);
                i++;
            };
            points.push({
                x:(target.x / scale),
                y:(target.y / scale)
            });
            return (points);
        }
        
        private function refresh_path():void{
            var time:Number;
            var target:Object = new Object();
            target.x = (swarm.x * scale);
            target.y = (swarm.y * scale);
            var points:Array = generate_zigzag(target, hive);
            timeline = new TimelineMax({onComplete:makeHoney});
            var j:Number = 0;
            while (j < points.length) {
                if (j == 0){
                    time = (get_distance((target.x / scale), (target.y / scale), points[0].x, points[0].y) / 100);
                } else {
                    time = (get_distance(points[(j - 1)].x, points[(j - 1)].y, points[j].x, points[j].y) / 100);
                };
                timeline.append(new TweenMax(swarm, time, {
                    x:points[j].x,
                    y:points[j].y,
                    ease:Linear.easeNone,
                    onUpdate:check_position,
                    onUpdateParams:["in"]
                }));
                j++;
            };
        }
        
        public function kill():void{
            if (timeline){
                timeline.invalidate();
                timeline.stop();
            };
            hive.removeEventListener(hive.ON_CHANGE, hiveOnChange);
            hive.removeEventListener(hive.BEES_ARE_OUT, beesAreOut);
            hive.addChild(hive.bee1);
            hive.addChild(hive.bee2);
            hive.addChild(hive.bee3);
            hive.bee1.visible = false;
            hive.bee2.visible = false;
            hive.bee3.visible = false;
            hive.bee1.gotoAndStop(1);
            hive.bee2.gotoAndStop(1);
            hive.bee3.gotoAndStop(1);
        }
        
        public function set_scale(s:Number):void{
            scale = s;
            scaleX = (scaleY = s);
        }
        private function pollinate():void{
            if (!target.parent){
                pollination_failed = true;
                goBack(null);
                return;
            };
            dispatchEvent(new Event(ON_POLLINATE));
            swarm.x = ((swarm.x * scale) - target.x);
            swarm.y = ((swarm.y * scale) - target.y);
            target.land_bees(swarm);
            swarm.scaleX = (hive.is_flipped()) ? -(scale) : scale;
            swarm.scaleY = scale;
            target.addEventListener(target.PLANT_POLLINATED, goBack);
        }
        
        private function goBack(e:Event):void{
            var time:Number;
            swarm.scaleX = (hive.is_flipped()) ? -1 : 1;
            swarm.scaleY = 1;
            swarm.x = (_target.x / scale);
            swarm.y = (_target.y / scale);
            addChild(swarm);
            var points:Array = generate_zigzag(_target, hive);
            timeline = new TimelineMax({onComplete:makeHoney});
            var j:Number = 0;
            while (j < points.length) {
                if (j == 0){
                    time = (get_distance((target.x / scale), (target.y / scale), points[0].x, points[0].y) / 100);
                } else {
                    time = (get_distance(points[(j - 1)].x, points[(j - 1)].y, points[j].x, points[j].y) / 100);
                };
                timeline.append(new TweenMax(swarm, time, {
                    x:points[j].x,
                    y:points[j].y,
                    ease:Linear.easeNone,
                    onUpdate:check_position,
                    onUpdateParams:["in"]
                }));
                j++;
            };
        }
        
        private function beesAreOut(e:Event):void{
            var time:Number;
            var points:Array = generate_zigzag(hive, _target);
            var i:Number = 0;
            while (i < swarm.numChildren) {
                swarm.getChildAt(i).visible = true;
                i++;
            };
            timeline = new TimelineMax({onComplete:pollinate});
            var j:Number = 0;
            while (j < points.length) {
                if (j == 0){
                    time = (get_distance((hive.x / scale), (hive.y / scale), points[0].x, points[0].y) / 100);
                } else {
                    time = (get_distance(points[(j - 1)].x, points[(j - 1)].y, points[j].x, points[j].y) / 100);
                };
                timeline.append(new TweenMax(swarm, time, {
                    x:points[j].x,
                    y:points[j].y,
                    ease:Linear.easeNone,
                    onUpdate:check_position
                }));
                j++;
            };
        }
        
        private function makeHoney():void{
            oscillator.reset();
            return_tween = null;
            hive.addChild(hive.bee1);
            hive.addChild(hive.bee2);
            hive.addChild(hive.bee3);
            hive.bee1.visible = false;
            hive.bee2.visible = false;
            hive.bee3.visible = false;
            hive.bee1.gotoAndStop(1);
            hive.bee2.gotoAndStop(1);
            hive.bee3.gotoAndStop(1);
            parent.removeChild(this);
            hive.removeEventListener(hive.BEES_ARE_OUT, beesAreOut);
            hive.removeEventListener(hive.ON_CHANGE, hiveOnChange);
            if (pollination_failed){
                hive.goIn();
            } else {
                hive.make_honey();
            }
        }
        
        private function get_distance(x1:Number, y1:Number, x2:Number, y2:Number):Number{
            return (Algo.distance(x1, y1, x2, y2));
        }

    }
}
