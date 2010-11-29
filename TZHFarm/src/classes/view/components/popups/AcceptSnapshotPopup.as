package classes.view.components.popups
{
	import mx.resources.ResourceManager;
	

    public class AcceptSnapshotPopup extends DynamicPopup
    {

        public function AcceptSnapshotPopup()
        {
            super(400, 190, 300, 110, ResourceManager.getInstance().getString("message","appcet_snapshot_popup_message"));
        }

    }
}
