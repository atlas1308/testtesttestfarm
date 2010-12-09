package classes.utils {
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;
	/**
	 * 所有动物的播放器
	 */ 
    public class TimelinePlayer extends EventDispatcher {

        public static const FINISH:String = "finish";
        public static const CURRENT_FRAME:Number = 0x0400;// 1024

        public var log:Boolean = false;
        private var interval:Number;
        private var range_started:Boolean = false;
        private var timer:Timer;
        private var range_count:Number = 0;
        private var queue:Array;// 存帧的数组
        public var mc:MovieClip;
        private var mcs:Array;
        private var fps:Number = 20;
        private var frame:Number = 1;
        private var loop_count:Number = 0;
        private var dispatch_finish:Boolean = true;
        private var _is_playing:Boolean = false;

        public function TimelinePlayer(mc:MovieClip=null){
            super();
            mcs = new Array();
            if (mc){
                mcs.push(mc);
            }
            this.mc = mc;
            queue = new Array();
            timer = new Timer((1000 / fps));
            timer.addEventListener(TimerEvent.TIMER, loop);
        }
        public function stop(dispatch:Boolean=true):void{
            if (!mc){
                return;
            }
            _is_playing = false;
            loop_count = 0;
            range_count = 0;
            range_started = false;
            queue = new Array();
            frame = 1;
            timer.stop();
            clearTimeout(interval);
            if (((dispatch_finish) && (dispatch))){
                dispatchEvent(new Event(FINISH));
            }
        }
        private function get end_frame():int{
            var frame:uint;
            if (range){
                frame = range[1];// 取数据里第2个元素
            } else {
                frame = queue[0][range_count];
            }
            if (frame == CURRENT_FRAME){
                frame = mc.currentFrame;
            }
            return (frame);
        }
        
        private function get start_frame():int{
            var frame:uint;
            if (range){
                frame = range[0];
            } else {
                if (queue[0].length <= range_count){
                    if (queue.length == 1){
                        return (0);
                    };
                    queue.shift();
                    range_count = 0;
                    loop_count = 0;
                    return (start_frame);
                }
                frame = queue[0][range_count];
            }
            if (frame == CURRENT_FRAME){
                frame = mc.currentFrame;
            }
            return frame;
        }
        
        public function set_mc(... _args):void{
            if (_args.length == 0){
                return;
            };
            mcs = _args;
            this.mc = (_args[0] as MovieClip);
            if (_is_playing){
                start();
            }
        }
        
        public function set_fps(fps:Number):void{
            if (timer.running){
                timer.stop();
                timer.delay = (1000 / fps);
                timer.start();
            } else {
                timer.delay = (1000 / fps);
            }
        }
        
        private function next_range_frame():int{
            range_started = true;
            loop_count = 0;
            range_count++;
            if (queue[0].length <= range_count){
                queue.shift();
                if (queue.length == 0){
                    stop();
                    return (mc.currentFrame);
                };
                range_count = 0;
                loop_count = 0;
            }
            return start_frame;
        }
        
        public function is_playing():Boolean{
            return (_is_playing);
        }
        //[[54, 62], -1000, [61, 54]];
        private function loop(e:TimerEvent):void{
            if (!mc){
                return (stop());
            }
            if (queue.length == 0){
                return (stop());
            }
            if (!start_frame){
                return (stop());
            };
            if (range){
                if (!range_started){
                    frame = start_frame;
                    range_started = true;
                    loop_count = 0;
                } else {
                    if (frame == end_frame){
                        if (range_loop > loop_count){
                            frame = start_frame;
                            loop_count++;
                        } else {
                            frame = next_range_frame();
                        };
                    } else {
                    	var checkFrame:int = start_frame < end_frame ? 1 : -1;
                        frame += checkFrame;
                    };
                };
            } else {
                frame = start_frame;
                range_count++;
                range_started = false;
            };
            if (frame < 0){
                if (start_frame < 0){
                    range_count++;
                    range_started = false;
                };
                timer.stop();
                interval = setTimeout(start, -(frame));
                return;
            }
            var i:Number = 0;
            while (i < mcs.length) {
                MovieClip(mcs[i]).gotoAndStop(frame);
                i++;
            }
        }
        private function get range_loop():int{
            if (((range) && ((range.length == 3)))){
                return (range[2]);
            };
            return (0);
        }
        
        private function start():void{
            if (!mc){
                return;
            }
            timer.start();
        }
        
        /**
         * 这里的默认的值应该是-1,也就是第一帧
         * [[2,19]][[54, 62], -1000, [61, 54]];
         */ 
        public function play(frames:Array, dispatch_finish:Boolean=true, delay:Number=1):void{
            var _frms:Array = (Algo.clone(frames) as Array);
            this.dispatch_finish = dispatch_finish;
            if (dispatch_finish){
                _frms.unshift(-(delay));
            }
            queue.push(_frms);
            if (!_is_playing){
                start();
                _is_playing = true;
            }
        }
        
        private function get range():Array{
            return ((queue[0][range_count] as Array));
        }

    }
}
