package classes.model
{
    import classes.*;
    import classes.view.components.Map;
    
    import com.adobe.images.JPGEncoder;
    
    import flash.display.*;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.geom.*;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.net.URLVariables;
    import flash.utils.ByteArray;
    
    import org.puremvc.as3.multicore.interfaces.IProxy;
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;
    
    import tzh.core.Config;
    import tzh.core.JSDataManager;

    public class SnapshotProxy extends Proxy implements IProxy
    {
        private var rect:Rectangle;
        private var bmp:BitmapData;
        private var caption:String;
        public static const NAME:String = "Snapshot";

        public function SnapshotProxy()
        {
            super(NAME);
        }

        protected function get appDataProxy():AppDataProxy
        {
            return facade.retrieveProxy(AppDataProxy.NAME) as AppDataProxy;
        }
		
        public function publish_snapshot(value:String) : void
        {
        	trace("caption " + this.caption);
        	this.caption = value;
        	var request:URLRequest = new URLRequest(Config.getConfig("transport") + "camera.php");
        	request.method = URLRequestMethod.POST;
        	request.contentType = "application/octet-stream";  
        	var params:URLVariables = new URLVariables();
        	params.uid = appDataProxy.user_id;
        	params.caption = value;
        	var byteArray:ByteArray = new JPGEncoder(85).encode(bmp);
        	request.data = byteArray;
        	var loader:URLLoader = new URLLoader();
        	loader.data = params;
        	loader.dataFormat = URLLoaderDataFormat.BINARY;
        	loader.addEventListener(Event.COMPLETE,onPhotoUploadComplete);
        	loader.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
        	loader.load(request);
        }
        
        private function errorHandler(event:IOErrorEvent):void {
        	trace("error upload photo");
        }
        
        private function onPhotoUploadComplete(event:Event):void {
        	var path:String = URLLoader(event.currentTarget).data;
        	trace("path " + path);
        	JSDataManager.getInstance().uploadPhoto(path,this.caption);
        }

        public function prepare_snapshot(rect:Rectangle, map:Map) : void
        {
            this.rect = rect;
            bmp = new BitmapData(rect.width, rect.height, true, 0);
            var matrix:Matrix = new Matrix();
            matrix.translate(-rect.x, -rect.y);
            try {
            	bmp.draw(map, matrix);
            }catch(error:Error){
            	trace("bmp.draw " + error.message);
            }
            var bitmap:Bitmap = new Bitmap(bmp);
            bitmap.scaleX = bitmap.scaleY = 0.5;
            sendNotification(ApplicationFacade.SHOW_SNAPSHOT_PREVIEW, bitmap); 
        } 
    }
}
