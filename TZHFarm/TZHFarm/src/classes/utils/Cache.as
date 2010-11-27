package classes.utils {
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.utils.*;
    
    import tzh.core.Config;
	
    public class Cache extends EventDispatcher {

        public static var assets_urls:Array;
        public static var base_url:String;
        public static var asset_index:Number = 0;
        public static var bytes:Array = new Array();
        public static var bmps:Array = new Array();
        public static var queue:Array = new Array();

        public static const LOAD_COMPLETE:String = "loadComplete";

        public var cache_swf:Boolean = false;
        private var interval:Number;
        private var frame:Number = 0;
        private var url:String;
        private var url_stream:URLStream;
        public var loader:Loader;

        public function Cache(){
            super();
            url_stream = new URLStream();
            url_stream.addEventListener(Event.COMPLETE, completeHandler);
            url_stream.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        }
        
        public static function size():Number{
            var u:String;
            var arr:ByteArray;
            var s:Number = 0;
            for (u in bytes) {
                arr = (bytes[u] as ByteArray);
                if (arr){
                    s = (s + arr.length);
                }
            }
            return (s);
        }

        private function try_to_dispatch():void{
            if (loader.content){
                clearInterval(interval);
                dispatchEvent(new Event(LOAD_COMPLETE));
            }
        }
        
        private function dispatch_loader():void{
             if (cache_swf){
                loader = new Loader();
                var bytes:ByteArray = Cache.bytes[url];
                if(bytes && bytes.bytesAvailable > 0){
	                loader.loadBytes(bytes);
	                clearInterval(interval);
	                interval = setInterval(try_to_dispatch, 1);
                }
            } else {
                dispatchEvent(new Event(LOAD_COMPLETE));
            }
        }
        
        public function get_bmp_by_frame(f:Number):Bitmap{
            var bmps:Array = Cache.bmps;
            var arr:Array = (bmps[url] as Array);
            if (((!(arr)) || (((arr) && ((arr.length == 0)))))){
                return (new Bitmap());
            }
            if (f < 1){
                f = 1;
            }
            var frame:int = f - 1;
            var obj:Object = bmps[url][frame];
            if(!obj){// 后台这里应该返回时出错了，我们做了一个兼容，因为每个作物成熟时需要大概5帧,花是6帧,如果没有第6帧的话,应该是成熟了,我们默认到第5帧
            	frame -= 1;
            }
            var bmp:Bitmap = new Bitmap((bmps[url][frame].bmp as BitmapData));
            bmp.x = bmps[url][frame].x;
            bmp.y = bmps[url][frame].y;
            return (bmp);
        }
        
        private function ioErrorHandler(event:IOErrorEvent):void{
        	trace("loader error " + event.text);
            Cache.bytes[url] = false;
        }
        
        public function load(url:String):void{
            this.url = url;
            if (Cache.bytes[url] == "loading"){
                if (!(Cache.queue[url] as Array)){
                    Cache.queue[url] = new Array();
                }
                Cache.queue[url].push(this);
                return;
            }
            if (Cache.bytes[url]){
                dispatch_loader();
                return;
            }
            
            var full_url:String = Config.getConfig("host").toString() + url + "?version=" + Config.getConfig("version");
            trace(full_url);
            var request:URLRequest = new URLRequest(full_url);
            Cache.bytes[url] = "loading";
            url_stream.load(request);
        }
        
        public function get asset():Object{
            if (cache_swf){
                return loader.content;
            }
            return (get_bmp_by_frame(1));
        }
        
        private function completeHandler(event:Event):void{
            var byteArray:ByteArray = new ByteArray();
            url_stream.readBytes(byteArray);
            Cache.bytes[url] = byteArray;
            if (cache_swf){
                dispatch_loader();
                clear_queue();
            } else {
            	loader = new Loader();
            	if(byteArray.bytesAvailable > 0){
	                loader.loadBytes(byteArray);
                }else {
                	trace("url" + url + " error");
                }
                interval = setInterval(try_to_fetch_bmp, 1);
            }
        }
        
        private function try_to_fetch_bmp():void{
            var mc:MovieClip;
            var i:Number;
            var bounds:Rectangle;
            var bmp_data:BitmapData;
            var matrix:Matrix;
            var bmp:Bitmap;
            if (loader.content){
                clearInterval(interval);
                mc = (loader.content as MovieClip);
                bmps[url] = new Array();
                if (mc){
                    i = 0;
                    while (i < mc.totalFrames) {
                        mc.gotoAndStop((i + 1));
                        bounds = mc.getBounds(mc.parent);
                        bmp_data = new BitmapData(mc.width, mc.height, true, 16777164);
                        matrix = new Matrix();
                        matrix.translate(-(bounds.x), -(bounds.y));
                        bmp_data.draw(mc, matrix);
                        bmps[url].push({
                            x:bounds.x,
                            y:bounds.y,
                            bmp:bmp_data
                        });
                        i++;
                    };
                } else {
                    if ((loader.content as Bitmap)){
                        bmp = Bitmap(loader.content);
                        bmps[url].push({
                            x:0,
                            y:0,
                            bmp:bmp.bitmapData
                        });
                    }
                }
                dispatch_loader();
                clear_queue();
            }
        }
        
        /**
         * 这里为什么还要重复load呢 
         */ 
        private function clear_queue():void{
            var cache:Cache;
            if ((Cache.queue[url] as Array)){
                for each (cache in Cache.queue[url]) {
                    cache.load(url);
                }
                Cache.queue[url] = new Array();
            }
        }
        
        public function destory():void {
        	if(url_stream){
        		url_stream.removeEventListener(Event.COMPLETE, completeHandler);
            	url_stream.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        		url_stream = null;
        	}
        	if(loader){
        		//loader.unload();
        		loader = null;
        	}
        	clearInterval(interval);
        }
    }
}
