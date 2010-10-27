package classes.utils
{
    import flash.display.*;
    import flash.filters.*;

    dynamic public class Effects extends Object
    {
        private static var last_mc:DisplayObject;

        public function Effects()
        {
            return;
        }

        public static function color(display:DisplayObject, r:Number = 0, g:Number = 0, b:Number = 0) : void
        {
            var array:Array = new Array();
            array = array.concat([r, 0, 0, 0, 0]);
            array = array.concat([0, g, 0, 0, 0]);
            array = array.concat([0, 0, b, 0, 0]);
            array = array.concat([0, 0, 0, 1, 0]);
            var colorMatrixFilter:ColorMatrixFilter = new ColorMatrixFilter(array);
            var filters:Array = new Array();
            filters.push(colorMatrixFilter);
            display.filters = filters;
        }

        public static function glow(dispaly:DisplayObject, color:uint = 16763904, flag:Boolean = true) : void
        {
            if (last_mc && dispaly)
            {
                clear(last_mc);
            }
            dispaly.filters = [new GlowFilter(color, 1, 8, 8, 20)];
            last_mc = dispaly;
        }

        public static function white_glow(red:DisplayObject) : void
        {
            red.filters = [new GlowFilter(16777215, 1, 5, 5, 3.5, BitmapFilterQuality.LOW, false, false)];
        }

        public static function green(red:DisplayObject) : void
        {
            color(red, 0, 1, 0);
        }

        public static function gray(red:DisplayObject) : void
        {
            red.filters = [new ColorMatrixFilter([0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0])];
        }

        public static function clear(displayObject:DisplayObject) : void
        {
            displayObject.filters = [];
        }

        public static function hex_color(display:DisplayObject, r:Number) : void
        {
            color(display, r >> 16, r >> 8 & 255, r & 255);
        }

    }
}
