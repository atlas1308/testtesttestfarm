package classes.view.components.map {
    import classes.utils.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;
	
	/**
	 * 这里时间的计算可能会因为时区的问题计算出错,这个线上在看吧
	 * 
	 * 我发现作物都明第6帧的,就是灰黑的一个东西,应该是开启on off的时候会出现的
	 */ 
    public class CollectObject extends MapObject {

        protected var start_time:Number;
        protected var toggler:Sprite;
        protected var is_working:Boolean = false;// 一个标记,标识是否正在工作
        protected var _automatic:Boolean = false;
        protected var _product_name:String;
        protected var stages:Number;
        protected var interval:Number;
        protected var auto_collect_interval:Number;
        
        protected var collect_in:Number;
        protected var old_collect_in:Number;
        
        protected var _toggler_on:SimpleButton;
        protected var _toggler_off:SimpleButton;
		
        public function CollectObject(data:Object){
            collect_in = Number(data.collect_in);// 收集的时间,以秒为单位
            start_time = (data.start_time) ? data.start_time : 0;// 开始种植的时间
            stages = (data.stages) ? data.stages : 1;// 5个阶段
            _product_name = (data.product_name) ? data.product_name : "";// 收获产物的名称
            old_collect_in = collect_in;// 收获的时间
            _automatic = PHPUtil.toBoolean(data.automatic);// 是否自动收获
            super(data);
        }
        
        protected function startTimer():void{
            if (next_stage_in() > 0){
                is_working = true;
                var next:Number = next_stage_in();
                interval = setTimeout(check_stage, (next * 1000));// 这种方法做,还是可行的,感觉比timer会更好一些的
            }
        }
        
        protected function check_stage():void{
            clearTimeout(interval);
            update_stage();
            if (current_stage() < stages){
                startTimer();
            } else {
                on_product_complete();
            }
        }
        
        /**
         * 也会更新一些显示资源
         */ 
        protected function update_stage():void{
            if (!bmp){
                return;
            }
            clear_asset();
            asset.addChild(loader.get_bmp_by_frame(current_stage()));
        }
        
        public function get toggler_on():SimpleButton{
        	if(!_toggler_on){
        		_toggler_on = new AutomationOn();
            	_toggler_on.name = "toggler_on";
            	_toggler_on.visible = false;
            	toggler.addChild(_toggler_on);
        	}
        	return _toggler_on;
        }
        
        public function get toggler_off():SimpleButton{
        	if(!_toggler_off){
        		_toggler_off = new AutomationOff();
            	_toggler_off.name = "toggler_off";
            	_toggler_off.visible = false;
            	toggler.addChild(_toggler_off);
        	}
        	return _toggler_off;
        }
        /**
         * 初始化 
         */ 
        override protected function init():void{
            super.init();
            startTimer();
            toggler = new Sprite();
            toggler.mouseChildren = false;
            toggler.mouseEnabled = false;
            addChild(toggler);
            /* toggler_on = new AutomationOn();
            toggler_on.name = "toggler_on";
            toggler_off = new AutomationOff();
            toggler_off.name = "toggler_off";
            toggler_on.visible = false; 
            toggler_off.visible = false;
            toggler.addChild(toggler_on); 
            toggler.addChild(toggler_off); */
        }
        
        public function getChildByNameTemp(name:String):DisplayObject {
        	return toggler.getChildByName(name);
        }
        
        override protected function assetLoaded(e:Event):void{
            super.assetLoaded(e);
            update_stage();
        }
        
        public function hide_toggler():void{
            toggler_on.visible = false;
            toggler_off.visible = false;
        }
        
        protected function time_passed():Number{
            return (Algo.time() - start_time);
        }
        
        override public function set grid_size(v:Number):void{
            super.grid_size = v;
            toggler.scaleX = (toggler.scaleY = ((0.75 * v) / 15));
            toggler.x = get_x((size_x / 2), (size_y / 2));
            toggler.y = get_y((size_x / 2), (size_y / 2));
        }
        
        public function turn_on_automation():void{
            _automatic = true;
            show_toggler();
        }
        
        /**
         * 计算当前的状态 
         * 如果有开始时间,那么就是第一阶段
         * 计算经过了多少个阶段
         * 然后再根据阶段去计算比例
         */ 
        protected function current_stage():Number{
            var c:Number;
            if (!start_time){
                return 1;
            }
            var r:Number = (time_passed() / stage_time());
            if (int(r) == r){
                c = (r + 1);
            } else {
                c = r;
            }
            if (c < 1){
                c = 1;
            }
            return (int(Math.min(stages, Math.ceil(c))));
        }
        
        /**
         * 下一个产物产生的时间
         * start_time + collect_in - 当前的时间 
         */ 
        public function next_product_in():Number{
        	var next:Number = Math.max(0, ((start_time + collect_in) - Algo.time()));
            return next;
        }
        
        override public function update(data:Object):void{
            stopTimer();
            start_time = data.start_time;
            startTimer();
            update_stage();
        }
        
        public function apply_rain(p:Number, is_rain:Boolean=false):void{
        }
        
        public function next_stage_in():Number{
            return ((current_stage() * stage_time()) - time_passed());
        }
        
        public function is_ready():Boolean{
            if (start_time == 0){
                return false;
            }
            return (Algo.time() > (start_time + collect_in));
        }
        
        /**
         * 自动收获 
         */ 
        public function is_automatic():Boolean{
            return _automatic;
        }
        
        /**
         * 在自动给用户设置自动化的时候会调用到 
         */ 
        public function set automatic(value:Boolean):void {
        	this._automatic = value;// 调用这个方法,不显示按纽,直接设置这个值
        }
        
        /**
         * 产物,这个属性需要翻译 
         */ 
        public function product_name():String{
            return _product_name;
        }
        
        public function show_toggler():void{
            toggler_on.visible = _automatic;
            toggler_off.visible = !(_automatic);
        }
        
        override public function kill():void{
            stopTimer();
            super.kill();
        }
        
        public function toggler_normal_mode():void{
            toggler.mouseEnabled = false;
            toggler.mouseChildren = false;
        }
        
        public function start():void{
            if (start_time == 0){
                start_time = Algo.time();
            }
            startTimer();
        }
        
        protected function stopTimer():void{
            clearTimeout(interval);
            is_working = false;
        }
        
        public function turn_off_automation():void{
            _automatic = false;
            show_toggler();
        }
        
        public function toggler_over():Boolean{
            var clickPoint:Point = new Point(toggler.mouseX, toggler.mouseY);
            var p:Point = toggler.localToGlobal(clickPoint);
            return toggler.hitTestPoint(p.x, p.y, true);
        }
        
        /**
         * 计算作物或者动物的每成长阶段消耗的时间 
         */ 
        protected function stage_time():Number{
            if (stages == 1){
                return collect_in;// 这里不知道为什么,算出来的值会有问题呢?
            }
            return ((collect_in / (stages - 1)));
        }
        
        public function toggler_button_mode():void{
            toggler.mouseEnabled = true;
            toggler.mouseChildren = true;
        }
        
        protected function on_product_complete():void{
            is_working = false;
        }
        
        public function product_percent(value:Boolean=true):Number{
            var p:Number = (collect_in - next_product_in()) / collect_in;// 计算生长的进度 收获时的总时间 - 下一次产出的时间 / 收获时间,即为当前进度
            p = Math.max(0,p);// 这里最好不要有负数,这样子的话,能保证显示正确,如果显示有负数,给人的效果不是非常好
            if (value){
                return int(100 * p);
            }
            return (p);
        }
    }
}
