package classes.utils {
    import flash.display.*;
    import flash.geom.*;
    import flash.utils.*;

    import mx.resources.ResourceManager;
    
    import tzh.core.SystemTimer;

    public dynamic class Algo {

        private static var allowInstantiation:Boolean;
        private static var cos_cache:Array = new Array();
        public static var time_delay:Number = 0;
        private static var instance:Algo;
        private static var sin_cache:Array = new Array();

        public function Algo():void{
            super();
            if (!allowInstantiation){
                throw (new Error(" Instantiation failed: Use Algo.getInstance() instead of new."));
            };
        }
        
        public static function convert_to_number(obj:Object):void{
            var prop:String;
            for (prop in obj) {
                if (isNaN(obj[prop])){
                    convert_to_number(obj[prop]);
                } else {
                    if (typeof(obj[prop]) == "object"){
                    } else {
                        if (obj[prop] === ""){
                        } else {
                            if ((obj[prop] as Boolean) == null){
                                obj[prop] = parseFloat(obj[prop]);
        }
                        }
                    }
                }
            }
        }
        
        public static function decimals(a:Number, n:int):Number{
            return (parseFloat(a.toFixed(n)));
        }
        public static function timer():Number{
            return (getTimer());
        }
        public static function humanize(s:String):String{
            var arr:Array = s.split("_");
            var output:Array = new Array();
            var i:Number = 0;
            while (i < arr.length) {
                output.push(ucfirst(arr[i]));
                i++;
            };
            return (output.join(" "));
        }
        public static function localToGlobal(mc:DisplayObject):Point{
            var point:Point = mc.localToGlobal(new Point(0, 0));
            return (point);
        }
        public static function getInstance():Algo{
            if (instance == null){
                allowInstantiation = true;
                instance = new (Algo)();
                allowInstantiation = false;
            };
            return (instance);
        }
        public static function find_index(x:Number, array:Array, l1:int=0, l2:int=0, field:String=""):int{
            var m:int;
            var value:Number;
            if ((((l2 == 0)) || ((l2 > (array.length - 1))))){
                l2 = (array.length - 1);
            };
            if ((l2 - l1) == 1){
                return ((((get_value(array, l2, field) - x))<(x - get_value(array, l1, field))) ? l2 : l1);
            };
            m = int((((l1 + l2) + 1) / 2));
            value = get_value(array, m, field);
            if (!Boolean(value)){
                return (0);
            };
            if (value == x){
                return (m);
            };
            if (x < value){
                return (find_index(x, array, l1, m, field));
            };
            return (find_index(x, array, m, l2, field));
        }
        
        /**
         * 不用再计算delay了,如果计算delay时间就会有问题
         */ 
        public static function time():Number{
            return SystemTimer.getInstance().serverTime;
        }
        
        public static function cos(angle:Number):Number{
            if (cos_cache[angle] === undefined){
                cos_cache[angle] = Math.cos(angle);
            };
            return (cos_cache[angle]);
        }
        public static function count(obj:Object):int{
            var prop:String;
            var c:Number = 0;
            for (prop in obj) {
                c++;
            };
            return (c);
        }
        public static function generate_tag():String{
            return (uniqid(rand(0x0100, 4095, false).toString(16)));
        }
        public static function min(array:Array, field:String=""):Number{
            return (extreme(array, -1, field));
        }
        public static function prep_size(s:Number):String{
            return ((Number(((s / 0x0400) / 0x0400)).toFixed(2) + "Mb"));
        }
        public static function get_x(grid_x:Number, grid_y:Number, view_angle:Number, grid_size:Number):Number{
            return ((((grid_y - grid_x) * grid_size) * Algo.sin(view_angle)));
        }
        private static function formatSeed(s:Number, reqWidth:Number):String{
            var seed:String = int(s).toString(16);
            if (reqWidth < seed.length){
                return (seed.slice((seed.length - reqWidth)));
            };
            if (reqWidth > seed.length){
                return ((Array((1 + (reqWidth - seed.length))).join("0") + seed));
            };
            return (seed);
        }
        public static function sin(angle:Number):Number{
            if (sin_cache[angle] === undefined){
                sin_cache[angle] = Math.sin(angle);
            };
            return (sin_cache[angle]);
        }
        
        public static function set_time(value:Number):void{
        	var date:Date = new Date();
        	var result:int = (date.time / 1000) - value;
            Algo.time_delay = result;// 当前的时间和服务器返回的时间,算出一个具体的延迟
        }
        
        public static function uniqid(prefix:String="", more_entropy:Boolean=false):String{
            var retId:String;
            var uniqidSeed:Number;
            uniqidSeed = Math.floor((Math.random() * 123456789));
            uniqidSeed++;
            retId = prefix;
            retId = (retId + formatSeed(int((new Date().getTime() / 1000)), 8));
            retId = (retId + formatSeed(uniqidSeed, 5));
            if (more_entropy){
                retId = (retId + (Math.random() * 10).toFixed(8).toString());
            };
            return (retId);
        }
        
        public static function clone(source:Object):Object{
            var byteArray:ByteArray = new ByteArray();
            byteArray.writeObject(source);
            byteArray.position = 0;
            return byteArray.readObject();
        }
        
        /**
         * 时间的转化工式
         * @param n:Number 秒数
         * @param long_time //
         */ 
        public static function prep_time(n:Number, long_name:Boolean=true):String{
            var h:Number = int((n / 3600));
            n = (n % 3600);
            var m:Number = int((n / 60));
            n = Math.ceil((n % 60));
            if (h > 0){
                if (long_name){
                    return (Algo.pluralize("hour", h));
                };
                return ((h + "h"));
            }
            if ((((m > 0)) && (!(n)))){
                if (long_name){
                    return (Algo.pluralize("minute", m));
                };
                return ((m + "m"));
            }
            if (long_name){
                return (Algo.pluralize("second", (n + (m * 60))));
            }
            return (((n + (m * 60)) + "s"));
        }
        
        public static function get_grid_x(x:Number, y:Number, view_angle:Number, grid_size:Number):Number{
            return (Math.round(((((y * Algo.sin(view_angle)) - (x * Algo.cos(view_angle))) / Algo.sin((2 * view_angle))) / grid_size)));
        }
        
        public static function milliseconds():Number{
            return (Math.floor((Algo.time() * 1000)));
        }
        
        public static function size(source:Object):Number{
            var myBA:ByteArray = new ByteArray();
            myBA.writeObject(source);
            return (myBA.length);
        }
        
        public static function max(array:Array, field:String=""):Number{
            return (extreme(array, 1, field));
        }
        
        public static function rand(a:Number, b:Number, int_mode:Boolean=true):Number{
            if (int_mode){
                return ((a + Math.min((b - a), int((Math.random() * ((b - a) + 1))))));
            };
            return ((a + (Math.random() * (b - a))));
        }
        
        public static function pluralize(s:String, n:Number):String{
            return (((n)>1) ? (((n + " ") + s) + "s") : ("1 " + s));
        }
        
        public static function get_grid_y(x:Number, y:Number, view_angle:Number, grid_size:Number):Number{
            return (Math.round(((((y * Algo.sin(view_angle)) + (x * Algo.cos(view_angle))) / Algo.sin((2 * view_angle))) / grid_size)));
        }
        
        private static function extreme(array:Array, sign:Number, field:String=""):Number{
            var value:Number;
            var temp:Number = (sign * Number.NEGATIVE_INFINITY);
            var i:int;
            while (i < array.length) {
                value = get_value(array, i, field);
                if (((!(Boolean(value))) && (!((value == 0))))){
                } else {
                    if ((sign * temp) < (sign * value)){
                        temp = value;
                    };
                };
                i++;
            };
            return (temp);
        }
        
        public static function number_format(n:Number, ts:String=","):String{
            var pos:Number;
            var sign:Boolean = (n < 0);
            var str:String = String(Math.abs(n));
            var formated:String = "";
            var i:Number = 0;
            while (i < str.length) {
                pos = ((str.length - i) - 1);
                if (((((i % 3) == 0)) && ((i > 0)))){
                    formated = (ts + formated);
                };
                formated = (str.charAt(pos) + formated);
                i++;
            };
            if (sign){
                formated = ("-" + formated);
            };
            return (formated);
        }
        public static function sprintf(s:String, ... _args):String{
            var arr:Array = s.split("%s");
            var new_s:String = "";
            var i:Number = 0;
            while (i < arr.length) {
                new_s = (new_s + arr[i]);
                if (i < (arr.length - 1)){
                    new_s = (new_s + _args[i]);
                };
                i++;
            };
            return (new_s);
        }
        public static function log_time():String{
            var d:Date = new Date();
            var h:String = ((d.hours)<10) ? ("0" + d.hours) : ("" + d.hours);
            var m:String = ((d.minutes)<10) ? ("0" + d.minutes) : ("" + d.minutes);
            var s:String = ((d.seconds)<10) ? ("0" + d.seconds) : ("" + d.seconds);
            var ms:String = ("" + d.milliseconds);
            if (ms.length == 1){
                ms = ("00" + ms);
            };
            if (ms.length == 2){
                ms = ("0" + ms);
            };
            return ((((((((("[" + h) + ":") + m) + ":") + s) + ":") + ms) + "]"));
        }
        
        public static function ucfirst(s:String):String{
            return ((String(s.charAt(0)).toUpperCase() + s.slice(1, s.length)));
        }
        
        public static function get_y(grid_x:Number, grid_y:Number, view_angle:Number, grid_size:Number):Number{
            return ((((grid_x + grid_y) * grid_size) * Algo.cos(view_angle)));
        }
        
        public static function enumerate(l:Array, d1:String=", "):String{
            if (!l.length){
                return ("");
            };
            var last:String = l.pop();
            if (!l.length){
                return (last);
        }
            return (((l.join(d1) + " " + ResourceManager.getInstance().getString("message","and_message") + " ") + last));
        }
        public static function replace(s:String, search:Array, replace:Array):String{
            var _s:String = s;
            var i:Number = 0;
            while (i < search.length) {
                _s = _s.split(search[i]).join(replace[i]);
                i++;
            };
            return (_s);
        }
        public static function distance(x1:Number, y1:Number, x2:Number, y2:Number):Number{
            return (Math.sqrt((Math.pow((x1 - x2), 2) + Math.pow((y1 - y2), 2))));
        }
        public static function merge(obj1:Object, obj2:Object):void{
            var prop:String;
            if (((!(obj1)) || (!(obj2)))){
                return;
            };
            for (prop in obj2) {
                obj1[prop] = obj2[prop];
            };
        }
        private static function get_value(array:Array, i:Number, field:String=""):Number{
            if ((((i < 0)) || ((i > (array.length - 1))))){
                return (NaN);
            };
            return (((typeof(array[i]))=="object") ? array[i][field] : array[i]);
        }
        
        /**
         * 英文里的内容 
         * 这里只要这样返回即可,不必为这个单独处理,只有在英文的情况下再去处理吧
         */ 
        public static function articulate(s:String):String{
            /* var vowels:Array = ["a", "e", "i", "o", "u"];
            if (int(s.charAt(0)) >= 1){
                return (s);
            };
            if (vowels.indexOf(s.toLowerCase().charAt(0)) == -1){
                return (("a " + s));
            };
            return (("an " + s)); */
            return s;
        }

    }
}