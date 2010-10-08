package classes.view.components.map
{
    import classes.utils.*;
    import flash.display.*;
    import flash.events.*;

    public class BreadMachine extends MultiProcessor
    {
        private var milk_player:TimelinePlayer;
        private var bread_player:TimelinePlayer;
        private var flames_anim:Array;
        private var last_played:String;
        private var flames_player:TimelinePlayer;
        private var smoke_anim:Array;
        private var anim_end:Array;
        private var smoke_player:TimelinePlayer;
        private var show_bread_anim:Array;
        private var breads:Number = 0;

        public function BreadMachine(value:Object)
        {
            smoke_anim = [[1, 20]];
            flames_anim = [[2, 31]];
            anim_end = [[1]];
            show_bread_anim = [[TimelinePlayer.CURRENT_FRAME, 31]];
            milk_player = new TimelinePlayer();
            smoke_player = new TimelinePlayer();
            flames_player = new TimelinePlayer();
            bread_player = new TimelinePlayer();
            smoke_player.addEventListener(TimelinePlayer.FINISH, smokeFinished);
            flames_player.addEventListener(TimelinePlayer.FINISH, flamesFinished);
            bread_player.addEventListener(TimelinePlayer.FINISH, breadFinished);
            smoke_player.set_fps(20);
            flames_player.set_fps(20);
            super(value);
            selected_raw_material = 0;
        }

        override protected function init_asset() : void
        {
            mc.milk_levels.visible = false;
            milk_player.set_mc(mc.milk);
            smoke_player.set_mc(mc.smoke);
            flames_player.set_mc(mc.flames);
            super.init_asset();
        }

        override protected function queue_highlight_by_raw_material(milk_levels:Number) : void
        {
            if (milk_levels == 0 || milk_levels == 1)
            {
                return super.queue_highlight_by_raw_material(milk_levels);
            }
            if (process_count["feed" + (milk_levels + 1)] > 0)
            {
                mc.milk_levels.visible = true;
                mc.milk_levels.gotoAndStop(process_count["feed" + (milk_levels + 1)] + raw_materials[milk_levels].length);
                mc.milk_levels.alpha = 0.5;
                Effects.green(mc.milk_levels);
            }
            return;
        }

        override protected function start_anim() : void
        {
            flames_player.play(flames_anim);
            smoke_player.play(smoke_anim);
            last_played = "flames";
            return;
        }

        private function breadFinished(event:Event) : void
        {
            if (breads >= products.length)
            {
                return;
            }
            breads++;
            if (breads > 3)
            {
                return;
            }
            if (!mc)
            {
                return;
            }
            mc.product["product" + breads].visible = true;
            bread_player.set_mc(mc.product["product" + breads]);
            bread_player.play(show_bread_anim);
            return;
        }

        override protected function update_product_area() : void
        {
            if (mc)
            {
                mc.product["product" + "1"].visible = false;
                mc.product["product" + "2"].visible = false;
                mc.product["product" + "3"].visible = false;
                if (products.length >= 1)
                {
                    mc.product["product" + "1"].visible = true;
                    bread_player.set_mc(mc.product["product" + "1"]);
                    bread_player.play(show_bread_anim);
                    breads = 1;
                    Effects.clear(mc.product["product" + "1"]);
                }
                else
                {
                    mc.product["product" + "1"].gotoAndStop(1);
                    mc.product["product" + "2"].gotoAndStop(1);
                    mc.product["product" + "3"].gotoAndStop(1);
                }
                if (products.length >= 2)
                {
                    mc.product["product" + "2"].visible = true;
                    Effects.clear(mc.product["product" + "2"]);
                }
                else
                {
                    mc.product["product" + "2"].gotoAndStop(1);
                    mc.product["product" + "3"].gotoAndStop(1);
                }
                if (products.length >= 3)
                {
                    mc.product["product" + "3"].visible = true;
                    Effects.clear(mc.product["product" + "3"]);
                }
                else
                {
                    mc.product["product" + "3"].gotoAndStop(1);
                }
                queue_highlight();
            }
            return;
        }

        override protected function update_raw_material(milk_levels:Number) : void
        {
            if (milk_levels == 0 || milk_levels == 1)
            {
                return super.update_raw_material(milk_levels);
            }
            if (!mc)
            {
                return;
            }
            Effects.clear(mc.milk);
            if (!process_count["feed" + (milk_levels + 1)])
            {
                mc.milk_levels.visible = false;
            }
            if (raw_materials[milk_levels].length > 0)
            {
                milk_player.play([[TimelinePlayer.CURRENT_FRAME, raw_materials[milk_levels].length * 10]]);
            }
            else
            {
                milk_player.play([[TimelinePlayer.CURRENT_FRAME, 1]]);
            }
            queue_highlight();
            return;
        }

        private function smokeFinished(event:Event) : void
        {
            if (next_product_in() > 0)
            {
                smoke_player.play(smoke_anim);
            }
            else
            {
                smoke_player.play(anim_end, false);
            }
            return;
        }

        override protected function get_refill_area(update_raw_material:Number) : MovieClip
        {
            if (update_raw_material == 3)
            {
                return super.get_refill_area(update_raw_material);
            }
            if (!mc)
            {
                return null;
            }
            if (!mc["raw_material" + update_raw_material])
            {
                return null;
            }
            return mc["raw_material" + update_raw_material];
        }

        override protected function on_product_complete() : void
        {
            super.on_product_complete();
            return;
        }

        override protected function get collect_hit_area() : MovieClip
        {
            if (!mc)
            {
                return null;
            }
            return mc.product;
        }

        private function flamesFinished(event:Event) : void
        {
            if (next_product_in() > 0)
            {
                flames_player.play(flames_anim);
            }
            else
            {
                flames_player.play(anim_end, false);
            }
            return;
        }

        override protected function get_refill_hit_area(update_raw_material:Number) : MovieClip
        {
            if (update_raw_material == 3)
            {
                return super.get_refill_area(update_raw_material);
            }
            if (!mc)
            {
                return null;
            }
            if (!mc["raw_material" + update_raw_material])
            {
                return null;
            }
            return mc["raw_material" + update_raw_material];
        }

    }
}
