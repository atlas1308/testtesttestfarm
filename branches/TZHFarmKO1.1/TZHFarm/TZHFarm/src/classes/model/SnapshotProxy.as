package classes.model
{
    import classes.*;
    
    
    import flash.display.*;
    import flash.geom.*;
    import flash.utils.ByteArray;
    
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

        public function prepare_snapshot(a:Rectangle, b:Stage) : void
        {
           /*  this.rect = a;
            bmp = new BitmapData(a.width, a.height, true, 0);
            var _loc_3:* = new Matrix();
            _loc_3.translate(-a.x, -a.y);
            bmp.draw(b, _loc_3);
            var _loc_4:* = new Bitmap(bmp);
            var _loc_5:Number = 0.5;
            _loc_4.scaleY = 0.5;
            _loc_4.scaleX = _loc_5;
            sendNotification(ApplicationFacade.SHOW_SNAPSHOT_PREVIEW, _loc_4); */
        }/* 

        private function onPhotoUploadComplete(event:FacebookEvent) : void
        {
            return;
        }

        protected function get fb() : Facebook
        {
            return fb_proxy.facebook;
        } */

    }
}
