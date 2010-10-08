package classes.utils.particles {
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;

    public class Particles extends Sprite {

        private var container:Sprite;
        private var delay:Number;
        private var timer:Timer;
        public var source_y:Number = 0;
        private var amount:Number;
        private var repeat_count:Number;
        public var min_source_distance:Number;
        private var x_span:Number;
        private var type:Number;
        public var max_source_distance:Number;

        public function Particles(amount:Number=28, type:Number=0, repeat_count:Number=0, x_span:Number=100, delay:Number=300){
            super();
            this.amount = amount;
            this.type = type;
            this.repeat_count = repeat_count;
            this.x_span = x_span;
            this.delay = delay;
            init();
        }
        private function init():void{
            container = new Sprite();
            addChild(container);
            timer = new Timer(delay, repeat_count);
            addEventListener(Event.ADDED_TO_STAGE, addedToStage);
            timer.addEventListener(TimerEvent.TIMER, onTimer);
        }
        private function mouseMove(e:MouseEvent):void{
            generate();
        }
        public function start():void{
            generate();
            if (repeat_count){
                timer.start();
            };
        }
        private function addedToStage(e:Event):void{
        }
        private function onTimer(e:TimerEvent):void{
            generate();
        }
        public function generate():void{
            var particle:Particle;
            var i:Number = 0;
            while (i < amount) {
                switch (type){
                    case 4:
                        particle = new StarParticle();
                        break;
                    case 3:
                        particle = new WaterParticle();
                        break;
                    case 1:
                        particle = new SoilParticle();
                        break;
                    case 2:
                        particle = new PollenParticle();
                        break;
                    default:
                        particle = new SparkleParticle();
                };
                container.addChild(particle);
                particle.source_y = source_y;
                particle.min_source_distance = min_source_distance;
                particle.max_source_distance = max_source_distance;
                particle.span_x = x_span;
                particle.start();
                i++;
            };
        }

    }
}
