package classes.view.components.friends_list
{
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    import flash.text.*;
    
    import tzh.core.Image;
    import tzh.core.TextFieldUtil;
	
	/**
	 * 这里的skin会有跳帧的问题
	 */ 
    public class FriendContainer extends MovieClip
    {
        public var level:TextField;
        public var friend_name:TextField;
        public var bg_over:MovieClip;
        public var add_neighbor:TextField;
        public var is_visited:Boolean = false;
        public var photo_mask:MovieClip;
        public var exp:TextField;
        private var data:Object;
        public var loading:MovieClip;

        public function FriendContainer(value:Object)
        {
            this.createChildren();
            this.data = value;
            this.init();
        }
        
        private var skin:FriendContainerSkin;
        public function createChildren():void {
        	this.skin = this.addChild(new FriendContainerSkin()) as FriendContainerSkin;
        	this.level = this.skin.level;
        	this.friend_name = this.skin.friend_name;
        	this.bg_over = this.skin.bg_over;
        	this.add_neighbor = this.skin.add_neighbor;
        	this.photo_mask = this.skin.photo_mask;
        	this.exp = this.skin.exp;
        	this.loading = this.skin.loading;
        	var textFormat:TextFormat = new TextFormat();
        	textFormat.font = new Tahoma().fontName;
        	this.friend_name.defaultTextFormat = textFormat;
        }

        public function update(value:Object):void
        {
            this.data = value;
            this.init();
        }

        private function photoComplete(event:Event) : void
        {
            var image:Image = event.target as Image;
            var ww:Number = photo_mask.width;
            var hh:Number = photo_mask.height;
            photo_mask.addChild(image); 
            image.x = (ww - image.width) / 2;
            image.y = (hh - image.height) / 2;
            this.loading.visible = false;
        }

        public function mark_as_visited() : void
        {
            bg_over.visible = true;
            is_visited = true;
        }

        private function init() : void
        {
            bg_over.visible = false;
            this.loading.visible = true;
            if (data.add_neighbor)
            {
                this.skin.gotoAndStop(2);
                return;
            }
            if (data.not_loaded)
            {
                this.skin.loading.visible = true;
                return;
            }
            this.skin.gotoAndStop(1);
            friend_name.text = String(data.name);
            TextFieldUtil.truncateToFit(friend_name,this.skin.width);
            level.text = String(data.level);
            exp.text = String(data.exp);
            var image:Image = new Image(data.pic,photo_mask);
            image.addEventListener(Event.COMPLETE, photoComplete);
	        image.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
	        mouseChildren = false;
            addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
            addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
        }
        
		private function ioErrorHandler(event:IOErrorEvent):void{
        	trace("loader error " + data.pic);
        	this.loading.visible = false;
        }
        
        public function get id():String
        {
            return data.uid;
        }

        public function mark_as_not_visited() : void
        {
            bg_over.visible = false;
            is_visited = false;
        }

        public function is_neighbor() : Boolean
        {
            return !data.add_neighbor;
        }

        private function mouseOver(event:MouseEvent) : void
        {
            bg_over.visible = true;
        }

        private function mouseOut(event:MouseEvent) : void
        {
            if (!is_visited)
            {
                bg_over.visible = false;
            }
        }

        public function not_loaded() : Boolean
        {
            return data.not_loaded;
        }

    }
}
