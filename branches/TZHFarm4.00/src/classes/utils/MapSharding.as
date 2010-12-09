package classes.utils {
    import classes.view.components.map.*;

    public class MapSharding {

        private static var shard_size:Number = 2;
        private static var shards:Array = [];
        private static var types:Array = [];

        public function MapSharding(){
            super();
        }
        public static function get_type(t:String):Array{
            if (!types[t]){
                types[t] = new Array();
            };
            return ((types[t] as Array));
        }
        public static function get_shard_by_coords(x:Number, y:Number):Array{
            var key:String = ((x + "_") + y);
            if (!shards[key]){
                shards[key] = new Array();
            };
            return (shards[key]);
        }
        public static function get_shard(obj:MapObject):Array{
            var key:String = get_shard_key(obj);
            if (!shards[key]){
                shards[key] = new Array();
            };
            return (shards[key]);
        }
        public static function get_types(... _args):Array{
            var output:Array = new Array();
            var i:Number = 0;
            while (i < _args.length) {
                output = output.concat(get_type(_args[i]));
                i++;
            };
            return (output);
        }
        public static function remove_object(obj:MapObject):void{
            var shard:Array = get_shard(obj);
            var i:Number = 0;
            while (i < shard.length) {
                if (shard[i] == obj){
                    shard.splice(i, 1);
                    break;
                };
                i++;
            };
            var list:Array = get_type(obj.type);
            var l:Number = list.length;
            i = 0;
            while (i < l) {
                if (list[i] == obj){
                    list.splice(i, 1);
                    break;
                };
                i++;
            };
            list = get_type(obj.kind);
            l = list.length;
            i = 0;
            while (i < l) {
                if (list[i] == obj){
                    list.splice(i, 1);
                    break;
                };
                i++;
            };
        }
        public static function get_shard_key(obj:MapObject):String{
            var o_x:Number = (obj.grid_x) ? obj.grid_x : obj.map_x;
            var o_y:Number = (obj.grid_y) ? obj.grid_y : obj.map_y;
            var x:Number = Math.floor((o_x / shard_size));
            var y:Number = Math.floor((o_y / shard_size));
            return (((x + "_") + y));
        }
        public static function add_object(obj:MapObject):void{
            get_shard(obj).push(obj);
            get_type(obj.type).push(obj);
            get_type(obj.kind).push(obj);
        }
        public static function get_shards(x:Number, y:Number, w:Number, h:Number):Array{
            var j:Number;
            var s_x:Number = Math.floor(((x - 4) / shard_size));
            var s_y:Number = Math.floor(((y - 4) / shard_size));
            var s_x2:Number = Math.floor(((x + w) / shard_size));
            var s_y2:Number = Math.floor(((y + h) / shard_size));
            var output:Array = new Array();
            var i:Number = s_x;
            while (i <= s_x2) {
                j = s_y;
                while (j <= s_y2) {
                    output = output.concat(get_shard_by_coords(i, j));
                    j++;
                };
                i++;
            };
            return (output);
        }

    }
}
