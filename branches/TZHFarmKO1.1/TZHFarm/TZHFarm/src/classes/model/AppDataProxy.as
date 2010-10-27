﻿package classes.model {
	import classes.ApplicationFacade;
	import classes.model.confirmation.Confirmation;
	import classes.model.err.Err;
	import classes.model.transactions.RefillMapObjectCall;
	import classes.utils.Algo;
	import classes.utils.Cache;
	import classes.view.components.map.CollectObject;
	import classes.view.components.map.IProcessor;
	import classes.view.components.map.MapObject;
	import classes.view.components.map.MultiProcessor;
	import classes.view.components.map.Plant;
	import classes.view.components.map.Processor;
	import classes.view.components.map.Tree;
	import classes.view.components.map.WaterWell;
	
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mx.resources.ResourceManager;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	import tzh.core.Config;
	import tzh.core.JSDataManager;
	

    public class AppDataProxy extends Proxy implements IProxy {

        public static const NAME:String = "AppDataProxy";

        private var last_post_tag:String;
        private var app_data:Object;
        public var user_id:Number;
        private var queue:Array;
        private var map_object_to_use:MapObject;
        private var queue_interval:Number;
        private var last_sent_gift_data:Object;
        private var config:Object;
        public var last_feed_data:Object;
        private var fb_data:Object;
        public var app_url:String = "";
        public var gift_mode:Boolean = false;
        private var shared_object:SharedObject;
        private var show_help_popup_interval:Number;
        private var auto_process_id:Number = 0;
        private var auto_queue:Array;
        private var friends_helped:Array;
        private var last_app_data:Object;
        private var already_init:Boolean = false;
        private var queue_is_processing:Boolean = false;
        private var objects_created:Boolean = false;
        private var confirm:Confirmation;
        private var last_post_subtype:String;
        private var last_used_materials:Object;
        private var update_fields:Array;

        public function AppDataProxy(params:Object){
            fb_data = new Object();
            last_sent_gift_data = new Object();
            last_used_materials = new Object();
            update_fields = ["shop", "map", "storage", "level", "coins", "reward_points", "neighbors", "gifts", "name", "operations"];
            app_url = params.app_url;
            user_id = params.fb_sig_user;
            super(NAME);
        }
        
        /**
         * 判断是否能灌溉 
         */ 
        public function can_install_irrigation(id:Number, report:Boolean=true):Boolean{
            var info:Object = config.store[id];
            var objs:Array = get_objects_like(info.object_needed);
            var target:Object = config.store[info.object_needed];
            if (objs.length == 0){
                if (report){
                    return (report_confirm_error(ResourceManager.getInstance().getString("message","build_message",[Algo.articulate(target.name).toString()])));
                };
                return (false);
            };
            if (objs[0].under_construction){
                if (report){
                	return (report_confirm_error(ResourceManager.getInstance().getString("message","finish_message",[target.name])));
                };
                return (false);
            };
            if (count_sprinklers() >= target.depth[objs[0].upgrade_level]){
                if (!can_upgrade(objs[0])){
                    if (report){
                        report_confirm_error(ResourceManager.getInstance().getString("message","water_crops_message"));
                    };
                    return (false);
                };
                if (report){
                	report_confirm_error(ResourceManager.getInstance().getString("message","water_up_message",[target.name,target.depth[objs[0].upgrade_level].toString()]));
                };
                return (false);
            };
            return (true);
        }
        
        /**
         * 跳转页面 
         */ 
        public function navigate_to(value:String):void{
        	var request:URLRequest = new URLRequest(Config.getConfig("app_url").toString() + value);
        	try {
            	navigateToURL(request, "_parent");
            }catch(error:Error) {
            	trace("navigae error " + error.message);
            }
        }
        
        /**
         * 用户已经有的原料 
         */ 
        private function num_obtained_materials(obj:Object):Number{
            var m:String;
            var c:Number = 0;
            for (m in obj.obtained_materials) {
                c = (c + obj.obtained_materials[m]);
            };
            return (c);
        }
        
        /**
         * 用户的RC值 
         */ 
        public function get reward_points():Number{
            return (app_data.reward_points);
        }
        
        /**
         * 使用原料 
         */ 
        private function use_material(m:Object, target:Object=null):Boolean{
            var obj:Object;
            var list:Array = (target) ? [target] : get_objects_who_use(m.id, true);
            if (list.length){
                if (list.length > 1){
                    sendNotification(ApplicationFacade.SHOW_SELECT_OBJECT_POPUP, get_select_object_popup_data(list, m));
                    return (false);
                };
                obj = list[0];
                var _local5 = obj.obtained_materials;
                var _local6 = m.id;
                var _local7 = (_local5[_local6] + 1);
                _local5[_local6] = _local7;
                last_used_materials[m.id] = obj.id;
                if (num_materials(obj) == num_obtained_materials(obj)){
                    if (can_upgrade(obj)){
                        obj.upgrade_level++;
                    } else {
                        obj.under_construction = false;
                    };
                    obj.obtained_materials = new Array();
                };
                if (confirm){
                    confirm.add_value(1, (" " + config.store[m.id].name));
                };
                sendNotification(ApplicationFacade.INCREASE_OBTAINED_MATERIAL, {
                    mo:obj,
                    material:m.id
                });
            };
            return (true);
        }
        
        /**
         * 通过 raw_material来获取产生的product id
         */ 
        private function get_product_by_raw_material(id:Number, info:Object):Number{
            var i:Number = 0;
            while (i < info.raw_material[0].length) {
                if (info.raw_material[0][i] == id){
                    return (info.product[i]);
                };
                i++;
            };
            return (0);
        }
        
        /**
         * 获取用户等级的数据 
         */ 
        public function get_level_data():Object{
            var output:Object = new Object();
            output.level = app_data.level;// 最大的值应该是74,因为下标是从0开始的
            output.experience = app_data.experience;
            output.min = Number(config.levels[app_data.level].min);
            output.max = Number(config.levels[app_data.level].max);
            /* output.min = (config.levels[app_data.level - 1].min as Number);
            output.max = (config.levels[app_data.level - 1].max as Number); */
            output.percent = (Number(app_data.experience) - output.min) / (output.max - output.min);
            output.needed = (output.max - output.experience);
            return output;
        }
        
        /**
         * 备用,暂时没有分析 
         */ 
        public function get_gift_sent_confirmation_data():Object{
            var output:Object = new Object();	
            var neighbor:String = prep_neighbor_data({uid:last_sent_gift_data.neighbor}, true).name;
            var gift:String = config.store[last_sent_gift_data.gift].name;
            output.message = ResourceManager.getInstance().getString("message","neighbor_receive_message",[neighbor,gift]);
            output.type = PopupTypes.GIFT_SENT_CONFIRMATION;
            output.ok_label = ResourceManager.getInstance().getString("message","ok_label");
            output.close_label = ResourceManager.getInstance().getString("message","close_label");
            output.width = 450;
            output.height = 250;
            output.inner_width = 350;
            output.inner_height = 160;
            return output;
        }
        
        /**
         * 备用,暂时没有分析 
         */
        private function obj_increase_raw_material(o:Object, index:Number=0, material:Number=0):void{
            update_object(o);
            if (is_multi(o)){
                o.raw_materials[(index - 1)].push(material);
            } else {
                o.raw_materials++;
            }
            if (((!(obj_is_blocked(o))) && (!(obj_is_working(o))))){
                obj_start(o);
            }
        }
        
        /**
         * 发送feed
         */
        public function post_published(type:String, target:Number=0):void{
            if (config.ask_for_materials_stories.indexOf(type) > -1){
                app_data.ask_for_materials[target] = false;
            };
            if (config.ask_for_help_stories.indexOf(type) > -1){
                app_data.ask_for_help[target] = false;
            };
        }
        
        /**
         * 初始化的一个方法,在retrieve返回时去处理这个方法 
         */ 
        public function init(config:Object, app_data:Object):void{
            var i:* = NaN;
            var data:* = null;
            var obj:* = null;
            var gift:* = null;
            var name:* = null;
            var config:* = config;// 配置的数据
            var app_data:* = app_data;// 用户的数据
            Log.add("app init");
            if (!objects_created){
                this.config = config;
                this.app_data = app_data;
                return;
            };
            if (already_init){
                return;
            };
            already_init = true;
            try {
                shared_object = SharedObject.getLocal("raw_material");
            } catch(e:Error) {
                Log.add(("getLocal error " + e));
            };
            queue = new Array();
            auto_queue = new Array();
            friends_helped = new Array();
            this.config = config;
            this.app_data = app_data;
            Algo.convert_to_number(config);
            Algo.convert_to_number(app_data);
            this.app_data.coins = parseFloat(app_data.coins);
            this.app_data.experience = parseFloat(app_data.experience);
            this.app_data.op = parseFloat(app_data.op);
            this.app_data.reward_points = parseFloat(app_data.reward_points);
            //app_data.lottery_coins = 100;// 这个是默认的后台已经算好的值,客户端显示之后,变化一下而已
            if (app_data.lottery_coins > 0){// 这个还是不太明确呢,可能是类似于每日登陆奖励的东西
                app_data.coins = (app_data.coins - parseFloat(app_data.lottery_coins));
            };
            if (app_data.friend_helped){// 为什么这里都是减少的呢,难道这里是负数呢
                app_data.coins = (app_data.coins - parseFloat(app_data.friend_helped.coins));
                app_data.experience = (app_data.experience - parseFloat(app_data.friend_helped.exp));
            }
            if (app_data.gifts_received){
                app_data.experience = (app_data.experience - (parseFloat(config.gift_received_exp) * app_data.gifts_received.length));
            }
            Cache.base_url = app_data.base_url;
            Cache.assets_urls = app_data.assets_urls;
            if (app_data.friend_helped){
                sendNotification(ApplicationFacade.SHOW_FRIEND_HELPED_POPUP);
            }
            if (app_data.show_gifts_page){
                sendNotification(ApplicationFacade.SHOW_GIFT_BOX);
            }
            if (app_data.items_received.length > 0){
                sendNotification(ApplicationFacade.SHOW_ITEMS_RECEIVED);
            }
            if (app_data.news){
                i = 0;
                while (i < app_data.news.length) {
                    sendNotification(ApplicationFacade.SHOW_NEWS_POPUP, app_data.news[i]);
                    i = (i + 1);
                }
            };
            if (app_data.lottery_coins > 0){
                sendNotification(ApplicationFacade.SHOW_LOTTERY_POPUP);
            };
            if (((app_data.gifts_received) && ((app_data.gifts_received.length > 0)))){
                i = 0;
                while (i < app_data.gifts_received.length) {
                    obj = new Object();
                    obj.image = ResourceManager.getInstance().getString("message","send_gift");
                    gift = config.store[app_data.gifts_received[i].gift].name;
                    name = prep_neighbor_data({uid:app_data.gifts_received[i].uid}, true).name;
                    obj.message=ResourceManager.getInstance().getString("message","sent_you");
                    obj.message = ResourceManager.getInstance().getString("message","check_out",[obj.message]);
                    obj.offset_y = -5;
                    obj.offset_x = -2;
                    sendNotification(ApplicationFacade.SHOW_GIFT_RECEIVED_POPUP, obj);
                    i = (i + 1);
                };
                data = new Object();
                data.type = PopupTypes.SUGGEST_TO_BUY_GIFT;
                data.message = ResourceManager.getInstance().getString("message","feel_for_receive")
                data.ok_label = ResourceManager.getInstance().getString("message","ok_label");
                data.close_label = ResourceManager.getInstance().getString("message","close_label");
                sendNotification(ApplicationFacade.SHOW_POPUP, data);
            };
            update_objects(update_fields);
            if (app_data.farm){
                sendNotification(ApplicationFacade.SHOW_FARM);
            };
            setTimeout(hideOverlay,1000);
            /* if (app_data.feed_data){
            }; */
        }
        
        private function hideOverlay():void {
        	sendNotification(ApplicationFacade.HIDE_OVERLAY);
        }
        
        public function lottery_message():String{
            return (app_data.lottery_coins);
        }
        
        /* public function get base_url():String{
            return (app_data.base_url);
        } */
        
        public function cancel_help_popup():void{
            clearTimeout(show_help_popup_interval);
        }
        
        private function add_to_storage(id:Number):void{
            if (!app_data.storage[id]){//如果没有就默认为0
                app_data.storage[id] = 0;
            };
            var _local3 = app_data.storage;
            var _local4 = id;
            var _local5 = (_local3[_local4] + 1);
            _local3[_local4] = _local5;
            var c:Confirmation = new Confirmation();
            c.text(("+1 " + config.store[id].name));
            sendNotification(ApplicationFacade.DISPLAY_BARN_CONFIRMATION, c);
            sendNotification(ApplicationFacade.START_COLLECT_ANIMATION, null);
        }
        
        /**
         * 删除Map里的Object
         * 然后进行加钱等操作 
         */ 
        public function remove_map_object(obj:MapObject):Boolean{
            var i:Number;
            var mo:Object;
            var price:Number = get_sell_price(obj.id, obj.grid_x, obj.grid_y);
            if (price){
                app_data.coins = (app_data.coins + price);
                confirm = new Confirmation(0, price);
                update_objects(["coins"]);
            };
            remove_map_obj(obj.id, obj.grid_x, obj.grid_y, obj.map_flip_state);
            if ((obj as WaterWell)){
                i = 0;
                while (i < app_data.map.length) {
                    mo = app_data.map[i];
                    if (mo.water_pipe){
                        mo.water_pipe = 0;
                    };
                    i++;
                };
            };
            sendNotification(ApplicationFacade.MAP_OBJECT_REMOVED, obj);
            return (true);
        }
        
        
        private function obj_is_blocked(o:Object):Boolean{
            update_object(o);
            if (!is_multi(o)){
                return ((o.products == 3));
            };
            return ((o.products.length == 3));
        }
        
        
        private function obj_start(o:Object):void{
            var materials:Number;
            update_object(o);
            if (o.start_time){
                return;
            };
            var info:Object = config.store[o.id];
            if (is_multi(o)){
                materials = num_complete_raw_materials(o);
            } else {
                materials = o.raw_materials;
            };
            if (((!((info.type == "seeds"))) && (!(materials)))){
                return;
            };
            o.start_time = Algo.time();
        }
        
        
        public function get friend_farm_id():Number{
            return (app_data.farm.uid);
        }
        
        /**
         * 出售商店里的物品 
         */ 
        public function sell_storage_item(obj:Object):Boolean{
            var info:Object = config.store[obj.id];
            var q:Number = Math.min(obj.qty, app_data.storage[obj.id]);// 这个最小还没看懂
            var c:Number = (info.sell_for * q);
            app_data.coins = (app_data.coins + c);
            confirm = new Confirmation(0, c);
            app_data.storage[obj.id] = (app_data.storage[obj.id] - q);
            update_objects(["coins", "storage"]);
            return (true);
        }
        
        public function can_show_gifts_page():Boolean{
            if (app_data.show_gifts_page){
                return true;
            }
            return false;
        }
        
        /**
         * 这个方法写的不是很好,最好能用广播事件的方式去处理
         * 这是有加经验时,刷新一个等级
         * 获取当前level的最大值如果当前的用户的经验>level.max,那这个用户升级了
         */ 
        private function refresh_level():void{
            var level:Object = config.levels[app_data.level];
            var next_level:Object = config.levels[(app_data.level + 1)];
            if (app_data.experience >= level.max){
                app_data.level++;
                if (confirm){
                    confirm.level_up = true;
                }
            }
        }
        
        private function num_complete_raw_materials(o:Object):Number{
            var c:Number = 100;
            var i:Number = 0;
            while (i < o.raw_materials.length) {
                if (c > o.raw_materials[i].length){
                    c = o.raw_materials[i].length;
                };
                i++;
            };
            if (c == 100){
                return (0);
            };
            return (c);
        }
        
        public function refill_map_object(p:Object, body:TransactionBody, gift_mode:Boolean=false, queue_call:Boolean=false):Boolean{
            var msg:String;
            var producer:Object;
            var obj_fed:Object;
            var obj:MapObject = p.obj;
            var info:Object = config.store[obj.id];
            var raw_material:* = MultiProcessor(obj).get_raw_material_id(p.material);
            var food_info:Object = config.store[raw_material];
            if (((queue_call) && (!(app_data.storage[raw_material])))){
                obj.clear_process(("feed" + p.material));
                return (false);
            };
            if (((!(app_data.storage[raw_material])) && (!(queue_search_for_food(raw_material))))){
                msg = ResourceManager.getInstance().getString("message","the_barn_message");
                if ((((obj.kind == "jam")) && ((p.material == 1)))){
                    msg =ResourceManager.getInstance().getString("message","change_fruit_type_message",[msg]);
                };
                producer = config.store[food_info.producer];
                if (producer.type == "seeds"){
                    switch (get_plant_state(food_info.producer)){
                        case "grown":
                            msg = ResourceManager.getInstance().getString("message","harvest_food_message",[food_info.name]);
                            break;
                        case "growing":
                        	msg = ResourceManager.getInstance().getString("message","wait_for_food_message",[food_info.name]);
                            break;
                        case "none":
                        	msg = ResourceManager.getInstance().getString("message","plant_food_message",[food_info.name]);
                            break;
                    };
                };
                obj.clear_process(("feed" + p.material));
                return (report_confirm_error(msg));
            };
            if (!queue_call){
                add_to_queue("refill_map_object", p, obj, feed_object_action(info), ("feed" + p.material), body);
            } else {
                obj_fed = get_map_obj(obj.id, obj.grid_x, obj.grid_y);
                if (obj_fed.raw_materials[(p.material - 1)].length == 3){
                    return (report_confirm_error(ResourceManager.getInstance().getString("message","is_full_message")));
                };
                confirm = new Confirmation(food_info.exp, 0);
                confirm.set_target(obj);
                app_data.experience = (app_data.experience + food_info.exp);
                var storage:Object = app_data.storage;
                var _local13 = raw_material;
                var _local14 = (storage[_local13] - 1);
                storage[_local13] = _local14;
                obj_increase_raw_material(obj_fed, p.material, raw_material);
                refresh_level();
                MultiProcessor(obj).refill_with(p.material);
                update_objects(["storage", "experience"]);
                transaction_proxy.set_data_hash(data_hash);
                transaction_proxy.add(body, true);
            }
            return false;
        }
        
        /**
         * 
         */ 
        public function show_gift_received_popup_displayed():void{
            app_data.experience = (app_data.experience + config.gift_received_exp);
            confirm = new Confirmation(config.gift_received_exp);
            Log.add(("show_gift_received_popup_displayed " + config.gift_received_exp));
            update_objects(["experience"]);
        }
        
        /**
         * 用户的金币 
         */ 
        public function get coins():Number{
            return (app_data.coins);
        }
        
        
        public function friend_helped_popup_displayed():void{
            var coins:Number = parseFloat(app_data.friend_helped.coins);
            var exp:Number = parseFloat(app_data.friend_helped.exp);
            app_data.coins = (app_data.coins + coins);
            app_data.experience = (app_data.experience + exp);
            confirm = new Confirmation(exp, coins);
            update_objects(["experience", "coins"]);
        }
        
        private function can_upgrade(obj:Object):Boolean{
            var info:Object = config.store[obj.id];
            if (!info.upgradeable){
                return (false);
            };
            if (obj.under_construction){
                return (false);
            };
            if (obj.upgrade_level == (Algo.count(info.upgrade_levels) + 1)){
                return (false);
            };
            return (true);
        }
        
        public function install_irrigation(obj:Object):Boolean{
            var map_obj:Object = get_map_obj(obj.target.id, obj.target.grid_x, obj.target.grid_y);
            var info:Object = config.store[obj.water_pipe];
            if (!can_install_irrigation(obj.water_pipe)){
                return (false);
            };
            var disable:Boolean;
            if (!gift_mode){
                if (app_data.coins < info.price){
                    return (report_confirm_error(Err.NO_COINS));
                };
                if (((info.rp_price) && ((app_data.reward_points < info.rp_price)))){
                    return (report_confirm_error(Err.NO_RP));
                };
            };
            map_obj.water_pipe = info.id;
            if (gift_mode){
                var _local5 = app_data.gifts;
                var _local6 = info.id;
                var _local7 = (_local5[_local6] - 1);
                _local5[_local6] = _local7;
                if (!app_data.gifts[info.id]){
                    disable = true;
                };
            } else {
                app_data.experience = (app_data.experience + info.exp);
                confirm = new Confirmation(info.exp, -(info.price), -(info.rp_price));
                if (info.rp_price){
                    app_data.reward_points = (app_data.reward_points - info.rp_price);
                };
                if (info.price){
                    app_data.coins = (app_data.coins - info.price);
                };
            };
            update_objects(["experience", "coins", "gifts", "reward_points"]);
            sendNotification(ApplicationFacade.IRRIGATION_INSTALLED, {
                disable:disable,
                water_pipe:{
                    growing_percent:info.growing_percent,
                    image:(("images/" + info.url) + "_obj.png"),
                    id:info.id
                }
            });
            return (true);
        }
        
        /**
         * 获取storage里的数据 
         */ 
        public function get_storage_data():Object{
            var item:String;
            var info:Object;
            var output:Array = new Array();
            var total:Number = 0;
            for (item in app_data.storage) {
                if (!app_data.storage[item]){
                } else {
                    info = get_item_data(int(item));
                    info.qty = app_data.storage[item];
                    total = (total + (info.qty * info.sell_for));
                    output.push(info);
                };
            };
            return ({
                list:output,
                total_value:Algo.number_format(total)
            });
        }
        
        /**
         * 荣誉系统,暂时没有使用到这些内容 
         */ 
        public function get_achievements_data():Array{
            var output:Array;
            var obj:Object;
            var _local3:Object;
            var _local4:Object;
            output = new Array();
            return (output);
        }
        
        /**
         * 发送错误消息 
         */ 
        private function report_error(name:String):Boolean{
            sendNotification(ApplicationFacade.DISPLAY_ERROR, name);
            return (false);
        }
        
        
        private function neighbors_count():Number{
            return (app_data.all_neighbors.length);
        }
        
        
        public function get_help_data():Object{
            var output:Object = new Object();
            output.friend_name = friend_name;
            if (((((fb_data) && (fb_data[app_data.farm.uid]))) && (!((fb_data[app_data.farm.uid].pic_square == ""))))){
                output.photo = fb_data[app_data.farm.uid].pic_square;
            } else {
                output.photo = no_pic_url();
            };
            output.message = ResourceManager.getInstance().getString("message","water_other_crops",[user_name,output.friend_name]);
            return (output);
        }
        
        
        public function process_queue():void{
            var obj:Object;
            if (queue_is_processing){
                obj = queue.shift();
                obj.map_obj.end_process(obj.channel);
                var _local5 = this;
                _local5[obj.method](obj.arg, obj.body, obj.gift_mode, true);
            };
            if (!queue.length){
                queue_is_processing = false;
                return;
            };
            queue_is_processing = true;
            var map_obj:MapObject = queue[0].map_obj;
            map_obj.process();
            var x:Number = map_obj.preload_position(queue[0].channel).x;
            var y:Number = map_obj.preload_position(queue[0].channel).y;
            sendNotification(ApplicationFacade.SHOW_PROCESS_LOADER, {
                action:queue[0].action,
                delay:1,
                x:x,
                y:y
            });
        }
        
        /**
         * 这个可能在好友翻页的时候会使用到的 
         */ 
        public function neighbors_loaded(data:Object):void{
            var obj:Object;
            if (!data){
                return;
            };
            Algo.convert_to_number(data);
            var list:Array = new Array();
            for each (obj in data.neighbors) {
                app_data.neighbors.push(obj);
                list.push(prep_neighbor_data(obj));
            };
            sendNotification(ApplicationFacade.NEIGHBORS_LOADED, list);
        }
        
        /**
         * 购买商品 
         */ 
        public function buy_item(id:Number):Boolean{
            var item:Object = get_item_data(id);
            switch (item.type){
                case "expand_ranch":
                    expand_ranch(item);
                    app_data.coins = (app_data.coins - parseFloat(item.price));
                    confirm = new Confirmation(0, -(item.price));
                    update_objects(["coins"]);
                    break;
            };
            return (true);
        }
        
        private function add_object_action(obj:Object):String{
            if (obj.type == "soil"){
                return "Plowing";
            };
            return "Loading";
        }
        
        private function get_store_constructible_objects(material:Number):Array{
            var id:String;
            var info:Object;
            var list:Array = new Array();
            for (id in config.store) {
                info = config.store[id];
                if (info.constructible){
                    if (has_material(info, material)){
                        list.push(info);
                    };
                };
            };
            return (list);
        }
        
        
        public function save_selected_raw_material(index:Number, id:Number, x:Number, y:Number):void{
            var index:* = index;
            var id:* = id;
            var x:* = x;
            var y:* = y;
            if (!shared_object){
                return;
            };
            shared_object.data[((((("obj" + id) + "_") + x) + "_") + y)] = index;
            try {
                shared_object.flush();
            } catch(e:Error) {
                Log.add(("flush error " + e));
            };
        }
        
        
        private function count_sprinklers():Number{
            var obj:Object;
            var obj_info:Object;
            var c:Number = 0;
            var i:Number = 0;
            while (i < app_data.map.length) {
                obj = app_data.map[i];
                obj_info = config.store[obj.id];
                if (obj.water_pipe){
                    c++;
                };
                i++;
            };
            return (c);
        }
        
        
        public function autocollect_product(obj:MapObject, body:TransactionBody, show_preloader:Boolean=true):Boolean{
            var x:Number;
            var y:Number;
            var data:Object;
            var note:Notification;
            var queue:Array;
            var item:Object = get_map_obj(obj.id, obj.grid_x, obj.grid_y);
            var pid:String = ("collect_" + obj.map_unique_id);
            if (!(auto_queue[pid] as Array)){
                auto_queue[pid] = new Array();
            };
            if (app_data.op <= 0){
                return (false);
            };
            if (item.is_multi){
                if ((item.products.length - auto_queue[pid].length) <= 0){
                    return (false);
                };
            } else {
                if ((item.products - auto_queue[pid].length) <= 0){
                    return (false);
                };
            };
            if (show_preloader){
                x = obj.preload_position("collect").x;
                y = obj.preload_position("collect").y;
                data = {
                    method:"autocollect_product",
                    args:[obj, body, false]
                };
                note = new Notification(ApplicationFacade.SHOW_PROCESS_LOADER, {
                    action:"Collecting",
                    delay:1,
                    x:x,
                    y:y,
                    auto_mode:true,
                    pid:pid
                });
                queue = auto_queue[pid];
                queue.push({
                    data:data,
                    note:note
                });
                if (queue.length == 1){
                    sendNotification(note.getName(), note.getBody());
                };
                return (false);
            };
            return (collect_product(obj, body, false, true));
        }
        
        
        private function prep_neighbor_data(obj:Object, full_name:Boolean=false):Object{
            if (((fb_data) && (fb_data[obj.uid]))){
                obj.name = (full_name) ? fb_data[obj.uid].name : fb_data[obj.uid].first_name;
                obj.pic = fb_data[obj.uid].pic_square;
            };
            if (!obj.name){
                obj.name = ResourceManager.getInstance().getString("message","no_name_message");;
            };
            if (!obj.pic){
                obj.pic = no_pic_url();
            };
            return (obj);
        }
        
        
        private function has_material(obj:Object, id:Number):Boolean{
            var i:Number = 0;
            while (i < obj.materials.length) {
                if (obj.materials[i].id == id){
                    return (true);
                };
                i++;
            };
            return (false);
        }
        
        public function show_gifts_popup_displayed():void{
            app_data.show_gifts_page = false;
        }
        
        public function get_network_delay_popup_data():String{
             return ResourceManager.getInstance().getString("message","connect_server_error");
        }
        
        public function add_plant(obj:Object, body:TransactionBody, gift_mode:Boolean=false, queue_call:Boolean=false):Boolean{
            var soil:MapObject;
            var plant:CollectObject;
            var item:Object;
            var map_obj:Object;
            var water_pipe:Object;
            if (!queue_call){
                add_to_queue("add_plant", obj, obj.soil, "Planting", "normal", body);
            } else {
                soil = (obj.soil as MapObject);
                plant = (obj.plant as CollectObject);
                item = config.store[plant.id];
                if (app_data.coins < item.price){
                    return (report_confirm_error(Err.NO_COINS));
                };
                plant.map_x = soil.grid_x;
                plant.map_y = soil.grid_y;
                app_data.coins = (app_data.coins - parseFloat(item.price));
                app_data.experience = (app_data.experience + item.exp);
                remove_map_obj(soil.id, soil.map_x, soil.map_y);
                map_obj = {
                    id:plant.id,
                    x:soil.grid_x,
                    y:soil.grid_y,
                    start_time:Algo.time()
                };
                if (soil.has_irrigation()){
                    map_obj.water_pipe = soil.get_water_pipe();
                };
                app_data.map.push(map_obj);
                confirm = new Confirmation(item.exp, -(item.price));
                refresh_level();
                confirm.set_target(soil);
                update_objects(["level", "coins"]);
                plant.grid_x = plant.map_x;
                plant.grid_y = plant.map_y;
                plant.start();
                if (soil.has_irrigation()){
                    water_pipe = config.store[soil.get_water_pipe()];
                    plant.install_irrigation({
                        growing_percent:water_pipe.growing_percent,
                        id:water_pipe.id,
                        image:(("images/" + water_pipe.url) + "_obj.png")
                    });
                };
                soil.parent.removeChild(soil);
                sendNotification(ApplicationFacade.MAP_ADD_OBJECT, plant);
                transaction_proxy.set_data_hash(data_hash);
                transaction_proxy.add(body, true);
                return (true);
            }
            return false;
        }
        
        private function feed_object_action(obj:Object):String{
            if (obj.type == "animals" || obj.kind == "chicken_coop"){
                return "Feeding";
            }
            return "Refilling";// 蓄水的意思
        }
        
        /**
         * 把礼物兑换成gift 
         */ 
        public function trade_gift(id:Number, x:Number=-1, y:Number=-1):Boolean{
            var info:Object = get_item_data(id);
            var op_refilled:Boolean = (app_data.op == 0);
            var op:Number = info.trade_for;
            app_data.op = (app_data.op + op);
            if (op_refilled){
                sendNotification(ApplicationFacade.CHECK_AUTOMATION, "op_refill");
            };
            confirm = new Confirmation();
            confirm.add_value(op, " OP");
            var currentGift:int = (app_data.gifts[id] - 1);
            app_data.gifts[id] = currentGift;
            update_objects(["operations", "gifts"]);
            return (true);
        }
        
        /**
         * 添加小动物 
         * 分2种情况,一种是通过礼物送出来的
         */ 
        public function add_animal(obj:MapObject):Boolean{
            var item:Object = get_map_obj(obj.id, obj.grid_x, obj.grid_y);
            var info:Object = config.store[obj.id];
            var animal:Object = config.store[info.animal];
            if (((!(gift_mode)) && ((animal.price > app_data.coins)))){
                return (report_error(Err.NO_COINS));
            };
            if (item.animals == info.max_animals){
            	return (report_confirm_error(ResourceManager.getInstance().getString("message","buy_another_message",[info.name]), true));
            };
            obj_add_animal(item);
            var was_gift:Boolean = gift_mode;
            if (!gift_mode){
                app_data.coins = (app_data.coins - parseFloat(animal.price));
                app_data.experience = (app_data.experience + animal.exp);
                refresh_level();
                confirm = new Confirmation(animal.exp, -(animal.price));
                update_objects(["coins", "level"]);
            } else {
                var _local6 = app_data.gifts;
                var _local7 = animal.id;
                var _local8 = (_local6[_local7] - 1);
                _local6[_local7] = _local8;
                update_objects(["gifts"]);
                gift_mode = false;
            };
            sendNotification(ApplicationFacade.ANIMAL_ADDED, was_gift);
            return (true);
        }
        
        /**
         * 获取地上种的作物的状态 
         */ 
        private function get_plant_state(id:Number):String{
            var obj:Object;
            var state:String = "none";
            var i:Number = 0;
            while (i < app_data.map.length) {
                obj = app_data.map[i];
                update_object(obj);
                if (obj.id == id){
                    if ((obj.start_time + obj.collect_in) < Algo.time()){// 已经成熟了
                        return "grown";
                    }
                    state = "growing";
                }
                i++;
            }
            return state;
        }
        
        
        public function get_selected_raw_material(id:Number, x:Number, y:Number):Number{
            if (!shared_object){
                return (0);
            };
            if (shared_object.size == 0){
                return (0);
            };
            return (shared_object.data[((((("obj" + id) + "_") + x) + "_") + y)]);
        }
        
        /**
         * 刷新的一个页面 
         */ 
        public function show_refresh_page_popup(msg:String="", code:Number=0):void{
            if (msg == ""){
                msg = Err.REFRESH_PAGE;
            };
            if (code){
                msg = (msg + ((" \n(error code " + code) + ")"));
            };
            sendNotification(ApplicationFacade.SHOW_REFRESH_PAGE_POPUP, msg);
        }
        
        /**
         * 是否正在工作 
         */ 
        private function obj_is_working(o:Object):Boolean{
            update_object(o);
            return ((o.start_time > 0));
        }
        
        /**
         * 获取解锁的数据 
         */ 
        private function get_unlocked_items():Object{
            var item:Object;
            var can_buy:Array = new Array();
            var can_gift:Array = new Array();
            for each (item in config.store) {
                if (item.not_in_popup){
                } else {
                    if (item.level == app_data.level){
                        can_buy.push(item.name);
                    };
                    if (item.gift_level == app_data.level){
                        can_gift.push(item.name);
                    };
                };
            };
            return ({
                can_gift:can_gift.join(", "),
                can_buy:can_buy.join(", ")
            });
        }
        
        public function add_lottery_coins():void{
            confirm = new Confirmation(0, app_data.lottery_coins);
            app_data.coins = (app_data.coins + parseFloat(app_data.lottery_coins));
            update_objects(["coins"]);
        }
        
        /**
         * 卖出商量里的所有物品 
         */ 
        public function sell_all_storage():Boolean{
            var item:String;
            var info:Object;
            var c:Number = 0;
            for (item in app_data.storage) {
                info = config.store[item];
                c = (c + (app_data.storage[item] * info.sell_for));
            };
            app_data.coins = (app_data.coins + c);
            confirm = new Confirmation(0, c);
            app_data.storage = new Array();
            update_objects(["coins", "storage"]);
            return (true);
        }
        
        /**
         * 用户的好友列表 
         */ 
        public function get_neighbors_data():Object{
            var obj:Object;
            var i:Number;
            if (!(app_data.neighbors as Array)){
                return (new Array());
            };
            var all:Array = app_data.all_neighbors;
            var output:Array = new Array();
            var neighbors:Array = new Array();
            for each (obj in app_data.neighbors) {
                output[obj.uid] = obj;
                neighbors.push(prep_neighbor_data(obj));
            };
            i = 0;
            while (i < all.length) {
                if (!output[all[i]]){
                    obj = new Object();
                    obj.uid = all[i];
                    obj.not_loaded = true;
                    output[all[i]] = obj;
                    neighbors.push(obj);
                };
                i++;
            };
            return (neighbors);
        }
        
        private function get_objects_who_use(material:Number, need:Boolean=false):Array{
            var obj:Object;
            var info:Object;
            var list:Array = new Array();
            var i:Number = 0;
            for (;i < app_data.map.length;i++) {
                obj = app_data.map[i];
                info = config.store[obj.id];
                update_object(obj);
                if (!info.constructible){
                } else {
                    if (!has_material(info, material)){
                    } else {
                        if (need){
                            if (((((info.upgradeable) && (!(obj.under_construction)))) && (!(can_upgrade(obj))))){
                                continue;
                            };
                            if (((!(info.upgradeable)) && (!(obj.under_construction)))){
                                continue;
                            };
                            if (obj.obtained_materials[material] < get_material_qty(obj, material)){
                                list.push(obj);
                            };
                        } else {
                            list.push(obj);
                        };
                    };
                };
            };
            return (list);
        }
        
        
        public function show_gifts_popup(item:Number):void{
            if (!app_data.gifts[item]){
                sendNotification(ApplicationFacade.DISPLAY_SHOP, item);
            } else {
                sendNotification(ApplicationFacade.DISPLAY_GIFTS, item);
            };
        }
        
        /**
         * 是否能使用礼物,
         * 这个功能暂时还没有加上
         */ 
        public function can_use_gift(id:Number):Boolean{
            var info:Object = config.store[id];
            if (info.action == "construction"){
                return (can_use_material(id));
            };
            if (info.action == "irrigation"){
                if (!can_install_irrigation(info.id)){
                    return (false);
                };
            };
            return (true);
        }
        
        /**
         * 这个应该是请求好友的数据过来时的操作
         */ 
        public function handle_response(r:Object, channel:String):void{
            var prop:* = null;
            var r:* = r;
            var channel:* = channel;
            Algo.convert_to_number(r);
            if (r.error){
                on_error(channel);
                clear_process_queue();
                sendNotification(ApplicationFacade.CANCEL_PROCESS_LOADER);
                Log.add(("data hash " + r.data_hash));
                if (r.error == Err.SWF_VERSION){
                    show_refresh_page_popup(Err.GAME_UPDATED);
                } else {
                    show_refresh_page_popup("", r.error);
                };
                return;
            };
            if (r.base_url){
                Cache.base_url = r.base_url;
            };
            var names:* = new Array();
            for (prop in r) {
                app_data[prop] = r[prop];
                names.push(prop);
            };
            if (r.level_up){
                app_data.coins = (app_data.coins + parseFloat(r.level_up.coins));
                app_data.reward_points = (app_data.reward_points + r.level_up.rp);
                sendNotification(ApplicationFacade.SHOW_LEVEL_UP_POPUP);
                names.push("coins");
                names.push("reward_points");
            };
            if (r.objects_to_update){
                names.push("objects_to_update");
            };
            if (r.farm){
                if (r.farm.uid == user_id){
                    app_data.map = r.farm.map;
                    sendNotification(ApplicationFacade.SET_TOOLBAR_NORMAL_MODE);
                    sendNotification(ApplicationFacade.BACK_TO_MY_RANCH);
                } else {
                    sendNotification(ApplicationFacade.SHOW_FARM);
                };
            } else {
                update_objects(names);
            };
            if (r.feed_data){
                last_post_tag = r.feed_data.tag;
                last_post_subtype = r.feed_data.subtype;
            };
            if (channel == "load_farm"){
                sendNotification(ApplicationFacade.HIDE_OVERLAY);
                if (app_data.farm.uid != user_id){
                    sendNotification(ApplicationFacade.HIDE_OVERLAY);
                    if (((((!(app_data.farm.helped)) && (app_data.farm.has_app))) && ((friends_helped.indexOf(app_data.farm.uid) == -1)))){
                        cancel_help_popup();
                        show_help_popup_interval = setTimeout(function (){
                            sendNotification(ApplicationFacade.SHOW_HELP_POPUP);
                        }, 2500);
                    };
                };
            };
        }
        
        
        public function update_plant(plant:Plant):void{
            var obj:Object = get_map_obj(plant.id, plant.map_x, plant.map_y);
            if(!obj)return;
            var details:Object = plant.get_details();
            obj.start_time = details.start_time;
            obj.grown_percent = details.grown_percent;
            obj.current_collect_in = details.current_collect_in;
            obj.has_greenhouse = details.has_greenhouse;
        }
        
        
        public function get_map_data():Object{
            var item:Object;
            var obj:Object;
            var output:Object = new Object();
            output.size_x = app_data.size_x;
            output.size_y = app_data.size_y;
            output.top_map_size = app_data.top_map_size;
            output.bottom_map_size = app_data.bottom_map_size;
            output.objects = new Array();
            for each (item in app_data.map) {
                obj = get_item_data(item.id);
                if (!obj){
                } else {
                    Algo.merge(obj, Algo.clone(item));
                    if (obj.is_multi){
                        obj.selected_raw_material = get_selected_raw_material(obj.id, obj.x, obj.y);
                    };
                    if (obj.water_pipe){
                        obj.water_pipe_url = (("images/" + config.store[obj.water_pipe].url) + "_obj.png");
                        obj.water_pipe_growing_percent = config.store[obj.water_pipe].growing_percent;
                    };
                    output.objects.push(obj);
                };
            };
            return (output);
        }
        
        
        public function get_neighbors_list_popup_data():Object{
            var o:Object;
            var output:Object = new Object();
            output.list = new Array();
            var i:Number = 0;
            while (i < app_data.all_neighbors.length) {
                o = prep_neighbor_data({uid:app_data.all_neighbors[i]}, true);
                o.image = o.pic;
                o.title_txt = o.name;
                o.id = o.uid;
                output.list.push(o);
                i++;
            };
            return (output);
        }
        
        /**
         * 这个方法可能是没有任何用的，这里config不可能是取到的，因为数据还没有请求呢
         */ 
        public function game_objects_created():void{
            objects_created = true;
            if (((config) && (app_data))){
                init(config, app_data);
            };
        }
        
        /**
         * 获取好友家农场的数据 
         * pic_square 是用户的图片
         */ 
        public function get_friend_farm_data():Object{
            var item:Object;
            var obj:Object;
            var output:Object = new Object();
            output.size_x = app_data.farm.size_x;
            output.size_y = app_data.farm.size_y;
            output.name = friend_name;
            output.top_map_size = app_data.farm.top_map_size;
            output.bottom_map_size = app_data.farm.bottom_map_size;
            if (fb_data[app_data.farm_uid]){
                output.pic = ((fb_data[app_data.farm.uid].pic_square)=="") ? no_pic_url() : fb_data[app_data.farm.uid].pic_square;
            } else {
                output.pic = no_pic_url();// 如果没有用户的图片，那就是使用默认的数据
            };
            output.objects = new Array();
            for each (item in app_data.farm.map) {
                obj = get_item_data(item.id);
                if (!obj){
                } else {
                    Algo.merge(obj, item);// 把用户的数据，和返回的数据进行合并，一个是config里的，一个是数据库返回的
                    if (obj.water_pipe){
                        obj.water_pipe_url = (("images/" + config.store[obj.water_pipe].url) + "_obj.png");
                        obj.water_pipe_growing_percent = config.store[obj.water_pipe].growing_percent;
                    };
                    output.objects.push(obj);
                };
            };
            return (output);
        }
        
        /**
         * 一个加密的数据,这个具体加密的方法我还没有搞清楚 
         */
        public function get data_hash():String{
            return (app_data.data_hash);
        }
        
        /**
         * 获取用户名称 
         */ 
        public function get user_name():String{
            if (!fb_data){
                return ("");
            }
            if (!fb_data[user_id]){
                return ("");
            }
            var userInfo:Object = JSDataManager.getInstance().getUserInfoById(user_id);
            if(userInfo){
            	return userInfo.name;// 应该是通过这里来使用
            }
            return (fb_data[user_id].first_name);
        }
        
        
        public function send_gift(data:Object):Boolean{
            var info:Object = config.store[data.gift];
            if ((((info.rp_price > 0)) && ((app_data.reward_points < info.rp_price)))){
                sendNotification(ApplicationFacade.SHOW_CONFIRM_POPUP, {
                    msg:Err.NO_RP,
                    obj:{
                        notif:ApplicationFacade.NAVIGATE_TO_URL,
                        data:"offers"
                    }
                });
                return (false);
            };
            last_sent_gift_data = data;
            app_data.reward_points = (app_data.reward_points - info.rp_price);
            update_objects(["reward_points"]);
            var _data:Object = new Object();
            _data.message = ResourceManager.getInstance().getString("message","advice_friend");
            _data.type = PopupTypes.PUBLISH_GIFT_SENT_STORY;
            _data.ok_label = ResourceManager.getInstance().getString("message","share_label");
            _data.close_label = ResourceManager.getInstance().getString("message","close_label");
            _data.data = {neighbor:data.neighbor};
            sendNotification(ApplicationFacade.SHOW_POPUP, _data);
            return (true);
        }
        
        /**
         * 这里是set fb_data的数据 
         */ 
        public function set_fb_data(data:Object):void{
            if (data){
                fb_data = data;
            };
            if (already_init){
                update_objects(["neighbors", "name"]);
            };
        }
        public function get friend_name():String{
            if (!fb_data){
                return ("");
            };
            if (!fb_data[app_data.farm.uid]){
                return ("");
            };
            return (fb_data[app_data.farm.uid].first_name);
        }
        
        /**
         * 提供了一个引性的方法,把没有的数据都增加进来然后更新成默认的值 
         */ 
        private function update_object(o:Object):void{
            var i:Number;
            var info:Object = config.store[o.id];
            if (((info.upgradeable) && (!(o.upgrade_level)))){
                o.upgrade_level = 1;
            };
            if (!o.flipped){
                o.flipped = 0;
            };
            if (((info.constructible) && (!(o.obtained_materials)))){
                o.obtained_materials = new Array();
            };
            if (info.constructible){
                i = 0;
                while (i < info.materials.length) {
                    if (o.obtained_materials[info.materials[i].id] === undefined){
                        o.obtained_materials[info.materials[i].id] = 0;
                    };
                    i++;
                };
            };
            if (is_multi(o)){
                return (update_multi_object(o));
            };
            if (o.raw_materials === undefined){
                o.raw_materials = 0;
            };
            if (o.products === undefined){
                o.products = 0;
            };
            if (o.start_time === undefined){
                o.start_time = 0;
            };
            var collect_in:Number = info.collect_in;
            o.collect_in = info.collect_in;
            if ((((info.type == "seeds")) || ((info.type == "trees")))){
                return;
            };
            if (info.need_animals){
                if (!o.animals){
                    o.animals = 1;
                };
                collect_in = (collect_in / o.animals);
            };
            if (!o.times_used){
                o.times_used = 0;
            };
            o.collect_in = collect_in;
            if (!o.start_time){
                return;
            };
            if (o.updated_start_time){
                if ((((o.raw_materials > 0)) && ((o.products < 3)))){
                    o.start_time = o.updated_start_time;
                    o.updated_start_time = 0;
                };
            };
            var n:Number = Math.min((3 - o.products), Math.min(o.raw_materials, Math.floor(((Algo.time() - o.start_time) / collect_in))));
            if (n < 0){
                n = 0;
            };
            o.products = (o.products + n);
            o.raw_materials = (o.raw_materials - n);
            o.start_time = (o.start_time + (collect_in * n));
            if ((((o.raw_materials == 0)) || ((o.products == 3)))){
                o.start_time = 0;
            };
        }
        
        /**
         * 这个 ?
         */ 
        public function refresh_data(data:Object):void{
            app_data = data;
            update_objects();
            cancel_help_popup();
            clear_process_queue();
            sendNotification(ApplicationFacade.CANCEL_PROCESS_LOADER);
        }
        
        
        public function water_plants():Boolean{
            app_data.farm.show_help_popup = false;
            app_data.coins = (app_data.coins + parseFloat(app_data.farm.help_coins));
            app_data.experience = (app_data.experience + app_data.farm.help_xp);
            refresh_level();
            confirm = new Confirmation(app_data.farm.help_xp, app_data.farm.help_coins);
            update_objects(["coins", "level"]);
            friends_helped.push(app_data.farm.uid);
            return (true);
        }
        
        public function get post_tag():String{
            return (last_post_tag);
        }
        
        /**
         * 反向 
         */ 
        public function flip_map_object(obj:MapObject):Boolean{
            var map_obj:Object = get_map_obj(obj.id, obj.grid_x, obj.grid_y);
            if (map_obj.flipped){
                map_obj.flipped = 0;
            } else {
                map_obj.flipped = 1;
            };
            return true;
        }
        
        public function get_accept_selected_gift_popup_data(neighbor_id:Number, gift_id:Number):Object{
            var output:Object = new Object();
            var gift:String = config.store[gift_id].name;
            var neighbor:String = prep_neighbor_data({uid:neighbor_id}, true).name;
            var rc:String = String(config.store[gift_id].rp_price);
            var s:String = ResourceManager.getInstance().getString("message","send_notice_message",[Algo.articulate(gift).toString(),neighbor]);
            s = (s + ResourceManager.getInstance().getString("message","ranch_count_message",[rc]));
            output.type = PopupTypes.ACCEPT_SELECTED_GIFT;
            output.message = s;
            output.width = 450;
            output.height = 250;
            output.inner_width = 350;
            output.inner_height = 160;
            return (output);
        }
        
        private function obj_decrease_product(o:Object):void{
            var materials:Number;
            update_object(o);
            if (!is_multi(o)){
                o.products--;
                materials = o.raw_materials;
            } else {
                o.products.pop();
                materials = num_complete_raw_materials(o);
            };
            if (((materials) && (!(obj_is_working(o))))){
                obj_start(o);
            };
        }
        
        /**
         * 购买物品的整个判断逻辑 
         * 1.先判断商品的price是否大于0,并且用户的coins是否小于商品的price,则金币不购
         * 2.如果rp_price > 0,并且reward_points < info_rp_price,则rp不购
         * 3.判断商品的类型,expand_ranch分为2种,一种是扩地,一种是扩大top_size,在map_can_expand这个方法里
         * 4.如果是建筑物的话,具体看can_use_material这个方法
         */ 
        public function can_buy(id:Number):Boolean{
            var info:Object;
            var _local3:Object;
            var list:Array;
            info = config.store[id];
            if ((((info.price > 0)) && ((app_data.coins < info.price)))){
                return (report_error(Err.NO_COINS));
            };
            if ((((info.rp_price > 0)) && ((app_data.reward_points < info.rp_price)))){
                sendNotification(ApplicationFacade.SHOW_CONFIRM_POPUP, {
                    msg:Err.NO_RP,
                    obj:{
                        notif:ApplicationFacade.NAVIGATE_TO_URL,
                        data:"offers"
                    }
                });
                return (false);
            };
            switch (info.type){
                case "expand_ranch":
                    _local3 = map_can_expand(info);
                    if (info.action == "expand"){
                        if (!_local3.result){
                            return (report_error(Algo.sprintf(Err.EXPAND_LEVEL_TOO_BIG, ((_local3.size + "x") + _local3.size))));
                        };
                    } else {
                        if (!_local3.result){
                            return (report_error(Algo.sprintf(Err.EXPAND_YARD_LEVEL_TOO_BIG, _local3.name)));
                        };
                    };
                    break;
            };
            if (info.action == "construction"){// 这个先过掉，我们暂时没有buliding的功能
                return (can_use_material(id));
            };
            if (info.max_instances){// 这个值我目前没看到在哪用
                list = get_objects_like(info.id);
                if (list.length == info.max_instances){
                    if (can_upgrade(list[0])){
                    	return (report_confirm_error(ResourceManager.getInstance().getString("message","upgrade_notice_message",[Algo.articulate(info.name).toString()])));
                    };
                    return (report_confirm_error(ResourceManager.getInstance().getString("message","already_have_items",[Algo.articulate(info.name).toString()])));
                };
            };
            if (((info.constructible) && ((get_objects_like(info.id, true).length == 1)))){
                return (report_confirm_error(((ResourceManager.getInstance().getString("message","finish_construction_on_existing",[info.name])))));
            };
            if (info.action == "irrigation"){// 这个功能暂时也没有先过掉
                if (!can_install_irrigation(info.id)){
                    return (false);
                };
            };
            return (true);
        }
        
        /**
         * 
         */ 
        public function get_items_received_data():Object{
            var info:Object;
            var item:Object;
            var data:Object = new Object();
            data.list = new Array();
            var names:Array = new Array();
            var i:Number = 0;
            while (i < app_data.items_received.length) {
                info = config.store[app_data.items_received[i]];
                if (!info){
                } else {
                    item = new Object();
                    item.image = (("images/" + info.url) + ".png");// 这个图片的地址有点雷
                    data.list.push(item);
                    names.push(Algo.articulate(info.name));
                }
                i++;
            }
            data.message = ResourceManager.getInstance().getString("message","friends_helpe_mount",[Algo.enumerate(names)]);
            return data;
        }
        
        
        public function get_select_object_popup_data(list:Array, m:Object):Object{
            var info:Object;
            var p:Object;
            var output:Object = new Object();
            output.caption = ResourceManager.getInstance().getString("message","select_where_use",[m.name]);
            output.list = new Array();
            var i:Number = 0;
            while (i < list.length) {
                info = config.store[list[i].id];
                p = new Object();
                p.url = (("images/" + info.url) + "_uc.png");
                p.enabled = true;
                p.name = info.name;
                p.object = list[i];
                p.material = m.id;
                output.list.push(p);
                i++;
            };
            output.image_size = 64;
            return (output);
        }
        
        /**
         * 
         */ 
        public function get_sell_price(id:Number, x:Number, y:Number):Number{
            var animal:Object;
            var info:Object = config.store[id];
            if (!info.sell_price){
                return (0);
            }
            var price:Number = info.sell_price;
            var obj:Object = get_map_obj(id, x, y);
            if (info.need_animals){
                animal = config.store[info.animal];
                price = (price + (obj.animals * animal.sell_price));
            }
            return price;
        }
        
        public function on_error(value:String):void{
            if (value == "water_plants"){
                friends_helped = new Array();
            }
        }
        
        private function obj_add_animal(o:Object):void{
            o.animals++;
            update_object(o);
        }
        
        /**
         * 获取商店里的数据,
         * 有几个数据有时可能要隐藏,比如扩展地的 
         */ 
        public function get_shop_data():Array{
            var output:Array;
            var index:Number;
            var tab_name:String;
            var is_new:Boolean;
            var tabs:Object = new Object();
            for each (var item:Object in config.store) {
            	if (item.type == "soil")
                {
                    continue;
                }
                if (item.buyable !== undefined && item.buyable === false)
                {
                    continue;
                }
                if (item.type == "expand_ranch")
                {
                    if (item.action == "expand" && item.size <= app_data.size_x)
                    {
                        continue;
                    }
                    if (item.action == "expand_top_map" && item.size <= app_data.top_map_size)
                    {
                        continue;
                    }
                    if (item.action == "expand_bottom_map" && item.size <= app_data.bottom_map_size)
                    {
                        continue;
                    }
                }
                if (!(tabs[item.type] as Array)){
                    tabs[item.type] = new Array();
                }
                tabs[item.type].push(get_item_data(item.id));
            }
            output = new Array();
            index = 0;
            is_new = false;
            for (var tab:String in tabs) {
            	var resourceName:String = tab + "_type_message";
            	try {
                	tab_name = ResourceManager.getInstance().getString("message",resourceName);
                }catch(error:Error){
                	trace("error name " + resourceName);
                }//types[tab];//Algo.humanize(tab);这里的转化可能有问题的
                //index = config.store_tabs.indexOf(tab);
                index = config.store_tabs.indexOf(tab_name);
                is_new = (config.store_tabs_new.indexOf(tab) > -1);
                /* switch (tab){
                    case "special_events":
                        tab_name = "Fertilizers";
                        break;
                } */
                tabs[tab].sortOn(["store_pos", "level", "id"], Array.NUMERIC);
                output.push({
                    name:tab_name,
                    list:tabs[tab],
                    pos:index,
                    is_new:is_new
                })
            }
            output.sortOn("pos", Array.NUMERIC);
            return output;
        }
        
        /**
         * 获取mapObject的对象 
         */ 
        private function get_map_obj(id:Number, x:Number, y:Number, flipped:Number=-1):Object{
            var obj:Object;
            var i:Number = 0;
            while (i < app_data.map.length) {
                obj = app_data.map[i];
                if ((((((obj.id == id)) && ((obj.x == x)))) && ((obj.y == y)))){
                    update_object(obj);
                    if (((!((flipped == -1))) && (!((obj.flipped == flipped))))){// 如果有转向,并且方向相同时才会执行
                    } else {
                        return (obj);
                    };
                };
                i++;
            }
            return (null);
        }
        
        public function can_close_shop(id:Number):Boolean{
            var info:Object = config.store[id];
            if (info.action == "construction"){
                return (false);
            }
            return (true);
        }
        
        /**
         * 根据id获取item的数据 
         */ 
        public function get_item_data(id:Number):Object{
            var product:Object;
            var k:Number;
            var prod_info:Object;
            var s:*;
            var obj:Object = Algo.clone(config.store[id]);
            if (!obj){
                return (null);
            };
            if (obj.constructible){
                obj.swf_uc = (("assets/swf/" + obj.url) + "_uc.swf");
                obj.image_uc = (("images/" + obj.url) + "_uc.png");
                obj.under_construction = true;
            };
            if (obj.map_object){
                obj.swf = (("assets/swf/" + obj.url) + ".swf");
            };
            if (obj.kind == "fertilizer"){
                obj.image = (((("images/" + obj.url) + "_") + obj.uses) + ".png");
            } else {
                obj.image = (("images/" + obj.url) + ".png");
            };
            obj.cursor = (("images/" + obj.url) + "_cur.png");
            if (obj.action == "irrigation"){
                obj.image_obj = (("images/" + obj.url) + "_obj.png");
            };
            if (obj.collect_in){
                if (!obj.is_multi){
                    product = config.store[obj.product];
                    if(product) {
	                    obj.sell_for = product.sell_for;
	                    obj.product_name = product.name;
	                    if (obj.raw_material){
	                        obj.raw_material_name = config.store[obj.raw_material].name;
	                    }
                    }
                } else {
                    obj.product_names = new Array();
                    k = 0;
                    while (k < obj.product.length) {
                        prod_info = config.store[obj.product[k]];
                        if(!prod_info)break;
                        obj.product_names[obj.product[k]] = prod_info.name;
                        if (obj.product.length == 1){
                            obj.sell_for = prod_info.sell_for;
                        };
                        k++;
                    };
                    obj.raw_material_names = new Array();
                    k = 0;
                    while (k < obj.raw_material.length) {
                        if ((obj.raw_material[k] as Array)){
                            s = 0;
                            while (s < obj.raw_material[k].length) {
                                obj.raw_material_names[obj.raw_material[k][s]] = config.store[obj.raw_material[k][s]].name;
                                s++;
                            };
                        } else {
                            obj.raw_material_names[obj.raw_material[k]] = config.store[obj.raw_material[k]].name;
                        };
                        k++;
                    };
                };
                if (obj.type == "seeds"){
                    obj.action = "Harvest";
                } else {
                    obj.action = (product) ? product.name : obj.product_name;
                };
            };
            if (obj.rp_price){// 默认的rp_price和price只有一个值
                obj.buy_method = "rp";
            } else {
                obj.buy_method = "coins";
            };
            if (obj.neighbors){// 锁定的一些限制
                Log.add(("neighbors: " + neighbors_count()));
                obj.locked = (neighbors_count() < obj.neighbors);
                
                obj.locked_message = ResourceManager.getInstance().getString("message","locked_message_neighbors",[obj.neighbors]);
                obj.locked_button = "neighbors";
            } else {
                obj.locked = (app_data.level < obj.level);//
                obj.locked_message = (("Level " + obj.level) + " needed");
                obj.locked_button = ResourceManager.getInstance().getString("message","locked_button_buy");
            }
            if (neighbors_count() == 0){
                obj.buy_gift = false;
            }
            return (obj);
        }
        
        
        public function get_gifts_data():Array{
            var item:String;
            var info:Object;
            var output:Array = new Array();
            for (item in app_data.gifts) {
                if (!app_data.gifts[item]){
                } else {
                    info = get_item_data(int(item));
                    info.qty = app_data.gifts[item];
                    if (info.type == "products"){
                        info.image = (("images/" + info.url) + "_fg.png");
                    };
                    output.push(info);
                };
            };
            return (output);
        }
        
        
        public function get_story_popup_data():Object{
            if (!app_data.stories.length){
                return (null);
            };
            var data:Object = Algo.clone(app_data.stories[0]);
            data.image = (("images/stories/" + data.image) + ".png");
            return data;
        }
        
        /**
         * 发送feed的提示 
         */ 
        public function show_ask_for_materials_feed_dialog(id:Number):void{
            var story:String;
            var mat_info:Object = config.store[id];
            var obj_info:Object = config.store[map_object_to_use.id];
            var upgrade_level:Number = 1;
            if (mat_info.story){
                story = mat_info.story;
            } else {
                //story = (mat_info.giftable) ? "share_materials" : "help_friend";
                story = (mat_info.giftable) ? "send_materials" : "help_friend";
            }
            if (((((obj_info.upgradeable) && (!(map_object_to_use.is_under_construction())))) && (has_material(obj_info, id)))){
                story = (story + "_upgrade");
                upgrade_level = (map_object_to_use.get_upgrade_level() + 1);
            };
            var info:Object = config.story_patterns[story];
            var tag:String = Algo.generate_tag();
            var href:String = app_url;
            if (mat_info.giftable){
                href = (href + "gifts");
            };
            href = (href + ((((((((((((("?from=stream&story=" + story) + "&recipient=") + user_id) + "&kind=") + id) + "&tag=") + tag) + "&ts=") + config.post_ts) + "&key=") + config.post_key) + "&sig=") + config.post_sig));
            var feed_data:Object = new Object();
            var attachment:Object = new Object();
            feed_data.tag = tag;
            feed_data.subtype = story;
            attachment.name = Algo.replace(info.name, ["%s", "{actor}", "%l"], [Algo.articulate(obj_info.name), user_name, upgrade_level]);
            attachment.description = Algo.replace(info.description, ["%s", "%m", "{actor}", "%l"], [Algo.articulate(obj_info.name), mat_info.name, user_name, upgrade_level]);
            var src:String = Config.getConfig("host") + "images/stories/" + config.store[id].url + ".png";
            var action_link:String = Algo.replace(info.action_link, ["{actor}"], [user_name]);
            Log.add(("image src " + src));
            attachment.media = [{
                href:href,
                src:src,
                type:"image"
            }];
            feed_data.action_links = [{
                text:action_link,
                href:href
            }];
            feed_data.attachment = attachment;
            feed_data.target = obj_info.id;
            show_feed_dialog(feed_data);
        }
        
        public function last_data():Object{
            return (Algo.clone(last_app_data));
        }
        
        public function autorefill(obj:MapObject, body:TransactionBody, show_preloader:Boolean=true, material:Number=0):Boolean{
            var food_info:Object;
            var raw_material:Number;
            var x:Number;
            var y:Number;
            var pid:String;
            var data:Object;
            var queue:Array;
            var note:Notification;
            var j:Number;
            var total_exp:Number;
            var p:Object;
            var info:Object = config.store[obj.id];
            var obj_fed:Object = get_map_obj(obj.id, obj.grid_x, obj.grid_y);
            if (app_data.op <= 0){
                return (false);
            };
            if (!info.is_multi){
                if (!app_data.storage[info.raw_material]){
                    return (false);
                };
                if (obj_fed.raw_materials == 3){
                    return (false);
                };
                food_info = config.store[info.raw_material];
            };
            if (show_preloader){
                data = {
                    method:"autorefill",
                    args:[obj, body, false]
                };
                if (!info.is_multi){
                    x = obj.preload_position("feed").x;
                    y = obj.preload_position("feed").y;
                    pid = ("refill_" + obj.map_unique_id);
                    note = new Notification(ApplicationFacade.SHOW_PROCESS_LOADER, {
                        action:feed_object_action(info),
                        delay:1,
                        x:x,
                        y:y,
                        auto_mode:true,
                        pid:pid
                    });
                    if (!(auto_queue[pid] as Array)){
                        auto_queue[pid] = new Array();
                    };
                    queue = auto_queue[pid];
                    if ((app_data.storage[info.raw_material] - queue.length) <= 0){
                        return (false);
                    };
                    if ((obj_fed.raw_materials + queue.length) == 3){
                        return (false);
                    };
                    queue.push({
                        data:data,
                        note:note
                    });
                    if (queue.length == 1){
                        sendNotification(note.getName(), note.getBody());
                    };
                } else {
                    j = 0;
                    while (j < info.raw_material.length) {
                        raw_material = MultiProcessor(obj).get_raw_material_id((j + 1));
                        if (!app_data.storage[raw_material]){
                        } else {
                            data = {
                                method:"autorefill",
                                args:[obj, body, false, (j + 1)]
                            };
                            x = obj.preload_position(("feed" + (j + 1))).x;
                            y = obj.preload_position(("feed" + (j + 1))).y;
                            pid = ((("refill_" + j) + "_") + obj.map_unique_id);
                            note = new Notification(ApplicationFacade.SHOW_PROCESS_LOADER, {
                                action:feed_object_action(info),
                                delay:1,
                                x:x,
                                y:y,
                                auto_mode:true,
                                pid:pid
                            });
                            if (!(auto_queue[pid] as Array)){
                                auto_queue[pid] = new Array();
                            };
                            queue = auto_queue[pid];
                            if ((app_data.storage[raw_material] - queue.length) <= 0){
                            } else {
                                if ((obj_fed.raw_materials[j].length + queue.length) == 3){
                                } else {
                                    queue.push({
                                        data:data,
                                        note:note
                                    });
                                    if (queue.length == 1){
                                        sendNotification(note.getName(), note.getBody());
                                    };
                                };
                            };
                        };
                        j++;
                    };
                };
            } else {
                if (app_data.op <= 0){
                    return (false);
                };
                if (info.is_multi){
                    total_exp = 0;
                    raw_material = MultiProcessor(obj).get_raw_material_id(material);
                    p = {
                        obj:obj,
                        material:material,
                        raw_material:raw_material
                    };
                    if (!app_data.storage[raw_material]){
                        return (false);
                    };
                    food_info = config.store[raw_material];
                    if (obj_fed.raw_materials[(p.material - 1)].length == 3){
                        return (false);
                    };
                    app_data.experience = (app_data.experience + food_info.exp);
                    var _local18 = app_data.storage;
                    var _local19 = raw_material;
                    var _local20 = (_local18[_local19] - 1);
                    _local18[_local19] = _local20;
                    total_exp = (total_exp + food_info.exp);
                    obj_increase_raw_material(obj_fed, p.material, raw_material);
                    MultiProcessor(obj).refill_with(p.material);
                    body = new RefillMapObjectCall(p);
                    transaction_proxy.set_data_hash(data_hash);
                    transaction_proxy.add(body, true);
                    confirm = new Confirmation(total_exp, 0);
                    confirm.set_coords(obj.preload_position(("feed" + (material + 1))).x, obj.preload_position(("feed" + (material + 1))).y);
                    if (obj_fed.automatic){
                        confirm.add_value(-1, " OP");
                        app_data.op--;
                    };
                    refresh_level();
                    update_objects(["storage", "experience", "operations"]);
                    return (false);
                };
                if (obj_fed.raw_materials == 3){
                    return (false);
                };
                confirm = new Confirmation(food_info.exp, 0);
                confirm.set_coords(obj.preload_position("feed").x, obj.preload_position("feed").y);
                if (obj_fed.automatic){
                    confirm.add_value(-1, " OP");
                    app_data.op--;
                };
                app_data.experience = (app_data.experience + food_info.exp);
                _local18 = app_data.storage;
                _local19 = info.raw_material;
                _local20 = (_local18[_local19] - 1);
                _local18[_local19] = _local20;
                obj_increase_raw_material(obj_fed);
                refresh_level();
                Processor(obj).feed();
                update_objects(["storage", "experience", "operations"]);
                transaction_proxy.set_data_hash(data_hash);
                transaction_proxy.add(body, true);
            };
            return (false);
        }
        
        
        private function queue_search_for_food(product_id:Number):Number{
            var info:Object;
            var qty:Number = 0;
            var i:Number = 0;
            while (i < queue.length) {
                if (queue[i].method == "collect_product"){
                    info = config.store[queue[i].map_obj.id];
                    if (info.product == product_id){
                        qty++;
                    };
                };
                i++;
            };
            return (qty);
        }
        
        /**
         * 客户端的一个更新的方法
         * 整体感觉这样还是不错的 
         * 每次调用这个方法时,会传递几个参数,然后广播一个sendNotification
         * 根据里面传入的值进行判断,然后改变显示的对象
         */ 
        private function update_objects(names:Array=null):void{
            if (!names){
                names = update_fields;
            };
            var update:Object = new Object();
            var i:Number = 0;
            while (i < names.length) {
                update[names[i]] = true;
                i++;
            };
            if (confirm){
                sendNotification(ApplicationFacade.DISPLAY_CONFIRMATION, confirm.get_data());
                if (confirm.level_up){
                    update["shop"] = true;
                };
                confirm = null;
            };
            sendNotification(ApplicationFacade.UPDATE_OBJECTS, update);
        }
        
        
        public function move_map_object(obj:MapObject):Boolean{
            var item:Object = get_map_obj(obj.id, obj.map_x, obj.map_y, obj.map_flip_state);
            obj.map_x = (item.x = obj.grid_x);
            obj.map_y = (item.y = obj.grid_y);
            if (obj.is_flipped()){
                item.flipped = 1;// > 0 的话就反向了
            } else {
                item.flipped = 0;
            };
            obj.map_flip_state = item.flipped;
            sendNotification(ApplicationFacade.MAP_OBJECT_MOVED);
            return (true);
        }
        public function map_can_use_shop_item(id:Number):Boolean{
            var item:Object;
            var _local3:Object;
            var _local4:Boolean;
            var i:Number;
            var obj:Object;
            var data:Object;
            item = get_item_data(id);
            switch (item.type){
                case "animals":
                    _local3 = get_item_data(item.add_on);
                    _local4 = false;
                    i = 0;
                    while (i < app_data.map.length) {
                        obj = app_data.map[i];
                        data = get_item_data(obj.id);
                        if (data.id == _local3.id){
                            _local4 = true;
                            break;
                        };
                        i++;
                    };
                    if (!_local4){
                        return (report_confirm_error((ResourceManager.getInstance().getString("message","you_need",[_local3.name]))));
                    };
                    return (true);
                case "materials":
                    if (item.action == "irrigation"){
                        return (true);
                    };
                    break;
            };
            return (false);
        }
        public function get gifts_qty():Number{
            var qty:Number;
            var q:Number = 0;
            for each (qty in app_data.gifts) {
                q = (q + qty);
            };
            return (q);
        }
        
        public function update_map_objects(objs:Array):void{
            var obj:Object;
            var map_obj:Object;
            for each (obj in objs) {
                map_obj = get_map_obj(obj.id, obj.x, obj.y);
                if ((obj.data.start_time - map_obj.start_time) > map_obj.collect_in){
                    return (show_refresh_page_popup("", Err.TIME_DELAY));
                };
                map_obj.updated_start_time = obj.data.start_time;
            };
        }
        
        private function no_pic_url():String{
            return Config.getConfig("host") + "images/no_pic.png";
        }
        
        public function spend_rp(id:Number, target:Object=null):Boolean{
            var _local5:Boolean;
            var item:Object = get_item_data(id);
            if (item.rp_price > app_data.reward_points){
                return (report_error(Err.NO_RP));
            };
            if (!(app_data.map as Array)){
                return (report_confirm_error(Err.NO_PLANTS));
            };
            confirm = new Confirmation();
            var names:Array = new Array();
            names.push("reward_points");
            switch (item.type){
                case "special_events":
                    switch (item.action){
                        case "rain":
                            if (!apply_rain(item.percent)){
                                return (false);
                            };
                            break;
                    };
                    break;
                case "expand_ranch":
                    expand_ranch(item);
                    confirm = new Confirmation();
                    break;
                case "automation":
                    _local5 = (app_data.op == 0);
                    app_data.op = (app_data.op + item.op);
                    if (_local5){
                        sendNotification(ApplicationFacade.CHECK_AUTOMATION, "op_refill");
                    };
                    names.push("operations");
                    break;
            };
            if (item.action == "construction"){
                if (!use_material(item, target)){
                    return (false);
                }
            }
            app_data.reward_points = (app_data.reward_points - item.rp_price);
            confirm.add_rp(-(item.rp_price));
            update_objects(names);
            return true;
        }
        
        private function add_to_queue(method:String, obj:Object, map_obj:MapObject, action:String="Loading", channel:String="normal", body:TransactionBody=null):void{
            map_obj.wait_to_process(channel);
            queue.push({
                method:method,
                arg:obj,
                map_obj:map_obj,
                gift_mode:gift_mode,
                action:action,
                channel:channel,
                body:body
            });
            if (!queue_is_processing){
                process_queue();
            };
        }
        private function update_multi_object(o:Object):void{
            var j:Number;
            var id:Number;
            var info:Object = config.store[o.id];
            o.is_multi = true;
            if (o.raw_materials === undefined){
                o.raw_materials = new Array();
            };
            var i:Number = 0;
            while (i < info.raw_material.length) {
                if (!(o.raw_materials[i] as Array)){
                    o.raw_materials[i] = new Array();
                };
                i++;
            };
            o.collect_in = info.collect_in;
            if (o.products === undefined){
                o.products = new Array();
            };
            if (o.start_time === undefined){
                o.start_time = 0;
            };
            if (!o.start_time){
                return;
            };
            var materials:* = num_complete_raw_materials(o);
            var n:Number = Math.min((3 - o.products.length), Math.min(materials, Math.floor(((Algo.time() - o.start_time) / o.collect_in))));
            if (n < 0){
                n = 0;
            };
            i = 0;
            while (i < n) {
                j = 0;
                while (j < info.raw_material.length) {
                    id = o.raw_materials[j].shift();
                    if (j == 0){
                        o.products.push(get_product_by_raw_material(id, info));
                    };
                    j++;
                };
                i++;
            };
            o.start_time = (o.start_time + (o.collect_in * n));
            materials = num_complete_raw_materials(o);
            if ((((materials == 0)) || ((o.products.length == 3)))){
                o.start_time = 0;
            };
        }
        
        /**
         * 喂食 
         */ 
        public function feed_map_object(obj:MapObject, body:TransactionBody, gift_mode:Boolean=false, queue_call:Boolean=false):Boolean{
            var msg:String;
            var producer:Object;
            var obj_fed:Object;
            var info:Object = config.store[obj.id];
            var food_info:Object = config.store[info.raw_material];
            if (((queue_call) && (!(app_data.storage[info.raw_material])))){
                obj.clear_process("feed");
                return (false);
            }
            if (((!(app_data.storage[info.raw_material])) && (!(queue_search_for_food(info.raw_material))))){
            	msg = ResourceManager.getInstance().getString("message","no_material_in_barn_message",[config.store[info.raw_material].name]);
                producer = config.store[food_info.producer];
                if (producer.type == "seeds"){
                    switch (get_plant_state(food_info.producer)){
                        case "grown":
                            msg = ResourceManager.getInstance().getString("message","harvest_food_message",[food_info.name]);
                            break;
                        case "growing":
                        	msg = ResourceManager.getInstance().getString("message","wait_for_food_message",[food_info.name]);
                            break;
                        case "none":
                         	msg = ResourceManager.getInstance().getString("message","plant_food_message",[food_info.name]);
                            break;
                    }
                }
                obj.clear_process("feed");
                return (report_confirm_error(msg));
            }
            if (!queue_call){
                add_to_queue("feed_map_object", obj, obj, feed_object_action(info), "feed", body);
            } else {
                obj_fed = get_map_obj(obj.id, obj.grid_x, obj.grid_y);
                if (obj_fed.raw_materials == 3){
                    return (report_confirm_error((info.name + " is full!!!")));
                };
                confirm = new Confirmation(food_info.exp, 0);
                confirm.set_target(obj);
                app_data.experience = (app_data.experience + food_info.exp);
                var storage:Object = app_data.storage;
                var _local11 = info.raw_material;
                var _local12 = (storage[_local11] - 1);
                storage[_local11] = _local12;
                obj_increase_raw_material(obj_fed);
                refresh_level();
                Processor(obj).feed();
                update_objects(["storage", "experience"]);
                transaction_proxy.set_data_hash(data_hash);
                transaction_proxy.add(body, true);
            };
            return (false);
        }
        public function get_friend_helped_popup_data():String{
            var message:String;
            if (!app_data.friend_helped){
                return "";
            }
            message = ResourceManager.getInstance().getString("message","state_message",[app_data.friend_helped.coins,app_data.friend_helped.exp]);
            if (fb_data[app_data.friend_helped.uid]){
                message = message + fb_data[app_data.friend_helped.uid].first_name;
            } else {
                message = message + "your friend";
            }
            return message;
        }
        private function apply_rain(p:Number):Boolean{
            var obj:Object;
            var data:Object;
            var current_collect_in:Number;
            var grown_percent:Number;
            var percent:Number;
            var applied:Boolean;
            if (!confirm){
                confirm = new Confirmation();
            };
            var i:Number = 0;
            while (i < app_data.map.length) {
                obj = app_data.map[i];
                data = get_item_data(obj.id);
                if (data){
                    if ((((data.type == "seeds")) || ((data.type == "trees")))){
                        current_collect_in = (obj.current_collect_in) ? obj.current_collect_in : data.collect_in;
                        grown_percent = (obj.grown_percent) ? obj.grown_percent : 0;
                        percent = (grown_percent + ((Algo.time() - obj.start_time) / current_collect_in));
                        if (((((!(obj.has_greenhouse)) && (obj.start_time))) && ((percent < 1)))){
                            obj.start_time = (obj.start_time - (data.collect_in * p));
                            applied = true;
                        };
                    };
                };
                i++;
            };
            if (!applied){
                return (report_confirm_error(Err.NO_PLANTS));
            };
            sendNotification(ApplicationFacade.START_RAIN, p);
            sendNotification(ApplicationFacade.RAIN_APPLIED, p);
            confirm.text(ResourceManager.getInstance().getString("message","all_plants_flourish"));
            confirm.duration = 5;
            return (true);
        }
        private function get_achievement(id:Number):Object{
            var i:Number = 0;
            while (i < app_data.achievements.length) {
                if (app_data.achievements[i].id == id){
                    return (app_data.achievements[i]);
                };
                i++;
            };
            return (null);
        }
        public function show_feed_dialog(data:Object=null):void{
            if (((!(app_data.feed_data)) && (!(data)))){
                return;
            };
            var feed_data:Object = (data) ? data : app_data.feed_data;
            if (feed_data.add_user){
                feed_data.attachment.description = (user_name + feed_data.attachment.description);
            };
            last_feed_data = feed_data;
            sendNotification(ApplicationFacade.SHOW_FEED_DIALOG, feed_data);
        }
        private function num_materials(obj:Object):Number{
            var c:Number = 0;
            var info:Object = config.store[obj.id];
            var arr:Array = (can_upgrade(obj)) ? info.upgrade_levels[(obj.upgrade_level + 1)] : info.materials;
            var i:Number = 0;
            while (i < arr.length) {
                c = (c + arr[i].qty);
                i++;
            };
            return (c);
        }
        private function get transaction_proxy():TransactionProxy{
            return ((facade.retrieveProxy(TransactionProxy.NAME) as TransactionProxy));
        }
        
        /**
         * 是否可以扩充地 
         * 先把所有的数据都找出来
         * 然后找到当前要扩展的索引,和当前的索引
         * 如果总的长度-1,当前的索引的话,那么就能扩展
         * 如果当前的+1的size并不等于数据里的size的话,那么则不扩展
         * 其它条件都能扩展
         */ 
        private function map_can_expand(item:Object):Object{
            var obj:Object;
            var i:Number;
            var plans:Array = new Array();
            var current_plan:Number = -1;
            var requested_plan:Number = 0;
            var s:Number = item.size;
            var current_size:Number = ((item.action)=="expand") ? app_data.size_x : ((item.action)=="expand_top_map") ? app_data.top_map_size : app_data.bottom_map_size;
            for each (obj in config.store) {
                if ((((((obj.type == "expand_ranch")) && ((obj.action == item.action)))) && (!(obj.neighbors)))){
                    plans.push(obj);
                };
            };
            plans.sortOn("size", Array.NUMERIC);
            i = 0;
            while (i < plans.length) {
                if (plans[i].size == current_size){
                    current_plan = i;
                };
                if (plans[i].size == s){
                    requested_plan = i;
                };
                i++;
            };
            if ((plans.length - 1) == current_plan){
                return ({result:true});
            };
            if (plans[(current_plan + 1)].size != s){
                return ({
                    result:false,
                    size:(plans[(requested_plan - 1)].size / 4),
                    name:plans[(requested_plan - 1)].name
                });
            };
            return ({result:true});
        }
        public function clear_process_queue():void{
            queue = new Array();
            queue_is_processing = false;
            auto_queue = new Array();
        }
        
        /**
         * 施肥的方法 
         */ 
        public function fertilize(data:Object):Boolean{
            var fertilizer:Object = get_map_obj(data.fertilizer.id, data.fertilizer.grid_x, data.fertilizer.grid_y);
            var info:Object = config.store[fertilizer.id];
            if (fertilizer.times_used >= info.uses){
                return (false);
            };
            var plant:Object = get_map_obj(data.plant.id, data.plant.grid_x, data.plant.grid_y);
            plant.start_time = (plant.start_time - (plant.collect_in * info.percent));
            fertilizer.times_used++;
            data.plant.fertilize(data.fertilizer.percent);
            data.fertilizer.use_it();
            if (!data.fertilizer.can_use()){
                remove_map_obj(fertilizer.id, fertilizer.x, fertilizer.y);
                data.fertilizer.kill();
            };
            return (true);
        }
        
        
        private function get_objects_like(id:Number, under_construction_only:Boolean=false):Array{
            var obj:Object;
            var list:Array = new Array();
            var i:Number = 0;
            while (i < app_data.map.length) {
                obj = app_data.map[i];
                update_object(obj);
                if (obj.id == id){
                    if (((under_construction_only) && (!(obj.under_construction)))){
                    } else {
                        list.push(obj);
                    };
                };
                i++;
            };
            return (list);
        }
        public function get_select_popup_data(obj:MapObject):Object{
            var id:Number;
            var p:Object;
            var info:* = config.store[obj.id];
            var urls:Array = new Array();
            var has_materials:Boolean;
            var product_name:String = info.product_name;
            var i:Number = 0;
            while (i < info.raw_material[0].length) {
                id = info.raw_material[0][i];
                p = new Object();
                p.url = (("images/" + config.store[id].url) + ".png");
                p.enabled = (app_data.storage[id]) ? true : false;
                p.selected = (MultiProcessor(obj).get_selected_raw_material() == i);
                p.name = config.store[id].name;
                urls.push(p);
                i++;
            };
            return ({
                list:urls,
                caption:(ResourceManager.getInstance().getString("message","select_product_type",[product_name]))
            });
        }
        private function remove_map_obj(id:Number, x:Number, y:Number, flipped:Number=-1):Boolean{
            var obj:Object;
            var i:Number = 0;
            while (i < app_data.map.length) {
                obj = app_data.map[i];
                if ((((((obj.id == id)) && ((obj.x == x)))) && ((obj.y == y)))){
                    if (((!((flipped == -1))) && (!((obj.flipped == flipped))))){
                    } else {
                        app_data.map.splice(i, 1);
                        return (true);
                    };
                };
                i++;
            };
            return (false);
        }
        public function collect_product(obj:MapObject, body:TransactionBody, gift_mode:Boolean=false, queue_call:Boolean=false):Boolean{
            var item:Object;
            var products:Number;
            var new_soil:Object;
            var soil_data:Object;
            var new_soil_mo:MapObject;
            var water_pipe:Object;
            var info:Object = config.store[obj.id];
            if (!queue_call){
                add_to_queue("collect_product", obj, obj, collect_object_action(info), ((obj.type)=="seeds") ? "normal" : "collect", body);
            } else {
                item = get_map_obj(obj.id, obj.grid_x, obj.grid_y);
                if ((obj as IProcessor)){
                    products = ((obj as MultiProcessor)) ? item.products.length : item.products;
                    if (products > 0){
                        obj_decrease_product(item);
                    } else {
                        return (report_confirm_error(ResourceManager.getInstance().getString("message","nothing_to_collect")));
                    };
                };
                if (obj.type == "seeds"){
                    remove_map_obj(obj.id, obj.grid_x, obj.grid_y);
                    new_soil = {
                        id:1,
                        x:obj.grid_x,
                        y:obj.grid_y
                    };
                    app_data.map.push(new_soil);
                    soil_data = get_item_data(1);
                    soil_data.x = obj.grid_x;
                    soil_data.y = obj.grid_y;
                    new_soil_mo = new MapObject(soil_data);
                    sendNotification(ApplicationFacade.MAP_ADD_OBJECT, new_soil_mo);
                    if (obj.has_irrigation()){
                        water_pipe = config.store[obj.get_water_pipe()];
                        new_soil_mo.install_irrigation({
                            growing_percent:water_pipe.growing_percent,
                            id:water_pipe.id,
                            image:(("images/" + water_pipe.url) + "_obj.png")
                        });
                        new_soil.water_pipe = water_pipe.id;
                    };
                    obj.kill();
                } else {
                    if ((obj as IProcessor)){
                        IProcessor(obj).collect();
                    };
                    if ((obj as Tree)){
                        Tree(obj).collect();
                        item.start_time = Algo.time();
                    };
                };
                if ((obj as MultiProcessor)){
                    add_to_storage(MultiProcessor(obj).product_collected());
                } else {
                    add_to_storage(info.product);
                };
                if (item.automatic){
                    confirm = new Confirmation();
                    confirm.set_coords(obj.preload_position("collect").x, obj.preload_position("collect").y);
                    confirm.add_value(-1, " OP");
                    app_data.op--;
                };
                update_objects(["coins", "storage", "operations"]);
                sendNotification(ApplicationFacade.CHECK_AUTOMATION, "on_collect");
                if (body){
                    transaction_proxy.set_data_hash(data_hash);
                    transaction_proxy.add(body, true);
                };
                return (true);
            };
            return (false);
        }
        public function get post_subtype():String{
            return (last_post_subtype);
        }
        public function expand_ranch(item:Object){
            switch (item.action){
                case "expand":
                    app_data.size_x = item.size;
                    app_data.size_y = item.size;
                    break;
                case "expand_top_map":
                    app_data.top_map_size = item.size;
                    break;
                case "expand_bottom_map":
                    app_data.bottom_map_size = item.size;
                    break;
            };
            sendNotification(ApplicationFacade.EXPAND_RANCH, item);
            update_objects(["shop"]);
        }
        
        public function add_map_object(obj:MapObject, body:TransactionBody, gift_mode:Boolean=false, queue_call:Boolean=false):Boolean{
            var new_mo:Object;
            var item:Object = config.store[obj.id];
            if (!queue_call){
                add_to_queue("add_map_object", obj, obj, add_object_action(item), "normal", body);
                this.gift_mode = false;
            } else {
                if (((!(gift_mode)) && ((app_data.coins < item.price)))){
                    report_confirm_error(Err.NO_COINS, false, obj);
                    obj.kill();
                    return (false);
                };
                obj.map_x = obj.grid_x;
                obj.map_y = obj.grid_y;
                if (!get_map_obj(obj.id, obj.grid_x, obj.grid_y)){
                    new_mo = {
                        id:obj.id,
                        x:obj.grid_x,
                        y:obj.grid_y
                    };
                    if (obj.is_flipped_from_store()){
                        new_mo.flipped = 1;
                    };
                    if (obj.type == "trees"){
                        new_mo.start_time = Algo.time();
                        CollectObject(obj).start();
                    } else {
                        if (item.constructible){
                            new_mo.under_construction = true;
                        };
                    };
                    app_data.map.push(new_mo);
                };
                if (!gift_mode){
                    app_data.coins = (app_data.coins - parseFloat(item.price));
                    app_data.experience = (app_data.experience + item.exp);
                    confirm = new Confirmation(item.exp, -(item.price));
                    if (item.rp_price){
                        app_data.reward_points = (app_data.reward_points - item.rp_price);
                        confirm.reward_points = -(item.rp_price);
                    };
                    confirm.set_target(obj);
                    refresh_level();
                    update_objects(["level", "coins", "reward_points"]);
                } else {
                    var _local7 = app_data.gifts;
                    var _local8 = obj.id;
                    var _local9 = (_local7[_local8] - 1);
                    _local7[_local8] = _local9;
                    update_objects(["gifts"]);
                };
                sendNotification(ApplicationFacade.MAP_REFRESH_DEPTH);
                transaction_proxy.set_data_hash(data_hash);
                transaction_proxy.add(body, true);
            };
            return (false);
        }
        private function collect_object_action(obj:Object):String{
            if ((((obj.type == "seeds")) || ((obj.type == "trees")))){
                return ("Harvesting");
            };
            return ("Collecting");
        }
        public function toggle_automation(obj:MapObject):Boolean{
            var map_obj:Object = get_map_obj(obj.id, obj.grid_x, obj.grid_y);
            if (((!(map_obj.automatic)) && ((app_data.op <= 0)))){
                report_confirm_error(Err.NO_OP);
                return (false);
            };
            map_obj.automatic = (map_obj.automatic) ? false : true;
            sendNotification(ApplicationFacade.AUTOMATION_TOGGLED);
            return (true);
        }
        
        private function get_constructible_object(material:Number):Object{
            var mo:Object;
            var info:Object;
            var i:Number = 0;
            while (i < app_data.map.length) {
                mo = app_data.map[i];
                update_object(mo);
                info = config.store[mo.id];
                if (info.constructible){
                    if (((((info.upgradeable) && (!(mo.under_construction)))) && (can_upgrade(mo)))){
                        if (!mo.obtained_materials[material]){
                            mo.obtained_materials[material] = 0;
                        };
                        return (mo);
                    };
                    if (((mo.under_construction) && (has_material(info, material)))){
                        if (!mo.obtained_materials[material]){
                            mo.obtained_materials[material] = 0;
                        };
                        return (mo);
                    };
                };
                i++;
            };
            return (null);
        }
        
        private function get_material_qty(obj:Object, m:Number):Number{
            var info:Object = config.store[obj.id];
            var arr:Array = (can_upgrade(obj)) ? info.upgrade_levels[(obj.upgrade_level + 1)] : info.materials;
            var i:Number = 0;
            while (i < arr.length) {
                if (arr[i].id == m){
                    return (arr[i].qty);
                };
                i++;
            };
            return (0);
        }
        
        public function use_gift(id:Number, target:Object=null):Boolean{
            var _local4:Boolean;
            var item:Object = config.store[id];
            switch (item.type){
                case "products":
                    add_to_storage(id);
                    var _local5 = app_data.gifts;
                    var _local6 = id;
                    var _local7 = (_local5[_local6] - 1);
                    _local5[_local6] = _local7;
                    update_objects(["gifts", "storage"]);
                    sendNotification(ApplicationFacade.CHECK_AUTOMATION, "on_collect");
                    break;
                case "automation":
                    _local4 = (app_data.op == 0);
                    app_data.op = (app_data.op + item.op);
                    if (_local4){
                        sendNotification(ApplicationFacade.CHECK_AUTOMATION, "op_refill");
                    };
                    confirm = new Confirmation();
                    confirm.add_value(item.op, " OP");
                    _local5 = app_data.gifts;
                    _local6 = id;
                    _local7 = (_local5[_local6] - 1);
                    _local5[_local6] = _local7;
                    update_objects(["operations", "gifts"]);
                    break;
            };
            if (item.action == "rain"){
                if (!apply_rain(item.percent)){
                    return (false);
                };
                _local5 = app_data.gifts;
                _local6 = id;
                _local7 = (_local5[_local6] - 1);
                _local5[_local6] = _local7;
                update_objects(["gifts"]);
            };
            if (item.action == "construction"){
                if (!use_material(item, target)){
                    return (false);
                };
                _local5 = app_data.gifts;
                _local6 = id;
                _local7 = (_local5[_local6] - 1);
                _local5[_local6] = _local7;
                confirm = new Confirmation();
                update_objects(["gifts"]);
            };
            return (true);
        }
        
        /**
         * 这里代码的多语言暂时先不用修改 
         */ 
        public function get_upgrade_popup_data(mo:MapObject):Object{
            var objs:Array;
            var i:Number;
            var material:Object;
            var qty:Number;
            var friends_needed:Number;
            var more:String;
            var sprinkler:Object;
            var obj:Object = get_map_obj(mo.id, mo.grid_x, mo.grid_y);
            var info:Object = config.store[mo.id];
            var output:Object = new Object();
            output.title = info.name;
            output.list = new Array();
            map_object_to_use = mo;
            if (mo.can_upgrade()){
                objs = info.upgrade_levels[(obj.upgrade_level + 1)];
                i = 0;
                while (i < objs.length) {
                    material = get_item_data(objs[i].id);
                    material.title_txt = material.name;
                    qty = int(obj.obtained_materials[objs[i].id]);
                    material.desc_txt = ((((qty + " of ") + objs[i].qty) + "\nfor level ") + (obj.upgrade_level + 1));
                    if (((!(material.giftable)) && ((qty == objs[i].qty)))){
                        material.disable_button = true;
                    };
                    material.button_label = (material.giftable) ? "Share" : "Ask For Help";
                    material.type = (material.giftable) ? "ask_for_more" : "ask_for_help";
                    if (((!(material.giftable)) && (!((qty == objs[i].qty))))){
                        friends_needed = material.friends_needed;
                        if (obj.friends_who_helped){
                            friends_needed = (friends_needed - obj.friends_who_helped[objs[i].id]);
                        };
                        more = ((friends_needed)==material.friends_needed) ? "" : " more";
                        if (friends_needed){
                            material.help_txt = ((("need " + friends_needed) + more) + " people to help");
                        };
                    };
                    output.list.push(material);
                    i++;
                };
            };
            if (mo.kind == "water_well"){
                sprinkler = get_item_data(info.sprinkler);
                sprinkler.title_txt = sprinkler.name;
                sprinkler.desc_txt = (((count_sprinklers() + " of ") + info.depth[mo.get_upgrade_level()]) + "\ninstalled");
                // TODO 这里有一段代码有问题,可能原来的gifts这个已经不存在的了
                if (((app_data.gifts && app_data.gifts[info.sprinkler]) && (can_install_irrigation(info.sprinkler)))){
                    sprinkler.help_txt = "<a href='event:gigi'>Click to install</a>";
                };
                if (app_data.ask_for_materials[mo.id] === false){
                    sprinkler.disable_button = true;
                };
                sprinkler.button_label = "Share";
                sprinkler.type = "ask_for_more";
                output.list.push(sprinkler);
            };
            return (output);
        }
        
        /**
         * 这里的多语言文字暂时也不用修改了 
         */ 
        public function post_on_friend_wall(friend:Number):void{
            var story:String = "inform_friend";
            var tag:String = Algo.generate_tag();
            var href:String = ((((app_url + "?from=stream&story=") + story) + "&tag=") + tag);
            var info:Object = config.story_patterns[story];
            var feed_data:Object = new Object();
            var attachment:Object = new Object();
            feed_data.tag = tag;
            feed_data.subtype = story;
            attachment.name = Algo.replace(info.name, ["{actor}"], [user_name]);
            attachment.description = Algo.replace(info.description, ["{actor}"], [user_name]);
            var src:String = Config.getConfig("host") + "images/stories/" + info.image + ".png";
            attachment.media = [{
                href:href,
                src:src,
                type:"image"
            }];
            feed_data.action_links = [{
                text:info.action_link,
                href:href
            }];
            feed_data.attachment = attachment;
            feed_data.targetID = friend;
            show_feed_dialog(feed_data);
        }
        
        private function is_multi(o:Object):Boolean{
            var info:Object = config.store[o.id];
            return ((info.raw_material as Array));
        }
        
        public function get operations():Number{
            return (int(app_data.op));
        }
        
        public function pollinate(data:Object):Boolean{
            var hive:Object = get_map_obj(data.hive.id, data.hive.grid_x, data.hive.grid_y);
            var clover:Object = get_map_obj(data.target.id, data.target.grid_x, data.target.grid_y);
            obj_increase_raw_material(hive);
            clover.pollinated = true;
            return (true);
        }
        
        /**
         * 升级时获得的一些数据 
         */ 
        public function get_level_up_data():Object{
            var output:Object = get_unlocked_items();
            output.received = ((((ResourceManager.getInstance().getString("message","state_message",[app_data.level_up.coins,app_data.level_up.rp])))));
            output.level = ResourceManager.getInstance().getString("message","your_level_now",[app_data.level]);
            output.user_has_name = !((user_name == false));
            return output;
        }
        
        private function can_use_material(id:Number):Boolean{
            var i:Number;
            var error:String;
            var materials:String;
            var name:String;
            var list:Array = get_objects_who_use(id, true);
            if (list.length){
                return (true);
            };
            list = get_objects_who_use(id);
            if (list.length){
                i = 0;
                while (i < list.length) {
                    if (((list[i].under_construction) || (can_upgrade(list[i])))){
                        materials = (config.store[id].plural) ? config.store[id].plural : (config.store[id].name + "s");
                        name = (last_used_materials[id]) ? config.store[last_used_materials[id]].name : config.store[list[i].id].name;
                        
                        return (report_confirm_error(ResourceManager.getInstance().getString("message","already_own_enough",[materials,name])));
                    };
                    if (config.store[list[i].id].max_instances == get_objects_like(list[i].id).length){
                        error = ResourceManager.getInstance().getString("message","already_have_items",[Algo.articulate(config.store[id].name)]);
                    } else {
                        return (report_confirm_error(ResourceManager.getInstance().getString("message","start_construction_one",[config.store[list[i].id].name])));
                    };
                    i++;
                };
                return (report_confirm_error(error));
            };
            list = get_store_constructible_objects(id);
            i = 0;
            while (i < list.length) {
                if (list[i].max_instances == get_objects_like(list[i].id).length){
                    error = ResourceManager.getInstance().getString("message","already_have_items",[Algo.articulate(config.store[id].name)]);
                } else {
                    return (report_confirm_error(ResourceManager.getInstance().getString("message","start_construction_one",[list[i].name])));
                };
                i++;
            };
            return (report_confirm_error(error));
        }
        
        public function auto_process(pid:String):void{
            var note:Notification;
            var queue:Array = auto_queue[pid];
            if (queue.length == 0){
                return;
            }
            var entry:Object = queue.shift();
            this[entry.data.method].apply(this, entry.data.args);
            if (queue.length > 0){
                note = (queue[0].note as Notification);
                sendNotification(note.getName(), note.getBody());
            }
        }
        
        public function get_objects_to_update():Array{
            return (app_data.objects_to_update);
        }
        
        public function get_data():Object{
            return app_data;
        }
        
        /**
         * 这个是合成的功能,暂时先不用修改 
         */ 
        public function get_under_construction_popup_data(mo:MapObject):Object{
            var material:Object;
            var qty:Number;
            var friends_needed:Number;
            var more:String;
            var obj:Object = get_map_obj(mo.id, mo.grid_x, mo.grid_y);
            var info:Object = config.store[mo.id];
            var output:Object = new Object();
            output.title = info.name;
            output.list = new Array();
            map_object_to_use = mo;
            var i:Number = 0;
            while (i < info.materials.length) {
                material = get_item_data(info.materials[i].id);
                material.title_txt = material.name;
                qty = int(obj.obtained_materials[info.materials[i].id]);
                material.desc_txt = ((qty + " of ") + info.materials[i].qty);
                if (((!(material.giftable)) && ((qty == info.materials[i].qty)))){
                    material.disable_button = true;
                };
                material.button_label = (material.giftable) ? "Ask For More" : "Ask For Help";
                material.type = (material.giftable) ? "ask_for_more" : "ask_for_help";
                if (((!(material.giftable)) && (!((qty == info.materials[i].qty))))){
                    friends_needed = material.friends_needed;
                    if (obj.friends_who_helped){
                        friends_needed = (friends_needed - obj.friends_who_helped[info.materials[i].id]);
                    };
                    more = ((friends_needed)==material.friends_needed) ? "" : " more";
                    if (friends_needed){
                        material.help_txt = ResourceManager.getInstance().getString("message","need_people_to_help",[friends_needed,more]);
                    };
                };
                output.list.push(material);
                i++;
            };
            return (output);
        }
        
        /**
         * 弹出提示消息 
         * @params name:String 弹出的文字
         * @params reset_tool:Boolean false 是否重置tool
         * @params target:MapObject 当前做用的对象
         */ 
        public function report_confirm_error(name:String, reset_tool:Boolean=false, target:MapObject=null):Boolean{
            var _c:Confirmation = new Confirmation();
            _c.text(name, false);
            if (target){
                _c.set_target(target);
            }
            sendNotification(ApplicationFacade.DISPLAY_CONFIRMATION, _c.get_data());
            if (reset_tool){
                sendNotification(ApplicationFacade.ESCAPE_PRESSED);// 这个事件会让显示的所有的内容都重新刷新
            }
            return false;
        }
		
		/**
		 * 兑换OP
		 */ 
		public function trade_item(id:Number):Boolean {
			var info:Object = get_item_data(id);
            var op_refilled:Boolean = (app_data.op == 0);
            var op:Number = int(info.trade_for);
            app_data.op = (app_data.op + op);
            if (op_refilled){
                sendNotification(ApplicationFacade.CHECK_AUTOMATION, "op_refill");
            }
            confirm = new Confirmation();
            confirm.add_value(op, " OP");
            var giftItem:* = (app_data.gifts[id] - 1);
            app_data.gifts[id] = giftItem;
            update_objects(["operations", "gifts"]);
			return true;
		}
    }
}