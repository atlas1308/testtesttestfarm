package classes.view.components.popups
{
	import mx.resources.ResourceManager;
	
	/**
	 * 确认的话,跳转到商店
	 * 如果取消的话,所有的自动化的工具,全部变成手动
	 */ 
	public class AcceptShowShopPopup extends DynamicPopup
	{
		public function AcceptShowShopPopup()
		{
			super(400, 190, 300, 110, ResourceManager.getInstance().getString("message","appcet_snapshot_popup_message"));
		}
		
	}
}