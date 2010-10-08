package classes.view.components {
    import classes.utils.Cursor;
    import classes.view.components.friends_list.*;
    
    import com.greensock.TweenLite;
    
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    
	/**
	 * 好友列表应该测试
	 */ 
    public class FriendsList extends Sprite {

        public const LOAD_NEIGHBORS:String = "loadNeighbors";
        public const FRIEND_CLICKED:String = "friendClicked";
        public const ADD_NEIGHBOR:String = "addNeighbor";

        public var friends_to_load:Array;
        private var container:Sprite;
        public var left:SimpleButton;
        private var last_visited:FriendContainer;
        public var right:SimpleButton;
        public var left_end:SimpleButton;
        private var mask_cont:Sprite;
        public var double_right:SimpleButton;
        private var anim_start:Boolean = false;
        public var container_placeholder:MovieClip;
        public var right_end:SimpleButton;
        public var double_left:SimpleButton;
        public var bounds:MovieClip;
        private var item_w:Number;
        public var uid:Number;
        private var target_x:Number;
        private var min_x:Number;
        private var max_x:Number;
        private var slide_tween:TweenLite;
        private var _w:Number;

        public function FriendsList(){
            super();
            this.createChildren();
            this.init();
        }
        
        public var skin:FriendsListSkin;
        public function createChildren():void {
			this.skin = this.addChild(new FriendsListSkin()) as FriendsListSkin;
			this.container_placeholder = this.skin.container_placeholder;
			this.bounds = this.skin.bounds;
			this.double_left = this.skin.double_left;
			this.double_right = this.skin.double_right;
			this.left = this.skin.left;
			this.left_end = this.skin.left_end;
			this.right = this.skin.right;
			this.right_end = this.skin.right_end;
        }
		
		public function destory():void {
			
		}
		
        public function clear_visited_friend():void{
            if (last_visited){
                last_visited.mark_as_not_visited();
            }
        }
        
        private function double_slideLeft(e:MouseEvent):void{
            slide_container((3 * item_w));
        }
        
        private function init():void{
            container = new Sprite();
            addChild(container);
            mask_cont = new Sprite();
            addChild(mask_cont);
            left.addEventListener(MouseEvent.MOUSE_UP, slideLeft);
            right.addEventListener(MouseEvent.MOUSE_UP, slideRight);
            double_left.addEventListener(MouseEvent.MOUSE_UP, double_slideLeft);
            double_right.addEventListener(MouseEvent.MOUSE_UP, double_slideRight);
            left_end.addEventListener(MouseEvent.MOUSE_UP, end_slideLeft);
            right_end.addEventListener(MouseEvent.MOUSE_UP, end_slideRight);
            addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
        }
        
        public function update_friends(list:Array):void{
            var friend:FriendContainer;
            var j:Number;
            var i:Number = 0;
            while (i < container.numChildren) {
                friend = (container.getChildAt(i) as FriendContainer);
                if (friend.not_loaded()){
                    j = 0;
                    while (j < list.length) {
                        if (friend.id == list[j].uid){
                            friend.update(list[j]);
                        };
                        j++;
                    };
                };
                i++;
            };
        }
        
        private function double_slideRight(e:MouseEvent):void{
            slide_container((-3 * item_w));
        }
        
        private function friendClicked(e:MouseEvent):void{
            if (last_visited){
                last_visited.mark_as_not_visited();
            };
            var friend:FriendContainer = FriendContainer(e.target);
            if (friend.is_neighbor()){
                uid = friend.id;
                friend.mark_as_visited();
                last_visited = friend;
                dispatchEvent(new Event(FRIEND_CLICKED));
            } else {
                dispatchEvent(new Event(ADD_NEIGHBOR));
            };
        }
        
        private function load_neighbors():void{
            var friend:FriendContainer;
            var p:Point;
            friends_to_load = new Array();
            var start:Point = localToGlobal(new Point(container_placeholder.x, 0));
            var end:Point = localToGlobal(new Point((container_placeholder.x + container_placeholder.width), 0));
            var i:Number = 0;
            while (i < container.numChildren) {
                friend = (container.getChildAt(i) as FriendContainer);
                p = container.localToGlobal(new Point(friend.x, 0));
                if ((((p.x >= start.x)) && ((p.x <= end.x)))){
                    if (friend.not_loaded()){
                        friends_to_load.push(friend.id);
                    };
                };
                i++;
            };
            if (friends_to_load.length){
                dispatchEvent(new Event(LOAD_NEIGHBORS));
            };
        }
        
        private function slide(e:Event):void{
            container.x = (container.x + ((target_x - container.x) / 4));
            if (Math.abs((container.x - target_x)) < 1){
                container.x = target_x;
                anim_start = false;
                removeEventListener(Event.ENTER_FRAME, slide);
                load_neighbors();
            };
        }
        
        private function mouseMove(e:MouseEvent):void{
            Cursor.hide();
        }
        
        public function update(data:Object):void{
            var obj:Object;
            var friend:FriendContainer;
            while (container.numChildren) {
                container.removeChildAt(0);
            };
            Log.add("step1");
            var i:Number = 0;
            while (i < (data.length + 7)) {
                if (i < data.length){
                    obj = data[i];
                } else {
                    obj = new Object();
                    obj.add_neighbor = true;
                };
                friend = new FriendContainer(obj);
                container.addChild(friend);
                item_w = friend.width;
                friend.mouseChildren = false;
                friend.buttonMode = true;
                friend.x = (-(i) * friend.width);
                friend.addEventListener(MouseEvent.CLICK, friendClicked);
                i++;
            };
            var max_items:Number = int((container_placeholder.width / item_w));
            var _w:Number = container_placeholder.width;
            var padd_w:Number = ((_w - (max_items * item_w)) / 2);
            container.x = (((container_placeholder.x + container_placeholder.width) - item_w) - padd_w);
            container.y = ((container_placeholder.height - container.height) / 2);
            Log.add("step4");
            mask_cont.graphics.clear();
            mask_cont.graphics.beginFill(0, 1);
            mask_cont.graphics.drawRect(0, 0, (max_items * item_w), container_placeholder.height);
            mask_cont.graphics.endFill();
            mask_cont.y = container.y;
            mask_cont.x = (container_placeholder.x + padd_w);
            container.mask = mask_cont;
            target_x = container.x;
            min_x = container.x;
            max_x = (min_x + (item_w * data.length));
        }
        
        private function end_slideRight(e:MouseEvent):void{
            slide_container((min_x - target_x));
        }
        
        private function slideLeft(e:MouseEvent):void{
            slide_container(item_w);
        }
        
        private function tweenFinish():void{
            load_neighbors();
        }
        
        private function slideRight(e:MouseEvent):void{
            slide_container(-(item_w));
        }
        
        private function slide_container(delta:Number):void{
            target_x = (target_x + delta);
            if (target_x > max_x){
                target_x = max_x;
            };
            if (target_x < min_x){
                target_x = min_x;
            };
            TweenLite.killTweensOf(container);
            slide_tween = TweenLite.to(container, 0.25, {
                x:target_x,
                onComplete:tweenFinish
            });
        }
        
        private function end_slideLeft(e:MouseEvent):void{
            slide_container((max_x - target_x));
        }
    }
}
