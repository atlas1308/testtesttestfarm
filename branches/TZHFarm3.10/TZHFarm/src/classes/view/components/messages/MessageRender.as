package classes.view.components.messages
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import tzh.core.DateUtil;
	import tzh.core.Image;
	import tzh.core.JSDataManager;
	
	/**
	 * 很小的面板,没有什么可以修改的
	 */ 
	public class MessageRender extends MovieClip
	{
		public var commentText:TextField;
        public var username:TextField;
        public var photo_mask:MovieClip;
        public var timeText:TextField;
        
		public function MessageRender()
		{
			super();
		}
		
		private var _data:Object;
		
		public function set data(value:Object):void {
			this._data = value;
			this.commentText.text = value.msg;
			this.timeText.text = DateUtil.getFormatterDate(value.msgtime);
			var userInfo:Object = JSDataManager.getInstance().getUserInfoById({uid:data.fuid});
			if(userInfo){
				this.username.text = userInfo.name;
				var image:Image = new Image(userInfo.pic,this.photo_mask,false);
				this.photo_mask.addChild(image)
			} 
			CONFIG::debug{
				var image:Image = new Image("http://avatar.profile.csdn.net/6/E/8/1_sandy945.jpg",this.photo_mask,false);
				this.photo_mask.addChild(image);
			}
		}
		
		public function get data():Object {
			return this._data;
		}
		
	}
}