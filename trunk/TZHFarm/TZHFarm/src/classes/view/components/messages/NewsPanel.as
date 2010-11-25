package classes.view.components.messages
{
	import classes.model.AppDataProxy;
	import classes.utils.Algo;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	
	import tzh.DisplayUtil;
	import tzh.UIEvent;
	import tzh.core.ExternalUI;
	import tzh.core.Image;
	
	
	/**
	 * HandleTransactionResultCommand 这里要处理数据的返回
	 * AppDataProxy要处理数据的添加,删除等操作
	 * 
	 * DateUtil提供了一个转化的方法
	 * 
	 * 添加新的留言之后,留言是不能删除的,直到留言返回回来,添加成功之后,需要返回具体的留言的ID
	 * 
	 * 把原来没有用到的接口修改掉,这样就不用删除了
	 * 
	 * 这里还是选择重新create的方式吧,也消耗不了太大的性能.
	 * 
	 * 
	 * 需要调整页面
	 * 
	 * 明天需要做的
	 * 	1.做好图标,调整图标的功能
	 *  2.调整位置
	 *  3.调整后台的消息功能
	 *  4.好友状态的调整
	 * 
	 */ 
	public class NewsPanel extends ExternalUI
	{
		public static const SKIN:String = "Skin";
		
		protected var clsName:String;
		
		private static const PAGE_SIZE:int = 3;
		
		private var last_send_time:Number = 0;// 上一次发送的时间
		
		private static const validate_time:Number = 2;
		
		private static const BTN_NAME:String = "btn_";
		
		private var _ui:MovieClip;
		
		public function NewsPanel()
		{
			clsName = flash.utils.getQualifiedClassName(this).split("::")[1];
			this.path = clsName;
			this.addEventListener(Event.ADDED_TO_STAGE,addToStageHandler);
			super();
		}
		
		private function addToStageHandler(event:Event):void {
			this.showOverlay();
			this.removeEventListener(Event.ADDED_TO_STAGE,addToStageHandler);
		}
		
		override protected function completeHandler(event:Event):void {
			var cls:Class = this.getDefinitionByName(clsName + SKIN);// 这里完成之后,是可以重写一个引用的,我们写类,然后flash里也跟着一个类就行了
			this._ui = new cls();
			this._ui.mainLeft.addEventListener(MouseEvent.CLICK,mainLeftHandler);
			this._ui.mainRight.addEventListener(MouseEvent.CLICK,mainRightHandler);
			this._ui.close_btn.addEventListener(MouseEvent.CLICK,closeHandler);
			this._ui.comments.post_btn.addEventListener(MouseEvent.CLICK,addMessageHandler);
			this._ui.comments.up.addEventListener(MouseEvent.CLICK,upPageHandler);
			this._ui.comments.down.addEventListener(MouseEvent.CLICK,downPageHandler);
			this.addChild(this._ui);
			this.commentsEnabled = false;
			this.addAllButtonEvent();
			this._ui.comments.commentText.maxChars = 120;
			this._ui.comments.commentText.multiline = false;     
			super.completeHandler(event);
		}
		
		private function removeAllListener():void {
			this._ui.mainLeft.removeEventListener(MouseEvent.CLICK,mainLeftHandler);
			this._ui.mainRight.removeEventListener(MouseEvent.CLICK,mainRightHandler);
			this._ui.close_btn.removeEventListener(MouseEvent.CLICK,closeHandler);
			this._ui.comments.post_btn.removeEventListener(MouseEvent.CLICK,addMessageHandler);
			this._ui.comments.up.removeEventListener(MouseEvent.CLICK,upPageHandler);
			this._ui.comments.down.removeEventListener(MouseEvent.CLICK,downPageHandler);
		}
		
		private function addAllButtonEvent():void {
			var news:MovieClip = this.ui.news as MovieClip;
			for(var i:int = 0; i < news.numChildren; i++){
				var child:DisplayObject = news.getChildAt(i);
				if(child is SimpleButton){
					if(child.name.indexOf(BTN_NAME) != -1){// 只有这样子才能购买
						child.addEventListener(MouseEvent.CLICK,buyHandler);
					}
				}
			}
		}
		
		private function buyHandler(event:MouseEvent):void {
			var target:SimpleButton = SimpleButton(event.currentTarget);
			var temp:String = target.name.slice(BTN_NAME.length,target.name.length);
			this._id = Number(temp);
			this.closeHandler();
			this.dispatchEvent(new UIEvent(UIEvent.BUY_ITEM));
		}
		
		private var _id:Number;
		
		public function get id():Number {
			return this._id;
		}
		
		public function center():void {
			DisplayUtil.center(this);
		}
		
		private function addMessageHandler(event:MouseEvent):void {
			if(Algo.time() - last_send_time > validate_time){// 必须要超过1秒才能发送
				this.dispatchEvent(new UIEvent(UIEvent.ADD_MESSAGE));
			}
			last_send_time = Algo.time();
		}
		
		public function clearText():void {
			this.ui.comments.commentText.text = "";
		}
		
		public function set commentsEnabled(value:Boolean):void {
			this.ui.comments.commentText.mouseEnabled = value;
			this.ui.comments.post_btn.mouseEnabled = value;	
		}	
		
		private var _data:Object;
		
		public function set data(value:Object):void {
			this._data = value;
		}
		
		public function get data():Object {
			return this._data;
		}
		
		public function get message():String {
			return this.ui.comments.commentText.text;
		}
		
		protected function get ui():MovieClip {
			return this._ui;
		}
		
		protected function closeHandler(event:MouseEvent = null):void {
			super.hideOverlay();
			this.dispatchEvent(new UIEvent(UIEvent.CLOSE_EVENT));
			this.removeAllListener();
			this.removeAllRender();
			DisplayUtil.removeAllChildren(this);
			DisplayUtil.removeChild(this.parent,this);
		}
		
		private function mainLeftHandler(event:MouseEvent):void {
			this.ui.news.visible = true;
			this.ui.comments.visible = false;
		}
		
		private function mainRightHandler(event:MouseEvent):void {
			this.ui.news.visible = false;
			this.ui.comments.visible = true;
		}
		
		private function pageVisible():void {
			if(this.mode == AppDataProxy.FRIEND_MODE){
				this.ui.mainLeft.visible = false;
				this.ui.mainRight.visible = false;
				this.ui.news.visible = false;
				this.ui.comments.visible = true;
			}else {
				this.ui.news.visible = true;
				this.ui.comments.visible = true;
				this.ui.mainLeft.visible = true;
				this.ui.mainRight.visible = true;
			}
		}
		
		/**
		 * 刷新数据时,都是刷回到第一页的
		 */ 
		public function refresh():void {
			this.clearText();
			this.commentsEnabled = true;
			var list:Array = this.data as Array;
			if(list){
				this.maxPage = Math.ceil(list.length / PAGE_SIZE);
				this.currentPage = 1;
				this.draw(this.getMessageByPage());
			}
		}
		
		private var renders:Array = [];
		
		private function draw(value:Array):void {
			this.checkButtonEnabled();
			var startX:Number = this.ui.comments.cont_bounds.x + 5;// 这里的位置需要调整一下
			var vGap:Number = 5;
			var startY:Number = this.ui.comments.cont_bounds.y + vGap;
			this.removeAllRender();
			var renderCls:Class = this.getDefinitionByName("classes.view.components.messages.MessageRender") as Class;
			for(var i:int = 0; i < value.length; i++){
				var messageRender:MessageRender = new renderCls();
				messageRender.data = value[i];
				messageRender.x = startX;
				messageRender.y = startY;
				this.ui.comments.addChild(messageRender);
				renders.push(messageRender);
				startY += messageRender.height + vGap;
			}
		}
		
		private function removeAllRender():void {
			while(renders.length > 0){
				var messageRender:MessageRender = renders.shift();
				DisplayUtil.removeAllChildren(messageRender);
				DisplayUtil.removeChild(messageRender.parent,messageRender);
			}
		}
		
		/**
		 * 向上向下的按纽是否可以点
		 */ 
		public function checkButtonEnabled():void {
			if(maxPage <= 1){
				this.ui.comments.up.mouseEnabled = false;
				this.ui.comments.down.mouseEnabled = false;
				return;
			}
			if(currentPage >= maxPage){
				this.ui.comments.up.mouseEnabled = true;
				this.ui.comments.down.mouseEnabled = false;
			}else if(currentPage <= 1){
				this.ui.comments.up.mouseEnabled = false;
				this.ui.comments.down.mouseEnabled = true;
			}else {
				this.ui.comments.up.mouseEnabled = true;
				this.ui.comments.down.mouseEnabled = true;
			}
		}
		
		private var currentPage:int = 1;
		private var maxPage:int = 1;
		private function upPageHandler(event:MouseEvent):void {
			currentPage--;
			this.draw(this.getMessageByPage());
		}
		
		private function downPageHandler(event:MouseEvent):void {
			currentPage++;
			this.draw(this.getMessageByPage());
		}
		
		/**
         * 根据页数和页的大小,取得具体的数据
         * @param page:int 页数,初始值是0
         * @param pageSize:int default 3
         */ 
        public function getMessageByPage():Array {
        	var result:Array = [];
        	var messages:Array = this.data as Array;
        	if(messages){
        		result = messages.slice((this.currentPage - 1) * PAGE_SIZE, this.currentPage * PAGE_SIZE);// 取出来的数据有可能是空的
        	}
        	return result;
        }
        
        private var _userInfo:Object;
        public function set userInfo(value:Object):void {
        	this._userInfo = value;
        	this.ui.comments.username.text = value.name;// 留着用
        	var image:Image = new Image(value.pic,this.ui.comments.photo_mask);
        	this.ui.comments.photo_mask.addChild(image);
        }
        
        public function get userInfo():Object {
        	return this._userInfo;
        }
        
        private var _mode:String;
        
        public function set mode(value:String):void {
        	this._mode = value;
        	this.pageVisible();
        }
        
        public function get mode():String {
        	return this._mode;
        }
	}
}