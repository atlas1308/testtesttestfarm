package classes.model
{
    import classes.*;
    import classes.utils.*;
    import classes.view.components.map.*;
    
    import flash.net.*;
    
    import mx.resources.ResourceManager;
    
    import org.puremvc.as3.multicore.interfaces.IProxy;
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;

    public class MapProxy extends Proxy implements IProxy
    {
        private var last_sign:Boolean;
        private var last_x:Number;
        private var map_obj:MapObject;
        private var last_time:Number;
        private var zoom_level:Number = 3;// 初始化修改了这个值,为了让用户看到的东西比较大,感觉比较好一些
        private var grid_sizes:Array;
        private var last_shake_x:Number;
        private var friend_zoom_level:Number = 3;
        public var friend_mode:Boolean = false;
        public var soil_to_plant:Object;
        private var shakes:Number;
        public static const NAME:String = "MapProxy";

        public function MapProxy()
        {
            grid_sizes = new Array(7, 9, 11, 13, 15);// 这是定义的几个,缩放的比率
            //grid_sizes = new Array(3,5,7, 9, 11, 13, 15,17,19);// 这是定义的几个,缩放的比率
            super(NAME);
        }

        public function has_soil_to_plant() : Boolean
        {
            return soil_to_plant;
        }

        public function mouse_shake(value:Number) : Boolean
        {
            var _loc_2:Boolean = false;
            var _loc_3:Number = NaN;
            if (!last_time)
            {
                last_time = Algo.time();
            }
            if (last_x)
            {
                _loc_2 = value < last_x;
                if (last_sign != _loc_2)
                {
                    if (Math.abs(last_shake_x - value) > 30 && Algo.time() - last_time < 0.25)
                    {
                        shakes++;
                    }
                    else
                    {
                        shakes = 0;
                    }
                    last_shake_x = value;
                    last_time = Algo.time();
                }
                else
                {
                    _loc_3 = Algo.time() - last_time;
                    if (_loc_3 > 0.25)
                    {
                        shakes = 0;
                    }
                }
                last_sign = _loc_2;
            }
            last_x = value;
            if (shakes == 4)
            {
                shakes = 0;
                return true;
            }
            return false;
        }

        public function remove_map_object_popup(mapObject:Object, coin:Number) : void
        {
            var msg:String = null;
            if (mapObject)
            {
                msg = ResourceManager.getInstance().getString("message","sell_notice",[mapObject.get_name(),coin]);
                if (mapObject as WaterWell)
                {
                    msg = ResourceManager.getInstance().getString("message","sell_irrigation",[coin]);
                }
            }
            else
            {
                msg = ResourceManager.getInstance().getString("message","delete_object");
            }
            sendNotification(ApplicationFacade.SHOW_CONFIRM_POPUP, {msg:msg, obj:{notif:ApplicationFacade.REMOVE_MAP_OBJECT, data:mapObject}});
        }

        public function get_map_object() : MapObject
        {
            return map_obj;
        }

        public function zoom_in() : Boolean
        {
            var zoom:String = !friend_mode ? ("zoom_level") : ("friend_zoom_level");
            if (this[zoom] == grid_sizes.length - 2)
            {
                sendNotification(ApplicationFacade.DISABLE_ZOOM_IN);
                sendNotification(ApplicationFacade.ENABLE_ZOOM_OUT);
            }
            var len:int = grid_sizes.length - 1;
            if (this[zoom] < len)
            {
            	this[zoom]++;
                return true;
            } 
            return false;
        }

        public function zoom_out() : Boolean
        {
            var zoom:String = !friend_mode ? ("zoom_level") : ("friend_zoom_level");
            if (this[zoom] == 1)
            {
                sendNotification(ApplicationFacade.DISABLE_ZOOM_OUT);
                sendNotification(ApplicationFacade.ENABLE_ZOOM_IN);
            }
            if (this[zoom] > 0)
            {
                this[zoom]--;
                return true;
            } 
            return false;
        }

        public function call_garbage_collector() : void
        {
            var lc1:LocalConnection;
            var lc2:LocalConnection;
            try
            {
                lc1 = new LocalConnection();
                lc2 = new LocalConnection();
                lc1.connect("name");
                lc2.connect("name");
            }
            catch (e:Error)
            {
            }
        }

        public function get_grid_size() : Number
        {
            var mode:String = !friend_mode ? ("zoom_level") : ("friend_zoom_level");
            var grid_size:Number = grid_sizes[this[mode]];
            return grid_size;
        }

        public function set_soil_to_plant(value:Object) : void
        {
            soil_to_plant = value;
        }

        public function set_map_object(value:MapObject) : void
        {
            map_obj = value;
        }

    }
}
