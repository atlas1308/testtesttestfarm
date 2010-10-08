package classes.view.components.map
{
    import classes.utils.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;

    public class PackingMachine extends MultiProcessor
    {
        private var button_pressed_anim:Array;
        private var button_realeased_anim:Array;
        private var pack_player:TimelinePlayer;
        private var button_player:TimelinePlayer;
        private var anim_player:TimelinePlayer;
        private var work_loop:Array;
        private var work_end_frame:Array;
        private var last_played:String;
        private var end_interval:Number;
        private var work_end:Array;
        private var work_start:Array;
        private var show_pack_anim:Array;
        private var packs:Number = 0;

        public function PackingMachine(param1:Object)
        {
            button_pressed_anim = [[2, 8]];
            button_realeased_anim = [[9, 15], 1];
            work_start = [[2, 243]];
            work_loop = [[134, 243]];
            work_end = [[244, 271]];
            work_end_frame = [272];
            show_pack_anim = [[TimelinePlayer.CURRENT_FRAME, 35]];
            anim_player = new TimelinePlayer();
            button_player = new TimelinePlayer();
            pack_player = new TimelinePlayer();
            anim_player.addEventListener(TimelinePlayer.FINISH, animFinished);
            button_player.addEventListener(TimelinePlayer.FINISH, buttonFinished);
            pack_player.addEventListener(TimelinePlayer.FINISH, packFinished);
            super(param1);
            return;
        }

        override protected function init_asset() : void
        {
            anim_player.set_mc(mc.anim1, mc.anim2, mc.anim3, mc.anim4);
            button_player.set_mc(mc.red_button);
            mc.raw_material = selected_raw_material + 1;
            super.init_asset();
            return;
        }

        private function finish_anim() : void
        {
            anim_player.stop(false);
            anim_player.play(work_end);
            last_played = "work_end";
            button_player.play(button_realeased_anim);
            return;
        }

        private function buttonFinished(event:Event) : void
        {
            if (last_played == "button_pressed")
            {
                anim_player.play(work_start);
                last_played = "work_start";
            }
            return;
        }

        override protected function get_refill_area(get_product_frame:Number) : MovieClip
        {
            if (!mc)
            {
                return null;
            }
            return mc.raw_material1.glow_area;
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
                    mc.product.product1.raw_material = get_product_frame(0);
                    packs = 1;
                    Effects.clear(mc.product["product" + "1"]);
                    if (mc.product.product1.currentFrame == 1)
                    {
                        trace("play pack");
                        pack_player.set_mc(mc.product["product" + "1"]);
                        pack_player.play(show_pack_anim);
                        if (!anim_player.is_playing() || last_played == "work_end")
                        {
                            trace("hide pack");
                            anim_player.play(work_end_frame, false);
                        }
                    }
                    else
                    {
                        packFinished(null);
                    }
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

        override protected function start_anim() : void
        {
            var _loc_1:* = next_stage_in() * 1000 - 1400;
            if (_loc_1 > 0)
            {
                clearTimeout(end_interval);
                if (!is_updating)
                {
                    if (mc)
                    {
                        mc.raw_material = get_used_raw_material_index() + 1;
                    }
                    button_player.play(button_pressed_anim);
                    last_played = "button_pressed";
                }
                end_interval = setTimeout(finish_anim, _loc_1);
            }
            else
            {
                anim_player.play(work_end);
                last_played = "work_end";
            }
            return;
        }

        override public function set_raw_material(a:Number) : void
        {
            super.set_raw_material(a);
            if (next_product_in() <= 0)
            {
                if (mc)
                {
                    mc.raw_material1.cap.gotoAndStop(a + 1);
                }
            }
            return;
        }

        private function packFinished(event:Event) : void
        {
            if (packs >= products.length)
            {
                return;
            }
            packs++;
            if (packs > 3)
            {
                return;
            }
            if (!mc)
            {
                return;
            }
            mc.product["product" + packs].visible = true;
            pack_player.set_mc(mc.product["product" + packs]);
            var temp:int = packs - 1;
            mc.product["product" + packs].raw_material = get_product_frame(temp);
            if (mc.product["product" + packs].currentFrame == 1)
            {
                trace("play pack");
                if (!anim_player.is_playing() || last_played == "work_end")
                {
                    trace("hide pack");
                    anim_player.play(work_end_frame, false);
                }
                pack_player.play(show_pack_anim);
            }
            else
            {
                packFinished(null);
            }
        }

        private function animFinished(event:Event) : void
        {
            if (last_played == "work_loop" || last_played == "work_start")
            {
                if (next_stage_in() > 0)
                {
                    anim_player.play(work_loop);
                    last_played = "work_loop";
                }
            }
            if (last_played == "work_end")
            {
                if (mc)
                {
                    mc.raw_material1.cap.gotoAndStop(selected_raw_material + 1);
                }
            }
            return;
        }

    }
}
