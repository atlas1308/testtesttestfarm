package classes.view.components.toolbar
{
    import flash.display.*;
    import flash.events.*;

    public class Button extends EventDispatcher
    {
        private var _enabled:Boolean = true;
        public static const BUTTON_OFF:String = "buttonOff";
        public static const BUTTON_ON:String = "buttonOn";
        public var pos:Number;
        private var mc:MovieClip;
        private var mc_clicked:Boolean = false;

        public function Button(value:MovieClip)
        {
            this.mc = value;
            this.mc.stop();
            this.mc.mouseChildren = false;
            this.init();
        }

        public function get enabled() : Boolean
        {
            return _enabled;
        }

        private function mc_out(event:MouseEvent) : void
        {
            if (!_enabled)
            {
                return disabled_state();
            }
            if (!mc_clicked)
            {
                mc.gotoAndStop(1);
            }
            mc.removeEventListener(MouseEvent.MOUSE_UP, mc_up);
        }

        private function mc_up(event:MouseEvent) : void
        {
            if (!_enabled)
            {
                return disabled_state();
            }
            if (!mc_clicked)
            {
                on();
            }
            else
            {
                off();
            }
        }

        private function disabled_state() : void
        {
            mc.gotoAndStop(3);
        }

        public function off(dispatch:Boolean = true) : void
        {
            mc.gotoAndStop(1);
            mc_clicked = false;
            if (dispatch)
            {
                dispatchEvent(new Event(BUTTON_OFF));
            }
        }

        private function init() : void
        {
            mc.addEventListener(MouseEvent.MOUSE_OVER, mc_over);
            mc.addEventListener(MouseEvent.MOUSE_OUT, mc_out);
            mc.addEventListener(MouseEvent.MOUSE_DOWN, mc_down);
        }

        public function set enabled(value:Boolean) : void
        {
            _enabled = value;
            if (!_enabled)
            {
                return disabled_state();
            }
        }

        private function mc_down(event:MouseEvent) : void
        {
            if (!_enabled)
            {
                return disabled_state();
            }
            mc.gotoAndStop(3);
        }

        private function mc_over(event:MouseEvent) : void
        {
            if (!_enabled)
            {
                return disabled_state();
            }
            if (!mc_clicked)
            {
                mc.gotoAndStop(2);
            }
            mc.addEventListener(MouseEvent.MOUSE_UP, mc_up);
        }

        public function on() : void
        {
            mc.gotoAndStop(3);
            mc_clicked = true;
            dispatchEvent(new Event(BUTTON_ON));
        }

    }
}
