package classes.view.components.map
{
    import classes.utils.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;

    public class Processor extends CollectObject implements IProcessor
    {
        protected var updated_start_time:Number = 0;
        protected var food_mc:String;// 食物的mc里的实例名
        protected var _hit_area:Sprite;// 点击的区域
        protected var max_animals:Number = 3;// 最大的animails,这个值是写在store里面的
        protected var max_raw_materials:Number = 3;
        protected var _raw_material_name:String;// 原料的名称也是写在store时面的
        protected var is_updating:Boolean = false;
        protected var raw_materials:Number;// 数据库存储的东西
        protected var raw_material:Number;// 原料的id
        protected var max_products:Number = 3;
        protected var products:Number;// 产的数量
        protected var product_mc:String;// mc的实例名,具体是写在movieClip里的,在外部的swf里
        protected var animals:Number = 1;
        protected var automation_checked:Boolean = false;
        public static const AUTO_COLLECT:String = "autoCollect";
        public static const AUTO_REFILL:String = "autoRefill";

        public function Processor(value:Object)
        {
            raw_material = value.raw_material ? (value.raw_material) : (0);
            raw_materials = value.raw_materials ? (value.raw_materials) : (0);
            products = value.products ? (value.products) : (0);// 产生物
            animals = value.animals ? (value.animals) : (1);// 动物,默认的是1
            max_animals = value.max_animals ? (value.max_animals) : (3);
            _raw_material_name = value.raw_material_name ? (value.raw_material_name) : ("");
            _automatic = true;// 自动收获
            super(value);
        }

        override protected function init_asset() : void
        {
            super.init_asset();
            refresh_hit_area();
        }

        protected function get collect_area() : MovieClip
        {
            return null;
        }

        public function addAnimal() : void
        {
            stopTimer();
            animals++;
            collect_in = old_collect_in;
            check_products();
            startTimer();
            update_stage();
            update_animals();
        }

        override protected function queue_highlight() : void
        {
            if (!mc)
            {
                return;
            }
            if (process_count["collect"] && products)
            {
                if (process_count["collect"] >= 1)
                {
                    Effects.green(mc[product_mc][product_mc + products]);
                }
                if (process_count["collect"] >= 2 && products > 1)
                {
                    Effects.green(mc[product_mc][product_mc + (products - 1)]);
                }
                if (process_count["collect"] >= 3 && products > 2)
                {
                    Effects.green(mc[product_mc][product_mc + (products - 2)]);
                }
                state_cont.visible = false;
            }
            if (!food_mc)
            {
                return;
            }
            if (process_count["feed"])
            {
                if (process_count["feed"] >= 1 && raw_materials < 3)
                {
                    mc[food_mc][food_mc + (raw_materials + 1)].visible = true;
                    Effects.green(mc[food_mc][food_mc + (raw_materials + 1)]);
                }
                if (process_count["feed"] >= 2 && raw_materials < 2)
                {
                    mc[food_mc][food_mc + (raw_materials + 2)].visible = true;
                    Effects.green(mc[food_mc][food_mc + (raw_materials + 2)]);
                }
                if (process_count["feed"] >= 3 && raw_materials < 1)
                {
                    mc[food_mc][food_mc + (raw_materials + 3)].visible = true;
                    Effects.green(mc[food_mc][food_mc + (raw_materials + 3)]);
                }
                state_cont.visible = false;
            }
        }

        override protected function update_stage() : void
        {
            if (!enabled)
            {
                return;
            }
            update_raw_material_area();
            update_product_area();
            update_animals();
            if (is_working)
            {
                working_animation();
            }
            else
            {
                hungry_animation();
            }
        }

        override public function set enabled(value:Boolean) : void
        {
            super.enabled = value;
            if (mc)
            {
                if (!value)
                {
                    disabled_state();
                }
                else
                {
                    update_stage();
                }
            }
        }

        override public function clear_process(animals:String) : void
        {
            update_raw_material_area();
        }

        protected function disabled_state() : void
        {
            return;
        }

        override protected function init() : void
        {
            check_products();
            super.init();
            loader.cache_swf = true;
            process_count["collect"] = 0;
            process_count["feed"] = 0;
        }

        protected function hungry_animation() : void
        {
            return;
        }

        protected function update_product_area() : void
        {
            if (mc)
            {
                mc[product_mc][product_mc + "1"].visible = false;
                mc[product_mc][product_mc + "2"].visible = false;
                mc[product_mc][product_mc + "3"].visible = false;
                if (products >= 1)
                {
                    mc[product_mc][product_mc + "1"].visible = true;
                    Effects.clear(mc[product_mc][product_mc + "1"]);
                }
                if (products >= 2)
                {
                    mc[product_mc][product_mc + "2"].visible = true;
                    Effects.clear(mc[product_mc][product_mc + "2"]);
                }
                if (products >= 3)
                {
                    mc[product_mc][product_mc + "3"].visible = true;
                    Effects.clear(mc[product_mc][product_mc + "3"]);
                }
                queue_highlight();
            }
        }

        protected function update_animals() : void
        {
            return;
        }

        override protected function refresh_hit_area() : void
        {
            super.refresh_hit_area();
            if (collect_hit_area)
            {
                hit_area.graphics.beginFill(0, 0);
                var sy:Number = asset.scaleY;
                var direction:Number = asset.scaleX < 0 ? (-1) : (1);
                var ww:Number = asset.scaleX < 0 ? (collect_hit_area.width * sy) : (0);
                hit_area.graphics.drawRect(direction * collect_hit_area.x * sy - ww, collect_hit_area.y * sy, collect_hit_area.width * sy, collect_hit_area.height * sy);
                hit_area.graphics.endFill();
            }
        }

        public function feed() : void
        {
            if (raw_materials == max_raw_materials)
            {
                return;
            }
            raw_materials++;
            if (!is_working)
            {
                produce();
                if (_automatic)
                {
                    automation_checked = false;
                }
            }
            else
            {
                update_stage();
            }
        }

        override public function preload_position(value:String) : Object
        {
            var position:Object = super.preload_position(value);
            switch(value)
            {
                case "refill":
                {
                    break;
                }
                case "collect":
                {
                    if (mc)
                    {
                        position.x = position.x + (collect_area.getBounds(this).left + collect_area.getBounds(this).width / 2);
                        position.y = position.y + collect_area.getBounds(this).top;
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return position;
        }

        public function highlight_refill() : void
        {
            clear_highlight();
            if (refill_area)
            {
                Effects.glow(refill_area);
            }
        }

        override protected function assetLoaded(event:Event) : void
        {
            super.assetLoaded(event);
            check_automation("on_load");
        }

        public function highlight_collect() : void
        {
            clear_highlight();
            if (collect_area)
            {
                Effects.glow(collect_area);
            }
        }

        public function get raw_material_id() : Number
        {
            return raw_material;
        }

        public function get_raw_materials() : Number
        {
            return raw_materials;
        }
		
		/**
		 * 是否需要喂食
		 * 每次喂食的话raw_materials会+1
		 * 如果总数<max_raw_materials那么就说明能继续喂食
		 */ 
        public function can_feed() : Boolean
        {
            return raw_materials + process_count["feed"] < max_raw_materials;
        }

        protected function get collect_hit_area() : MovieClip
        {
            return null;
        }

        protected function _is_blocked() : Boolean
        {
            return products == max_products;
        }

        public function collect() : void
        {
            if (products < 1)
            {
                return;
            }
            products--;
            automation_checked = false;
            if (raw_materials > 0 && !is_working)
            {
                produce();
            }
            else
            {
                update_stage();
            }
        }

        public function get_products() : Number
        {
            return products;
        }

        public function highlight_automation_areas(animals:Number) : void
        {
            if (refill_area)
            {
                Effects.glow(refill_area, animals);
            }
            if (collect_area)
            {
                Effects.glow(collect_area, animals, false);
            }
        }

        protected function check_products() : void
        {
            var index:Number = NaN;
            collect_in = old_collect_in / animals;
            start_time = Algo.time();
            if (start_time)
            {
                index = Math.min(max_products - products, Math.min(raw_materials, Math.floor((Algo.time() - start_time) / collect_in)));
                if (index < 0)
                {
                    index = 0;
                }
                start_time = start_time + index * collect_in;
                products = products + index;
                raw_materials = raw_materials - index;
                if (raw_materials == 0 || products == max_products)
                {
                    start_time = 0;
                }
                else
                {
                    if (raw_materials > 0)
                    {
                    }
                    is_working = products < max_products;
                }
            }
        }

        public function refill_over() : Boolean
        {
            var point:Point = null;
            var globalPoint:Point = null;
            if (refill_area)
            {
                point = new Point(refill_area.mouseX, refill_area.mouseY);
                globalPoint = refill_area.localToGlobal(point);
                return refill_area.hitTestPoint(globalPoint.x, globalPoint.y, true);
            }
            return false;
        }

        protected function dispatch_auto_collect() : void
        {
            dispatchEvent(new Event(AUTO_COLLECT));
        }

        protected function _is_working() : Boolean
        {
            return start_time > 0;
        }

        override public function turn_on_automation() : void
        {
            automation_checked = false;
            super.turn_on_automation();
            check_automation("turn_on");
        }

        public function check_automation(value:String) : void
        {
            var index:Number = 0;
            if (!_automatic)
            {
                return;
            }
            if (value == "on_collect" && automation_checked)
            {
                return;
            }
            index = 0;
            while (index < products)
            {
                
                dispatchEvent(new Event(AUTO_COLLECT));
                index++;
            }
            if (next_product_in() > 0)
            {
                return;
            }
            index = 0;
            while (index < 2 - raw_materials)
            {
                dispatchEvent(new Event(AUTO_REFILL));
                index++;
            }
            if (raw_materials > 1)
            {
                automation_checked = true;
            }
        }

        public function collect_over() : Boolean
        {
            if (collect_hit_area)
            {
                var point:Point = new Point(collect_hit_area.mouseX, collect_hit_area.mouseY);
                var globalPoint:Point = collect_hit_area.localToGlobal(point);
                return collect_hit_area.hitTestPoint(globalPoint.x, globalPoint.y, true);
            }
            return false;
        }

        public function can_collect() : Boolean
        {
            return products - process_count["collect"] > 0;
        }

        override public function is_ready() : Boolean
        {
            return products > 0;
        }

        override public function update(animals:Object) : void
        {
            is_updating = true;
            if (raw_materials > 0 && products < max_products)
            {
                stopTimer();
                start_time = animals.start_time;
                check_products();
                startTimer();
                update_stage();
            }
            else
            {
                updated_start_time = animals.start_time;
            }
            is_updating = false;
        }

        public function clear_highlight() : void
        {
            if (collect_area)
            {
                Effects.clear(collect_area);
            }
            if (refill_area)
            {
                Effects.clear(refill_area);
            }
        }

        protected function update_raw_material_area() : void
        {
            if (mc)
            {
                mc[food_mc][food_mc + "1"].visible = false;
                mc[food_mc][food_mc + "2"].visible = false;
                mc[food_mc][food_mc + "3"].visible = false;
                if (raw_materials >= 1)
                {
                    mc[food_mc][food_mc + "1"].visible = true;
                    Effects.clear(mc[food_mc][food_mc + "1"]);
                }
                if (raw_materials >= 2)
                {
                    mc[food_mc][food_mc + "2"].visible = true;
                    Effects.clear(mc[food_mc][food_mc + "2"]);
                }
                if (raw_materials >= 3)
                {
                    mc[food_mc][food_mc + "3"].visible = true;
                    Effects.clear(mc[food_mc][food_mc + "3"]);
                }
                queue_highlight();
            }
        }

        public function raw_material_name() : String
        {
            return _raw_material_name;
        }

        protected function produce() : void
        {
            if (raw_materials > 0 && products < max_products)
            {
                if (updated_start_time)
                {
                    start_time = updated_start_time;
                    updated_start_time = 0;
                }
                else
                {
                    start_time = Algo.time();
                }
                startTimer();
            }
            update_stage();
        }

        override public function kill() : void
        {
            clearTimeout(auto_collect_interval);
            super.kill();
        }

        override protected function on_product_complete() : void
        {
            super.on_product_complete();
            if (_automatic)
            {
                dispatchEvent(new Event(AUTO_REFILL));
                auto_collect_interval = setTimeout(dispatch_auto_collect, 1000);
                automation_checked = false;
            }
            products++;
            raw_materials--;
            produce();
        }

        protected function get refill_area() : MovieClip
        {
            return null;
        }

        protected function working_animation() : void
        {
        }

    }
}
