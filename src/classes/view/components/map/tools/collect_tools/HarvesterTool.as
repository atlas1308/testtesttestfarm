package classes.view.components.map.tools.collect_tools {
    import classes.utils.*;
    import flash.display.*;
    import classes.view.components.map.*;
    import classes.view.components.*;

    public class HarvesterTool extends Subtool {

        private var work_area_size:Number;
        private var plants:Array;
        private var last_objs:Array;
        private var area:WorkArea;
        private var _activated:Boolean = true;

        public function HarvesterTool(work_area_size:Number){
            last_objs = [];
            super();
            TYPE = "harvester";
            work_area_size = 4;
            this.work_area_size = work_area_size;
            area = new WorkArea(work_area_size);
            area.mouseChildren = false;
            area.visible = false;
        }
        override protected function mouseUp():void{
            var mo:Plant;
            if (((plant) && (plant.is_ready()))){
                if (!_activated){
                    _activated = true;
                    plant.state = "clear";
                    hide_tip();
                    mouseMove();
                    return;
                };
            };
            plants = new Array();
            var objs:Array = MapSharding.get_shards(area.grid_x, area.grid_y, area.x_size, area.y_size);
            var i:Number = 0;
            while (i < objs.length) {
                mo = (objs[i] as Plant);
                if (((((((mo) && (mo.usable))) && (mo.is_ready()))) && (area.contains_obj(mo, false)))){
                    plants.push(mo);
                };
                i++;
            };
            if (plants.length){
                confirm(Map.HARVEST_PLANTS);
            };
            plants = new Array();
        }
        override protected function mouseOut():void{
            if (!_activated){
                hide_tip();
                if (target){
                    target.state = "clear";
                };
            };
        }
        override public function activate():void{
            DisplayObjectContainer(tool_cont.parent.getChildByName("grass")).addChild(area);
        }
        private function get plant():Plant{
            if ((((target as Plant)) && (target.usable))){
                return ((target as Plant));
            };
            return (null);
        }
        override public function allow():Boolean{
            return (false);
        }
        override public function remove():void{
            var i:Number;
            super.remove();
            if (area.parent){
                DisplayObjectContainer(tool_cont.parent.getChildByName("grass")).removeChild(area);
            };
            i = 0;
            while (i < last_objs.length) {
                MapObject(last_objs[i]).state = "clear";
                i++;
            };
            last_objs = [];
        }
        override protected function mouseMove():void{
            var i:Number;
            var j:Number;
            var objs:Array;
            var snap_list:Array;
            var a_x:Number;
            var a_y:Number;
            var max_crops:Number;
            var crops:Number;
            var area_coords:Object;
            var crop_list:Array;
            var mo:Plant;
            var r_x:Number;
            var r_y:Number;
            var delta_x:Number;
            var delta_y:Number;
            var obj:Plant;
            if (!area.parent){
                activate();
            };
            if (_activated){
                area.snapToGrid(map_size_x, map_size_y, map_top_size);
                area.visible = true;
                i = 0;
                while (i < last_objs.length) {
                    MapObject(last_objs[i]).state = "clear";
                    i++;
                };
                last_objs = [];
                objs = MapSharding.get_shards(area.grid_x, area.grid_y, area.x_size, area.y_size);
                snap_list = [];
                i = 0;
                while (i < objs.length) {
                    mo = (objs[i] as Plant);
                    //if (((((((mo) && (mo.usable))) && (mo.is_ready()))) && (mo.intersect(area)))){
                    if(mo){
                        snap_list.push(mo);
                    }
                    //};
                    i++;
                };
                a_x = area.grid_x;
                a_y = area.grid_y;
                max_crops = 0;
                crops = 0;
                area_coords = {};
                crop_list = [];
                i = 0;
                while (i < snap_list.length) {
                    area.grid_x = a_x;
                    area.grid_y = a_y;
                    mo = (snap_list[i] as Plant);
                    if (!area.contains_obj(mo)){
                        r_x = ((mo.grid_x - area.grid_x) % 4);
                        r_y = ((mo.grid_y - area.grid_y) % 4);
                        delta_x = 0;
                        delta_y = 0;
                        if (r_x < 0){
                            delta_x = r_x;
                        } else {
                            if (r_x > 2){
                                if ((mo.grid_x + mo.x_size) > (a_x + area.x_size)){
                                    delta_x = 3;
                                } else {
                                    delta_x = -1;
                                };
                            } else {
                                delta_x = r_x;
                            };
                        };
                        if (r_y < 0){
                            delta_y = r_y;
                        } else {
                            if (r_y > 2){
                                if ((mo.grid_y + mo.y_size) > (a_y + area.y_size)){
                                    delta_y = 3;
                                } else {
                                    delta_y = -1;
                                };
                            } else {
                                delta_y = r_y;
                            };
                        };
                        area.grid_x = (a_x + delta_x);
                        area.grid_y = (a_y + delta_y);
                    };
                    crops = 0;
                    crop_list = [];
                    crop_list.push(mo);
                    j = 0;
                    while (j < snap_list.length) {
                        if (j == i){
                        } else {
                            obj = (snap_list[j] as Plant);
                            if (area.contains_obj(obj)){
                                crops++;
                                crop_list.push(obj);
                            };
                        };
                        j++;
                    };
                    if ((((crops > max_crops)) || ((((i == (snap_list.length - 1))) && ((max_crops == 0)))))){
                        area_coords.x = area.grid_x;
                        area_coords.y = area.grid_y;
                        max_crops = crops;
                        last_objs = crop_list;
                    };
                    i++;
                };
                if (last_objs.length){
                    area.grid_x = area_coords.x;
                    area.grid_y = area_coords.y;
                };
                last_objs = [];
                i = 0;
                while (i < snap_list.length) {
                    mo = (snap_list[i] as Plant);
                    if (((((((mo) && (mo.is_ready()))) && (mo.usable))) && (area.contains_obj(mo, false)))){
                        last_objs.push(mo);
                        mo.state = "harvester_over";
                    };
                    i++;
                };
            } else {
                if (plant.is_ready()){
                    plant.state = "collect_over";
                    if (plant.is_pollinated()){
                        tip((plant.get_name() + " - click to harvest\n(pollinated)"));
                    } else {
                        tip((plant.get_name() + " - click to harvest"));
                    };
                };
                area.visible = false;
            };
        }
        override public function get_event_data():Object{
            return (plants);
        }
        public function refresh(data:Object=null):void{
            area.set_size(Map.work_area_size);
            _activated = true;
            mouseMove();
        }
        override public function refresh_grid_size(size:Number):void{
            super.refresh_grid_size(size);
            area.grid_size = size;
        }
        override public function usable():Boolean{
            return (true);
        }

    }
} 
