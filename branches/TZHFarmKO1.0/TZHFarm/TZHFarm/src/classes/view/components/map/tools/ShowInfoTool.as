package classes.view.components.map.tools
{
    import classes.view.components.map.*;

    public class ShowInfoTool extends Tool
    {

        public function ShowInfoTool()
        {
        }

        override protected function mouseOut() : void
        {
            hide_tip();
        }

        override protected function mouseOver() : void
        {
            if (target as MapObject)
            {
                tip(target.get_name());
            }
        }

        override public function remove() : void
        {
            hide_tip();
        }

    }
}
