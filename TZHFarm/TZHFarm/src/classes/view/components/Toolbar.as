package classes.view.components
{
    import classes.IChildren;
    import classes.utils.*;
    import classes.view.components.toolbar.*;
    
    import flash.display.*;
    import flash.events.*;
    
    import mx.resources.ResourceManager;
    
    import tzh.core.Constant;
    import tzh.core.Cookies;
    import tzh.core.SoundManager;

    public class Toolbar extends Sprite implements IChildren
    {
        public var message:String;
        public static const MOVE_ON:String = "moveOn";
        public static const ZOOM_IN:String = "zoomIn";
        public static const REMOVE_OFF:String = "removeOff";
        public static const STORAGE_OFF:String = "storageOff";
        public static const PLOW_OFF:String = "plowOff";
        public static const GIFTS_ON:String = "giftsOn";
        public static const TAKE_SNAPSHOT:String = "takeSnapshot";
        public static const PLOW_ON:String = "plowOn";
        public static const BACK_TO_MY_RANCH:String = "backToMyRanch";
        public static const STORAGE_ON:String = "storageOn";
        public static const SHOP_OFF:String = "shopOff";
        public static const MULTI_TOOL_OFF:String = "multiToolOff";
        public static const REMOVE_ON:String = "removeOn";
        public static const TOGGLE_ALPHA:String = "toggleAlpha";
        public static const SHOW_TOOLTIP:String = "showTooltip";
        public static const TOGGLE_FULL_SCREEN:String = "toggleFullScreen";
        public static const TURN_OFF_OR_ON_MUSIC:String = "turnOffOrOnMusic";
        public static const MULTI_TOOL_ON:String = "multiToolOn";
        public static const ZOOM_OUT:String = "zoomOut";
        public static const SHOP_ON:String = "shopOn";
        public static const ACHIEVEMENTS_OFF:String = "achievementsOff";
        public static const ACHIEVEMENTS_ON:String = "achievementsOn";
        public static const MOVE_OFF:String = "moveOff";
        public static const HIDE_TOOLTIP:String = "hideTooltip";
        public static const GITS_OFF:String = "giftsOff";
        
        
        private var events:Array;
        public var achievements:MovieClip;
        public var camera:SimpleButton;
        public var zoom_in_btn:SimpleButton;
        private var remove_btn:Button;
        public var gifts:MovieClip;
        private var events_off:Array;
        private var gifts_btn:Button;
        public var zoom_out_btn:SimpleButton;
        private var multi_tool_btn:Button;
        public var remove:MovieClip;
        private var plow_btn:Button;
        public var storage:MovieClip;
        private var storage_btn:Button;
        private var buttons:Array;
        private var shop_btn:Button;
        public var gifts_qty:MovieClip;
        public var fullscreen:SimpleButton;
        public var alpha_toggler:SimpleButton;
        private var achievements_btn:Button;
        private var events_on:Array;
        public var move:MovieClip;
        public var multi_tool:MovieClip;
        public var home:MovieClip;
        public var plow:MovieClip;
        private var move_btn:Button;
        public var shop:MovieClip;
        private var normal_mode:Boolean = true;
        private var home_btn:Button;
        private var music:MovieClip;
        
        public function Toolbar()
        {
        	this.createChildren();
            this.init();
        }
        
        private var skin:ToolbarSkin;
        public function createChildren():void {
        	skin = this.addChild(new ToolbarSkin()) as ToolbarSkin;
        	this.shop = this.skin.shop;
            this.remove = this.skin.remove;
            this.move = this.skin.move;
            this.multi_tool = this.skin.multi_tool;
            this.plow = this.skin.plow;
            this.storage = this.skin.storage;
            this.gifts = this.skin.gifts;
            this.achievements = this.skin.achievements;
            this.home = this.skin.home
            this.normal_mode = this.skin.normal_mode;
            this.gifts_qty = this.skin.gifts_qty;
            
            this.fullscreen = this.skin.fullscreen;
            this.alpha_toggler = this.skin.alpha_toggler;
            this.camera = this.skin.camera;
            this.zoom_in_btn = this.skin.zoom_in_btn;
            this.zoom_out_btn = this.skin.zoom_out_btn;
            this.music = this.skin.music;
            
            var hasCookies:Boolean = Cookies.hasCookies(Constant.BACKGROUND_KEY);
            var frame:int = 2;
            if(!hasCookies){// 如果没有cookies的话,默认的是可以播放的
            	frame = 1;
            }else {
            	var playSoundAbled:Boolean = Cookies.getCookies(Constant.BACKGROUND_KEY) as Boolean;// 如果有cookies就得判断是否可以播放了
            	if(playSoundAbled){// 可以播放
            		frame = 1;
            	}else {
            		frame = 2;
            	}
            }
            if(frame == 1){
            	SoundManager.getInstance().playSound(Constant.BACKGROUND_KEY,false);
            }
            this.music.gotoAndStop(frame);
        }
        
        public function get skinRef():MovieClip {
        	return this.skin;
        }
		
		public function destory():void {
		
		}

        private function init() : void
        {
            var buttonName:String = null;
            events = new Array(SHOP_ON, MOVE_ON, REMOVE_ON, MULTI_TOOL_ON, PLOW_ON, STORAGE_ON, GIFTS_ON, ACHIEVEMENTS_ON, BACK_TO_MY_RANCH);
            buttons = new Array("shop", "move", "remove", "multi_tool", "plow", "storage", "gifts", "achievements", "home");
            var index:Number = 0;
            while (index < buttons.length)
            {
                buttonName = buttons[index];
                this[buttonName + "_btn"] = new Button(this.skin[buttonName]);
                this[buttonName + "_btn"].pos = index;
                bind_button_events(this[buttonName + "_btn"]);
                index++;
            }
            this.zoom_in_btn.addEventListener(MouseEvent.CLICK, zoomIn);
            this.zoom_out_btn.addEventListener(MouseEvent.CLICK, zoomOut);
            this.fullscreen.addEventListener(MouseEvent.CLICK, toggleFullScreen);
            this.alpha_toggler.addEventListener(MouseEvent.CLICK, toggleAlpha);
            this.camera.addEventListener(MouseEvent.CLICK, takeSnapshot);
			this.music.addEventListener(MouseEvent.CLICK,turnOffOrOnMusic);
            
            this.set_normal_mode();
            this.gifts_qty.visible = false;
            this.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
            this.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
            this.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
        }
        
        private function turnOffOrOnMusic(event:MouseEvent):void {
        	if(this.music.currentFrame == 1){
        		this.music.gotoAndStop(2);
        		Cookies.addCookies(Constant.BACKGROUND_KEY,false);
        		SoundManager.getInstance().stopSound(Constant.BACKGROUND_KEY);
        	}else if(this.music.currentFrame == 2){
        		this.music.gotoAndStop(1);
        		Cookies.addCookies(Constant.BACKGROUND_KEY,true);
        		SoundManager.getInstance().playSound(Constant.BACKGROUND_KEY,false);
        	}
        }

        private function mouseMove(event:MouseEvent) : void
        {
            message = get_tool_message(event.target);
            dispatchEvent(new Event(SHOW_TOOLTIP));
        }

        public function enable_zoom_out() : void
        {
            return;
        }

        private function mouseOver(event:MouseEvent) : void
        {
            message = get_tool_message(event.target);
            dispatchEvent(new Event(SHOW_TOOLTIP));
            Cursor.hide();
        }

        private function bind_button_events(value:Button) : void
        {
            value.addEventListener(Button.BUTTON_ON, buttonON);
            value.addEventListener(Button.BUTTON_OFF, buttonOFF);
        }

        private function toggleFullScreen(event:MouseEvent) : void
        {
            dispatchEvent(new Event(TOGGLE_FULL_SCREEN));
            dispatchEvent(new Event(HIDE_TOOLTIP));
        }

        public function enable_zoom_in() : void
        {
            return;
        }

        private function zoomIn(event:MouseEvent) : void
        {
            dispatchEvent(new Event(ZOOM_IN));
        }

        public function disable_zoom_out() : void
        {
            return;
        }

        private function back_to_my_ranch(event:MouseEvent) : void
        {
            set_normal_mode();
            dispatchEvent(new Event(BACK_TO_MY_RANCH));
        }

        public function updateGiftsQty(pos:Number) : void
        {
            if (pos == 0)
            {
                gifts_qty.visible = false;
            }
            else
            {
                gifts_qty.visible = true;
                gifts_qty.qty.text = String(pos);
            }
        }

        private function mouseOut(event:MouseEvent) : void
        {
            dispatchEvent(new Event(HIDE_TOOLTIP));
        }

        private function toggleAlpha(event:MouseEvent) : void
        {
            dispatchEvent(new Event(TOGGLE_ALPHA));
        }

        private function takeSnapshot(event:MouseEvent) : void
        {
            dispatchEvent(new Event(TAKE_SNAPSHOT));
        }

        private function zoomOut(event:MouseEvent) : void
        {
            dispatchEvent(new Event(ZOOM_OUT));
        }

        public function set_normal_mode() : void
        {
            this.shop.visible = true;
            this.remove.visible = true;
            this.move.visible = true;
            this.multi_tool.visible = true;
            this.plow.visible = true;
            this.storage.visible = true;
            this.gifts.visible = true;
            this.achievements.visible = false;
            this.home.visible = false;
            this.normal_mode = true;
            this.multi_tool_btn.on();
        }

        private function buttonON(event:Event) : void
        {
            for each(var key:Object in buttons)
            {
                var button:Button = this[key.toString() + "_btn"];
                if (button !== event.target || key == "zoom_in" || key == "zoom_out")
                {
                    button.off(false);
                }
            }
            dispatchEvent(new Event(events[event.target.pos]));
        }

        private function get_tool_message(value:Object) : String
        {
            var str:String = null;
            switch(value)
            {
                case shop:
                {
                    str = ResourceManager.getInstance().getString("message","store_tooltip_message");
                    break;
                }
                case move:
                {
                    str = ResourceManager.getInstance().getString("message","move_tool_tooltip_message");
                    break;
                }
                case remove:
                {
                    str = ResourceManager.getInstance().getString("message","sell_tool_tooltip_message");;
                    break;
                }
                case plow:
                {
                    str = ResourceManager.getInstance().getString("message","plow_tool_tooltip_message");
                    break;
                }
                case home:
                {
                    str = ResourceManager.getInstance().getString("message","return_home_tooltip_message");
                    break;
                }
                case zoom_in_btn:
                {
                    str = ResourceManager.getInstance().getString("message","zoom_in_tooltip_message");
                    break;
                }
                case zoom_out_btn:
                {
                    str = ResourceManager.getInstance().getString("message","zoom_out_tooltip_message");
                    break;
                }
                case gifts:
                {
                    str = ResourceManager.getInstance().getString("message","gifts_tooltip_message");
                    break;
                }
                case storage:
                {
                    str = ResourceManager.getInstance().getString("message","barn_tooltip_message");
                    break;
                }
                case multi_tool:
                {
                    str = ResourceManager.getInstance().getString("message","multi_tool_tooltip_message");
                    break;
                }
                case fullscreen:
                {
                    str = ResourceManager.getInstance().getString("message","toggle_full_screen_tooltip_message");
                    break;
                }
                case alpha_toggler:
                {
                    str = ResourceManager.getInstance().getString("message","visiblity_trees_tooltip_message");
                    break;
                }
                case camera:
                {
                    str = ResourceManager.getInstance().getString("message","take_a_picture_tooltip_message");
                    break;
                }
                default:
                {
                    str = "";
                    break;
                }
            }
            return str;
        }

        public function deactivate_multi_tool() : void
        {
            multi_tool_btn.off(false);
        }

        public function disable_zoom_in() : void
        {
            return;
        }

        public function set_friend_view_mode() : void
        {
            shop.visible = false;
            remove.visible = false;
            move.visible = false;
            multi_tool.visible = false;
            plow.visible = false;
            storage.visible = false;
            gifts.visible = false;
            gifts_qty.visible = false;
            achievements.visible = false;
            home.visible = true;
            normal_mode = false;
        }

        public function refresh() : void
        {
            move_btn.off();
            remove_btn.off();
            shop_btn.off();
        }

        private function buttonOFF(event:Event) : void
        {
            this.multi_tool_btn.on();
        }

    }
}
