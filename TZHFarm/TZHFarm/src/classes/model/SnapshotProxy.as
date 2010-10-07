package classes.model
{
    import classes.*;
    
    import flash.display.*;
    import flash.geom.*;
    
    import mx.resources.ResourceManager;
    
    import org.puremvc.as3.multicore.interfaces.IProxy;
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;

    public class SnapshotProxy extends Proxy implements IProxy
    {
        private var rect:Rectangle;
        private var bmp:BitmapData;
        public static const NAME:String = ResourceManager.getInstance().getString("message","snap_shot");

        public function SnapshotProxy()
        {
            super(NAME);
        }

        protected function get fb_proxy() : JSProxy
        {
            return facade.retrieveProxy(JSProxy.NAME) as JSProxy;
        }

        public function publish_snapshot(value:String) : void
        {
            /* var encoder:ByteArray = new JPGEncoder(85).encode(bmp);
            var uploadPhoto:* = new UploadPhoto(encoder, "", value);
            uploadPhoto.addEventListener(FacebookEvent.COMPLETE, onPhotoUploadComplete, false, 0, true);
            fb.post(uploadPhoto); */
        }

        public function prepare_snapshot(rect:Rectangle, stage:Stage) : void
        {
            this.rect = rect;
            bmp = new BitmapData(rect.width, rect.height, true, 0);
            var matrix:Matrix = new Matrix();
            matrix.translate(-rect.x, -rect.y);
            bmp.draw(stage, matrix);
            var bitmap:Bitmap = new Bitmap(bmp);
            bitmap.scaleX = bitmap.scaleY = 0.5;
            sendNotification(ApplicationFacade.SHOW_SNAPSHOT_PREVIEW, bitmap); 
        }
    }
}
