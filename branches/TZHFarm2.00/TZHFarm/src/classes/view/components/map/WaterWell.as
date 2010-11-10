package classes.view.components.map
{
    import classes.utils.*;
    
    import flash.events.*;

    public class WaterWell extends MapObject
    {
        private var anim_player:TimelinePlayer;
        private var well_depth:Object;
        private var waterdrops_player:TimelinePlayer;
        public static const CHECK_IRRIGATION:String = "checkIrrigation";

        public function WaterWell(value:Object)
        {
            anim_player = new TimelinePlayer();
            waterdrops_player = new TimelinePlayer();
            anim_player.addEventListener(TimelinePlayer.FINISH, animFinish);
            well_depth = value.depth ? (value.depth) : ({});
            super(value);
        }

        override protected function init_asset() : void
        {
            if (!under_construction)
            {
                anim_player.set_mc(mc.anim);
                waterdrops_player.set_mc(mc.water_drops);
                update_drops_level();
            }
            super.init_asset();
        }

        public function get_next_upgrade_level_depth() : Number
        {
            return well_depth[upgrade_level + 1];
        }

        private function animFinish(event:Event) : void
        {
            dispatchEvent(new Event(CHECK_IRRIGATION));
        }

        public function hide_upgrade_level_anim() : void
        {
            if (waterdrops_player.is_playing())
            {
                waterdrops_player.stop(false);
            }
            var temp:int = upgrade_level - 1;
            waterdrops_player.play([[TimelinePlayer.CURRENT_FRAME, temp * 1 + 2]]);
        }

        public function start_anim() : void
        {
            if (anim_player.is_playing())
            {
                return;
            }
            anim_player.play([[1, 60], [61, 115, 4], [115, 145], -30000]);
        }

        override protected function init() : void
        {
            super.init();
            loader.cache_swf = true;
        }

        public function show_upgrade_level_anim() : void
        {
            if (waterdrops_player.is_playing())
            {
                waterdrops_player.stop(false);
            }
            //waterdrops_player.play([[TimelinePlayer.CURRENT_FRAME, 5-- * 1 + 2]]);
        }

        private function update_drops_level() : void
        {
            waterdrops_player.play([upgrade_level-- * 1 + 2]);
        }

        override protected function on_upgrade() : void
        {
            update_drops_level();
        }

    }
}
