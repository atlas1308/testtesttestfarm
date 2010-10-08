package classes.view.components.map {
    import classes.utils.*;
    import classes.utils.particles.*;
    
    import com.greensock.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;

    public class Plant extends CollectObject {

        public static const IRRIGATION_INSTALLED:String = "irrigationInstalled";

        public const PLANT_POLLINATED:String = "plantPollinated";

        private var soil:MovieClip;
        private var crop:Crop;
        private var blit_img:Bitmap;
        private var particles:Particles;
        private var pollinated:Boolean = false;// 是否..授粉了，对于小蜜蜂来说可以采蜜的
        private var fertilize_percent:Number = 0;
        private var fertilize_count:Number = 0;
        private var grown_percent:Number = 0;// 升长到多少了，比如成长到了10%还是等
        private var _marked:Boolean = false;
        private var grass_back:MovieClip;
        private var grass_front:MovieClip;
        private var bubbles:Bubbles;
        private var plant:Bitmap;
        private var swarm:Sprite;
        private var _current_collect_in:Number = 0;// 这个值暂时没有看到，可能还没有理解透

        public function Plant(data:Object){
            pollinated = (data.pollinated) ? true : false;
            _current_collect_in = (data.current_collect_in) ? data.current_collect_in : 0;
            grown_percent = (data.grown_percent) ? data.grown_percent : 0;
            super(data);
        }
        public function can_be_fertilized():Boolean{
            return ((((grown_percent + (fertilize_count * fertilize_percent)) + (time_passed() / current_collect_in)) < 1));
        }
        public function land_bees(swarm:Sprite):void{
            this.swarm = swarm;
            addChild(swarm);
            TweenLite.to(swarm, 2, {
                y:(swarm.y + (_height / 4)),
                onComplete:start_pollination_anim
            });
        }
        override protected function update_stage():void{
            if (!asset_loaded){
                return;
            };
            clear_asset();
            if (pollinated){
                plant = loader.get_bmp_by_frame(6);
            } else {
                plant = loader.get_bmp_by_frame(current_stage());
            };
            asset.addChild(grass_back);
            asset.addChild(soil);
            asset.addChild(plant);
            asset.addChild(grass_front);
            if (water_pipe){
                asset.addChild(water_pipe);
            };
        }
        override protected function refresh_asset():void{
            super.refresh_asset();
            if (bubbles){
                bubbles.scaleX = (bubbles.scaleY = (grid_size / 15));
            };
        }
        override protected function assetLoaded(e:Event):void{
            super.assetLoaded(e);
            plant = (loader.asset as Bitmap);
            update_stage();
        }
        override protected function init():void{
            super.init();
            crop = new Crop();
            soil = (water_pipe_id) ? crop.soil_wet : crop.soil_dry;
            grass_front = crop.grass_front;
            grass_back = crop.grass_back;
        }
        private function sparkle():void{
        }
        override public function greenhouse_removed():void{
            if (!_greenhouse){
                return;
            };
            stopTimer();
            grown_percent = (grown_percent + (time_passed() / current_collect_in));
            start_time = Algo.time();
            startTimer();
            _greenhouse = null;
        }
        override public function remove_irrigation():void{
            grown_percent = (grown_percent + (time_passed() / current_collect_in));
            super.remove_irrigation();
            stopTimer();
            start_time = Algo.time();
            startTimer();
            soil = crop.soil_dry;
            update_stage();
        }
        public function fertilize(p:Number):void{
            fertilize_count++;
            fertilize_percent = p;
            show_animation();
            setTimeout(apply_rain, 1000, p);
        }
        override public function install_irrigation(obj:Object):void{
            grown_percent = (grown_percent + (time_passed() / current_collect_in));
            super.install_irrigation(obj);
            stopTimer();
            start_time = Algo.time();
            startTimer();
            soil = crop.soil_wet;
            update_stage();
            dispatchEvent(new Event(IRRIGATION_INSTALLED));
        }
        override protected function current_stage():Number{
            var c:Number;
            if (!start_time){
                return (1);
            };
            var stage_percent:Number = (1 / (stages - 1));
            var r:Number = (product_percent(false) / stage_percent);
            if (int(r) == r){
                c = (r + 1);
            } else {
                c = r;
            };
            if (c < 1){
                c = 1;
            };
            var s:Number = int(Math.min(stages, Math.ceil(c)));
            return (s);
        }
        override public function greenhouse_added(g:Greenhouse):void{
            if (_current_collect_in){
                _current_collect_in = 0;
                _greenhouse = g;
                return;
            };
            grown_percent = (grown_percent + (time_passed() / current_collect_in));
            _greenhouse = g;
            stopTimer();
            start_time = Algo.time();
            startTimer();
        }
        public function show_animation():void{
            particles = new Particles(30, 1, 0, 0);
            particles.source_y = -40;
            particles.min_source_distance = 50;
            particles.max_source_distance = 70;
            particles.scaleX = (particles.scaleY = (grid_size / 15));
            addChild(particles);
            particles.start();
            setTimeout(sparkle, 1000);
        }
        override public function apply_rain(p:Number, is_rain:Boolean=false):void{
            if (((_greenhouse) && (is_rain))){
                return;
            };
            if (fertilize_count){
                fertilize_count--;
            };
            start_time = (start_time - (p * current_collect_in));
            update_stage();
        }
        override public function next_product_in():Number{
            return (((1 - product_percent(false)) * current_collect_in));
        }
        override public function next_stage_in():Number{
            if (!start_time){
                return (-1);
            };
            var stage_percent:Number = (1 / (stages - 1));
            var delta:Number = ((current_stage() * stage_percent) - product_percent(false));
            return ((delta * current_collect_in));
        }
        override public function is_ready():Boolean{
            if (start_time == 0){
                return (false);
            };
            return ((product_percent() == 100));
        }
        public function get_details():Object{
            var obj:Object = new Object();
            obj.start_time = start_time;
            obj.grown_percent = grown_percent;
            obj.current_collect_in = current_collect_in;
            obj.has_greenhouse = _greenhouse;
            return (obj);
        }
        override public function kill():void{
            if (swarm){
                TweenLite.killTweensOf(swarm);
                liftOff();
            };
            if (_greenhouse){
                _greenhouse.remove_plant(this);
            };
            super.kill();
        }
        private function liftOff():void{
            swarm = null;
            dispatchEvent(new Event(PLANT_POLLINATED));
        }
        public function mark_for_pollination():void{
            _marked = true;
        }
        public function is_pollinated():Boolean{
            return (pollinated);
        }
        private function get current_collect_in():Number{
            if (_current_collect_in){
                return (_current_collect_in);
            };
            var percent:Number = (water_pipe_id) ? water_pipe_growing_percent : 0;
            percent = (percent + (_greenhouse) ? _greenhouse.growing_percent : 0);
            var c:Number = (old_collect_in * (1 - percent));
            return (c);
        }
        
        override public function product_percent(value:Boolean=true):Number{
            var p:Number = Math.min(1, (grown_percent + (time_passed() / current_collect_in)));
            p = Math.max(0,p);
            if (value){
                return (int((100 * p)));
            }
            return p;
        }
        private function start_pollination_anim(lift_off:Boolean=true):void{
            pollinated = true;
            update_stage();
            if (lift_off){
                TweenLite.to(swarm, 2, {
                    y:(swarm.y - (_height / 4)),
                    onComplete:liftOff
                });
            };
        }
        public function is_marked_for_pollination():Boolean{
            return (_marked);
        }

    }
}
