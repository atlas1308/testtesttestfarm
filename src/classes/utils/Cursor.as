package classes.utils {
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.ui.Mouse;
	import flash.utils.getDefinitionByName;
	
	/**
	 * 类似于一个CursorManager的一个东西,
	 * 主要是控制场景里的cursor
	 */ 
    public dynamic class Cursor {
		move_cur;
		plow_cur;
		remove_cur;
        public static var pointer:Sprite;
        public static var stage:Stage;
        public static var offset_x:Number;
        public static var offset_y:Number;
        public static var last_cursor:String;

        public static function pointerLoaded(event:Event):void{
            pointer.addChild(event.target.asset);
        }
        
        public static function mouse_move(event:Event = null):void{
            pointer.x = (pointer.stage.mouseX + offset_x);
            pointer.y = (pointer.stage.mouseY + offset_y);
        }
        
        public static function hide():void{
            Mouse.show();
            last_cursor = "";
            if (((pointer) && (pointer.stage))){
                pointer.stage.removeEventListener(Event.ENTER_FRAME, mouse_move);
                pointer.parent.removeChild(pointer);
            }
        }
        
        public static function show(type:String, is_url:Boolean=false, offset_x:Number=0, offset_y:Number=0, hide_mouse:Boolean=false):void{
            var ClassReference:Class;
            var cache:Cache;
            if (hide_mouse){
                Mouse.hide();
            }
            if (last_cursor == type){
                return;
            };
            last_cursor = type;
            Cursor.offset_x = offset_x;
            Cursor.offset_y = offset_y;
            if (((pointer) && (pointer.stage))){
                pointer.stage.removeEventListener(Event.ENTER_FRAME, mouse_move);
                pointer.parent.removeChild(pointer);
            };
            if (!is_url){
                ClassReference = (getDefinitionByName(type) as Class);
                pointer = new (ClassReference)();
                switch (type){
                    case "":
                        break;
                    case "hand":
                        break;
                    case "grab":
                        break;
                }
            } else {
                pointer = new Sprite();
                cache = new Cache();
                cache.addEventListener(Cache.LOAD_COMPLETE, pointerLoaded);
                cache.load(type);
            }
            pointer.mouseEnabled = false;
            pointer.mouseChildren = false;
            stage.addChild(pointer);
            pointer.stage.addEventListener(Event.ENTER_FRAME, mouse_move);
            mouse_move();
        }
    }
}
