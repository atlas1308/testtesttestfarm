package classes.view.components.map {
    import flash.events.*;
    import classes.utils.*;
    import flash.geom.*;
    import flash.display.*;
    import flash.utils.*;
	
	/**
	 * ID返回的不正确,导致productName不正确
	 * raw_material' => array (
            0 => array (
                0 => 18,
            ),
            1 => 21,
            2 => 17,
        ),
        * 
        注意返回的结构,顺序不能有变化 
        raw_materials' => array (
            0 => array (
                0 => 18,
            ),
            1 => 21,
            2 => 17,
        ),
        这里的顺序要注意,要保持一样
        * 
       
       * 物品收获和添加的整个流程
       * 先refill_object,就是先添加原料
       		添加原料有以下几个验证:
       		 * storage里是否存在添加的原料
       		 * 当前的机器里原料是否已经到达最大值
       		 * 在添加之前,是否有东西可以产生,如果有物品可以产生的话,那么时间不必计算
       		 * 如果没有物品产生,那添加这个原料之后再计算是不中
	 */ 
    public class MultiProcessor extends CollectObject implements IProcessor {

        public static const AUTO_COLLECT:String = "autoCollect";
        public static const AUTO_REFILL:String = "autoRefill";

        protected var selected_raw_material:Number = 1;
        protected var extra_hit_area_rectangle:Rectangle;
        protected var raw_materials_queue:Array;
        protected var raw_material_names:Array;
        protected var max_raw_materials:Number = 3;
        protected var last_product:Number;
        protected var is_updating:Boolean = false;
        protected var raw_materials:Array;
        protected var raw_material:Array;
        protected var max_products:Number = 3;
        protected var products:Array;
        protected var product:Array;
        protected var product_names:Array;
        protected var automation_checked:Boolean = false;

        public function MultiProcessor(data:Object){
            raw_material = (data.raw_material as Array);// 原料
            product = (data.product as Array);// 产物
            product_names = data.product_names;
            raw_material_names = data.raw_material_names;//原料名称
            raw_materials = ((data.raw_materials as Array)) ? data.raw_materials : new Array();// 当前存在的原料的列表
            products = ((data.products as Array)) ? data.products : new Array();
            selected_raw_material = (data.selected_raw_material) ? data.selected_raw_material : 0;// 当前选中的原料
            var i:Number = 0;
            while (i < raw_material.length) {
                if (!(raw_materials[i] as Array)){
                    raw_materials[i] = new Array();
                }
                i++;
            }
            raw_materials_queue = new Array();
            super(data);
        }
        
        override public function kill():void{
            clearTimeout(auto_collect_interval);
            super.kill();
        }
        
        override protected function init_asset():void{
            super.init_asset();
            refresh_hit_area();
        }
        
        override protected function startTimer():void{
            super.startTimer();
            if (next_stage_in() > 0){
                start_anim();
            }
        }
        
        override protected function queue_highlight():void{
            if (!mc){
                return;
            };
            var p:MovieClip = mc.product;
            if (((process_count["collect"]) && (products.length))){
                if (process_count["collect"] >= 1){
                    Effects.green(p[("product" + products.length)]);
                };
                if ((((process_count["collect"] >= 2)) && ((products.length > 1)))){
                    Effects.green(p[("product" + (products.length - 1))]);
                };
                if ((((process_count["collect"] >= 3)) && ((products.length > 2)))){
                    Effects.green(p[("product" + (products.length - 2))]);
                };
                state_cont.visible = false;
            };
            var i:Number = 0;
            while (i < raw_material.length) {
                queue_highlight_by_raw_material(i);
                i++;
            }
        }
        
        override protected function update_stage():void{
            if (!enabled){
                return;
            }
            update_raw_material_area();
            update_product_area();
            update_switch_area();
        }
        
        protected function get collect_area():MovieClip{
            if (!mc){
                return null;
            }
            return (mc.product);
        }
        
        protected function get_used_raw_material_index():Number{
            var i:Number = 0;
            while (i < raw_material[0].length) {
                if (raw_material[0][i] == raw_materials[0][0]){
                    return (i);
                };
                i++;
            }
            return 0;
        }
        
        override public function end_process(channel:String):void{
            if (channel == "feed1"){
                raw_materials_queue.shift();
            };
            super.end_process(channel);
        }
        
        protected function get_refill_area(index:Number):MovieClip{
            if (!mc){
                return (null);
            }
            if (!mc[("refill_area" + index)]){
                return (null);
            }
            return (mc[("refill_area" + index)]);
        }
        
        protected function disabled_state():void{
        }
        
        override protected function init():void{
            check_products();
            super.init();
            loader.cache_swf = true;
            process_count["feed1"] = 0;
            process_count["feed2"] = 0;
            process_count["feed3"] = 0;
            process_count["collect"] = 0;
        }
        
        override public function set enabled(v:Boolean):void{
            super.enabled = v;
            if (mc){
                if (!v){
                    disabled_state();
                } else {
                    update_stage();
                };
            };
        }
        
        protected function update_product_area():void{
            var p:MovieClip;
            if (mc){
                p = mc.product;
                p.product1.visible = false;
                p.product2.visible = false;
                p.product3.visible = false;
                if (products.length >= 1){
                    p.product1.visible = true;
                    p.product1.gotoAndStop(get_product_frame(0));
                    Effects.clear(p.product1);
                }
                if (products.length >= 2){
                    p.product2.visible = true;
                    p.product2.gotoAndStop(get_product_frame(1));
                    Effects.clear(p.product2);
                }
                if (products.length >= 3){
                    p.product3.visible = true;
                    p.product3.gotoAndStop(get_product_frame(2));
                    Effects.clear(p.product3);
                }
                queue_highlight();
            }
        }
        
        protected function update_raw_material(index:Number):void{
            var c:Number;
            if (!mc){
                return;
            }
            var r:MovieClip = mc[("raw_material" + (index + 1))];
            if ((raw_materials[index] as Array)){
                c = raw_materials[index].length;
            } else {
                c = 0;
            }
            r.material1.visible = false;
            r.material2.visible = false;
            r.material3.visible = false;
            if (c >= 1){
                r.material1.visible = true;
                r.material1.gotoAndStop(get_raw_material_frame(index, 0));
                Effects.clear(r.material1);
            }
            if (c >= 2){
                r.material2.visible = true;
                r.material2.gotoAndStop(get_raw_material_frame(index, 1));
                Effects.clear(r.material2);
            }
            if (c >= 3){
                r.material3.visible = true;
                r.material3.gotoAndStop(get_raw_material_frame(index, 2));
                Effects.clear(r.material3);
            }
            queue_highlight();
        }
        
        override protected function assetLoaded(e:Event):void{
            super.assetLoaded(e);
            check_automation("on_load");
        }
        
        override protected function get mc():MovieClip{
            if (under_construction){
                return null;
            }
            return super.mc;
        }
        
        public function switch_over():Boolean{
            var clickPoint:Point;
            var p:Point;
            if (switch_hit_area){
                clickPoint = new Point(switch_hit_area.mouseX, switch_hit_area.mouseY);
                p = switch_hit_area.localToGlobal(clickPoint);
                return (switch_hit_area.hitTestPoint(p.x, p.y, true));
            }
            return false;
        }
        
        public function highlight_automation_areas(color:Number):void{
            if (collect_area){
                Effects.glow(collect_area, color);
            };
            var i:Number = 1;
            while (i <= raw_material.length) {
                if (get_refill_area(i)){
                    Effects.glow(get_refill_area(i), color, false);
                };
                i++;
            }
        }
        
        public function set_raw_material(index:Number):void{
        	if(selected_raw_material != index){
	            selected_raw_material = index;
	            if(this.is_automatic()){// 如果是自动化,才自动开启
	            	dispatchEvent(new Event(AUTO_REFILL));
	            }
	            update_stage();
            }
        }
        
        protected function queue_highlight_by_raw_material(i:Number):void{
            if (!mc){
                return;
            }
            var c:Number = 0;
            if (!mc[("raw_material" + (i + 1))]){
                return;
            }
            var r:MovieClip = mc[("raw_material" + (i + 1))];
            if ((raw_materials[i] as Array)){
                c = raw_materials[i].length;
            };
            if (process_count[("feed" + (i + 1))]){
                if ((((process_count[("feed" + (i + 1))] >= 1)) && ((c < 3)))){
                    r[("material" + (c + 1))].visible = true;
                    r[("material" + (c + 1))].gotoAndStop(get_raw_material_frame(i, raw_materials_queue[0], false));
                    Effects.green(r[("material" + (c + 1))]);
                };
                if ((((process_count[("feed" + (i + 1))] >= 2)) && ((c < 2)))){
                    r[("material" + (c + 2))].visible = true;
                    r[("material" + (c + 2))].gotoAndStop(get_raw_material_frame(i, raw_materials_queue[1], false));
                    Effects.green(r[("material" + (c + 2))]);
                };
                if ((((process_count[("feed" + (i + 1))] >= 3)) && ((c < 1)))){
                    r[("material" + (c + 3))].visible = true;
                    r[("material" + (c + 3))].gotoAndStop(get_raw_material_frame(i, raw_materials_queue[2], false));
                    Effects.green(r[("material" + (c + 3))]);
                };
                state_cont.visible = false;
            };
        }
        
        override protected function refresh_hit_area():void{
            super.refresh_hit_area();
            if (((mc) && (mc.extra_hit_area))){
                if (!extra_hit_area_rectangle){
                    extra_hit_area_rectangle = mc.extra_hit_area.getBounds(mc);
                    addChild(mc.extra_hit_area);
                };
                mc.extra_hit_area.x = (extra_hit_area_rectangle.x * asset.scaleY);
                mc.extra_hit_area.y = (extra_hit_area_rectangle.y * asset.scaleY);
                mc.extra_hit_area.scaleX = asset.scaleX;
                mc.extra_hit_area.scaleY = asset.scaleY;
                if (is_flipped()){
                    mc.extra_hit_area.x = (-(extra_hit_area_rectangle.x) * asset.scaleY);
                };
            };
        }
        
        override public function preload_position(channel:String):Object{
            var pos:Object = super.preload_position(channel);
            switch (channel){
                case "feed1":
                    pos = get_refill_position(1);
                    break;
                case "feed2":
                    pos = get_refill_position(2);
                    break;
                case "feed3":
                    pos = get_refill_position(3);
                    break;
                case "collect":
                    if (mc){
                        pos.x = (pos.x + (collect_area.getBounds(this).left + (collect_area.getBounds(this).width / 2)));
                        pos.y = (pos.y + collect_area.getBounds(this).top);
                    };
                    break;
            }
            return pos;
        }
        
        private function convert_raw_material_to_product():void{
            var id:Number;
            var i:Number = 0;
            while (i < raw_material.length) {
                id = raw_materials[i].shift();
                if (i == 0){
                    products.push(get_product_by_raw_material(id));
                }
                i++;
            }
        }
        
        public function highlight_refill(index:Number):void{
            clear_highlight();
            var refill_area:MovieClip = get_refill_area(index);
            if (refill_area){
                Effects.glow(refill_area);
            };
        }
        override public function is_ready():Boolean{
            return ((products.length > 0));
        }
        
        public function get_raw_material_name(index:Number):String{
            return (raw_material_names[get_raw_material_id(index)]);
        }
        
        private function get_product_by_raw_material(id:Number):Number{
            var i:Number = 0;
            while (i < raw_material[0].length) {
                if (raw_material[0][i] == id){
                    return (product[i]);
                }
                i++;
            }
            return 0;
        }
        
        public function highlight_switch():void{
            clear_highlight();
            if (switch_area){
                Effects.glow(switch_area);
            }
        }
        
        /**
         * 获取可以产生多少个产生物 
         */ 
        private function num_complete_raw_materials():Number{
            var c:Number = 100;
            var i:Number = 0;
            while (i < raw_material.length) {
                if (!(raw_materials[i] as Array)){
                    return (0);
                };
                if (c > raw_materials[i].length){
                    c = raw_materials[i].length;
                };
                i++;
            };
            if (c == 100){
                return (0);
            }
            return c;
        }
        
        protected function get_refill_position(index:Number):Object{
            var p:Object = super.preload_position("");
            var area:MovieClip = get_refill_area(index);
            if (!area){
                return (p);
            };
            p.x = (p.x + (area.getBounds(this).left + (area.getBounds(this).width / 2)));
            p.y = (p.y + area.getBounds(this).top);
            return p;
        }
        
        public function get_raw_materials(index:Number):Number{
            return (raw_materials[(index - 1)].length);
        }
        
        public function get_products():Number{
            return (products.length);
        }
        
        public function refill_with(index:Number):void{
            if (raw_materials[(index - 1)].length == max_raw_materials){
                return;
            }
            raw_materials[(index - 1)].push(get_raw_material_id(index));
            if (!is_working){
                produce();
                if (_automatic){
                    automation_checked = false;
                }
            } else {
                update_stage();
            }
        }
        
        /**
         * 收获的操作 
         */ 
        public function collect():void{
            if (products.length < 1){
                return;
            }
            last_product = products.pop();
            if ((((num_complete_raw_materials() > 0)) && (!(is_working)))){
                produce();
            } else {
                update_stage();
            }
        }
        
        protected function get collect_hit_area():MovieClip{
            if (!mc){
                return (null);
            }
            return (mc.collect_hit_area);
        }
        
        /**
         * 获取需要的原料 
         */ 
        public function get_needed_raw_materials():Array{
            var names:Array = new Array();
            var i:Number = 0;
            while (i < raw_material.length) {
                if (raw_materials[i].length == 0){
                    names.push(get_raw_material_name((i + 1)));
                }
                i++;
            }
            return names;
        }
        
        public function highlight_collect():void{
            clear_highlight();
            if (collect_area){
                Effects.glow(collect_area);
            };
        }
        
        protected function get switch_area():MovieClip{
            if (!mc){
                return (null);
            };
            return (mc.switch_area);
        }
        
        protected function get_refill_hit_area(index:Number):MovieClip{
            if (!mc){
                return (null);
            }
            if (!mc[("refill_hit_area" + index)]){
                return (null);
            }
            return (mc[("refill_hit_area" + index)]);
        }
        
        /**
         * 检测生产出来的物品 
         */ 
        protected function check_products():void{
            if (!start_time){
                return;
            }
            var materials:Number = num_complete_raw_materials();
            var n:Number = Math.min((max_products - products.length), Math.min(materials, Math.floor(((Algo.time() - start_time) / collect_in))));
            if (n < 0){
                n = 0;
            }
            start_time = (start_time + (n * collect_in));
            var i:Number = 0;
            while (i < n) {
                convert_raw_material_to_product();
                i++;
            };
            var new_m:Number = num_complete_raw_materials();
            if ((((new_m == 0)) || ((products.length == max_products)))){
                start_time = 0;
            } else {
                is_working = (((new_m > 0)) && ((products.length < max_products)));
            };
        }
        
        public function refill_over(index:Number):Boolean{
            var clickPoint:Point;
            var p:Point;
            var refill_area:MovieClip = get_refill_hit_area(index);
            if (refill_area){
                clickPoint = new Point(refill_area.mouseX, refill_area.mouseY);
                p = refill_area.localToGlobal(clickPoint);
                return (refill_area.hitTestPoint(p.x, p.y, true));
            }
            return (false);
        }
        
        protected function dispatch_auto_collect():void{
            dispatchEvent(new Event(AUTO_COLLECT));
        }
        
        public function can_refill_with(index:Number):Boolean{
            return (((raw_materials[(index - 1)].length + process_count[("feed" + index)]) < max_raw_materials));
        }
        
        protected function update_switch_area():void{
            if (!switch_area){
                return;
            }
            switch_area.gotoAndStop(get_product_frame(get_product_by_raw_material(get_raw_material_id(1)), false));
        }
        
        override public function wait_to_process(channel:String):void{
            if (channel == "feed1"){
                raw_materials_queue.push(get_raw_material_id(1));
            }
            super.wait_to_process(channel);
        }
        
        public function collect_over():Boolean{
            var clickPoint:Point;
            var p:Point;
            if (collect_hit_area){
                clickPoint = new Point(collect_hit_area.mouseX, collect_hit_area.mouseY);
                p = collect_hit_area.localToGlobal(clickPoint);
                return (collect_hit_area.hitTestPoint(p.x, p.y, true));
            };
            return (false);
        }
        
        public function get_raw_material_id(index:Number):Number{
            if (index == 1){
                if (!(raw_material[0] as Array)){
                    return (raw_material[0]);
                }
                return raw_material[0][selected_raw_material];
            }
            return raw_material[(index - 1)];
        }
        
        override public function turn_on_automation():void{
            automation_checked = false;
            super.turn_on_automation();
            check_automation("turn_on");
        }
        
        override public function update(data:Object):void{
            is_updating = true;
            if ((((num_complete_raw_materials() > 0)) && ((products.length < max_products)))){
                stopTimer();
                start_time = data.start_time;
                check_products();
                startTimer();
                update_stage();
            };
            is_updating = false;
        }
        
        public function clear_highlight():void{
            var refill_area:*;
            if (switch_area){
                Effects.clear(switch_area);
            };
            if (collect_area){
                Effects.clear(collect_area);
            };
            var i:Number = 0;
            while (i < raw_material.length) {
                refill_area = get_refill_area((i + 1));
                if (refill_area){
                    Effects.clear(refill_area);
                };
                i++;
            };
        }
        
        private function has_all_raw_materials():Boolean{
            var i:Number = 0;
            while (i < raw_material.length) {
                if (!(raw_materials[i] as Array)){
                    return (false);
                };
                if (raw_materials[i].length == 0){
                    return (false);
                };
                i++;
            };
            return (true);
        }
        
        public function can_collect():Boolean{
            return (((products.length - process_count["collect"]) > 0));
        }
        
        protected function update_raw_material_area():void{
            var i:Number;
            if (mc){
                i = 0;
                while (i < raw_material.length) {
                    update_raw_material(i);
                    i++;
                }
            }
        }
        
        public function get_selected_raw_material():Number{
            return selected_raw_material;
        }
        
        override public function product_name():String{
            var id:Number;
            if (is_working){
                id = raw_materials[0][0];
            } else {
                id = get_raw_material_id(1);
            }
            return (product_names[get_product_by_raw_material(id)]);
        }
        
        private function get_raw_material_frame(r:Number, index:Number, is_index:Boolean=true):Number{
            if (!(raw_material[r] as Array)){
                return 1;
            }
            if (!(raw_materials[r] as Array)){
                return 1;
            }
            if (((is_index) && ((index >= raw_materials[r].length)))){
                return 1;
            }
            var id:Number = (is_index) ? raw_materials[r][index] : index;
            var i:Number = 0;
            while (i < raw_material[r].length) {
                if (raw_material[r][i] == id){
                    return ((i + 1));
                }
                i++;
            }
            return 1;
        }
        
        protected function produce():void{
            if (((has_all_raw_materials()) && ((products.length < max_products)))){// 是否可以生产
                start_time = Algo.time();
                startTimer();
            };
            update_stage();
        }
        
        public function num_raw_materials():Number{
            return (raw_material.length);
        }
        protected function start_anim():void{
        }
        public function check_automation(mode:String):void{
            var i:Number;
            if (!_automatic){
                return;
            };
            if (is_under_construction()){
                return;
            };
            if ((((mode == "on_collect")) && (automation_checked))){
                return;
            };
            i = 0;
            while (i < products.length) {
                dispatch_auto_collect();
                i++;
            };
            if (next_product_in() > 0){
                return;
            }
            var min:Number = 3;
            i = 0;
            while (i < raw_material.length) {
                if (raw_materials[i].length < min){
                    min = raw_materials[i].length;
                };
                i++;
            }
            i = 0;
            while (i < (2 - min)) {
                dispatchEvent(new Event(AUTO_REFILL));
                i++;
            };
            if (min > 1){
                automation_checked = true;
            }
        }
        
        override protected function on_product_complete():void{
            super.on_product_complete();
            convert_raw_material_to_product();
            if (_automatic){
                dispatchEvent(new Event(AUTO_REFILL));
                auto_collect_interval = setTimeout(dispatch_auto_collect, 1000);
                automation_checked = false;
            };
            produce();
        }
        
        protected function get switch_hit_area():MovieClip{
            if (!mc){
                return (null);
            }
            return (mc.switch_hit_area);
        }
        
        override public function flip(animationable:Boolean = false):void{
            super.flip();
            refresh_hit_area();
        }
        
        public function product_collected():Number{
            return (last_product);
        }
        
        protected function get_product_frame(index:Number, is_index:Boolean=true):Number{
            if (((is_index) && ((index >= products.length)))){
                return (0);
            };
            var id:Number = (is_index) ? products[index] : index;
            var i:Number = 0;
            while (i < product.length) {
                if (product[i] == id){
                    return ((i + 1));
                };
                i++;
            };
            return (0);
        }
        
        override public function clear_process(channel:String):void{
            if (channel == "feed1"){
                raw_materials_queue.shift();
            };
            update_raw_material_area();
        }

    }
}
