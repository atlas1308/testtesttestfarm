package classes.view.components.map
{
    import classes.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;

    public class JamMachine extends MultiProcessor
    {
        private var work_anim:Array;
        private var close_valve:Array;
        private var work_player:TimelinePlayer;
        private var open_valve:Array;
        private var last_played:String;
        private var prep_honey_interval:Number;
        private var work_anim_loop:Array;
        private var honey_player:TimelinePlayer;
        private var prep_jam_interval:Number;
        private var work_anim_end:Array;
        private var valve_player:TimelinePlayer;
        private var honey_updated:Boolean = false;
        private var valve_opened:Boolean = false;

        public function JamMachine(param1:Object)
        {
            work_anim = [[1, 68]];
            work_anim_loop = [[53, 68]];
            work_anim_end = [[68, 75]];
            open_valve = [[1, 6]];
            close_valve = [[6, 1]];
            honey_player = new TimelinePlayer();
            work_player = new TimelinePlayer();
            valve_player = new TimelinePlayer();
            work_player.addEventListener(TimelinePlayer.FINISH, workFinished);
            honey_player.addEventListener(TimelinePlayer.FINISH, honeyFinished);
            super(param1);
            return;
        }

        override protected function init_asset() : void
        {
            mc.honey_levels.visible = false;
            honey_player.set_mc(mc.honey);
            work_player.set_mc(mc.anim);
            valve_player.set_mc(mc.valve_anim);
            mc.raw_material = selected_raw_material + 1;
            mc.anim.funnels.gotoAndStop(mc.raw_material);
            super.init_asset();
            return;
        }

        override protected function queue_highlight_by_raw_material(a:Number) : void
        {
            if (a == 0)
            {
                return super.queue_highlight_by_raw_material(a);
            }
            if (process_count["feed" + (a + 1)] > 0)
            {
                mc.honey_levels.visible = true;
                mc.honey_levels.gotoAndStop(process_count["feed" + (a + 1)] + raw_materials[a].length);
                mc.honey_levels.alpha = 0.5;
                Effects.green(mc.honey_levels);
            }
            return;
        }

        override protected function start_anim() : void
        {
            var _loc_1:* = next_stage_in() * 1000 - 1000;
            var _loc_2:* = next_stage_in() * 1000 - 1000;
            if (_loc_1 > 10)
            {
                clearTimeout(prep_jam_interval);
                prep_jam_interval = setTimeout(prepare_jam_anim, _loc_1);
                if (!is_updating)
                {
                    if (mc)
                    {
                        mc.raw_material = get_used_raw_material_index() + 1;
                    }
                    last_played = "work";
                    work_player.play(work_anim);
                }
            }
            else
            {
                prepare_jam_anim();
            }
            if (_loc_2 > 0)
            {
                clearTimeout(prep_honey_interval);
                prep_honey_interval = setTimeout(prepare_honey_anim, _loc_2);
            }
            else
            {
                prepare_honey_anim();
            }
            return;
        }

        private function prepare_honey_anim() : void
        {
            valve_player.play(open_valve);
            valve_opened = true;
            honey_player.play([[TimelinePlayer.CURRENT_FRAME, raw_materials[1].length-- * 10]]);
            honey_updated = true;
            return;
        }

        override protected function update_raw_material(a:Number) : void
        {
            if (a == 0)
            {
                return super.update_raw_material(a);
            }
            if (!mc)
            {
                return;
            }
            Effects.clear(mc.honey);
            if (!process_count["feed" + (a + 1)])
            {
                mc.honey_levels.visible = false;
            }
            if (!honey_updated)
            {
                honey_player.set_fps(24);
                if (raw_materials[a].length > 0)
                {
                    honey_player.play([[TimelinePlayer.CURRENT_FRAME, raw_materials[a].length * 10]]);
                }
                else
                {
                    honey_player.play([[TimelinePlayer.CURRENT_FRAME, 1]]);
                }
            }
            queue_highlight();
            return;
        }

        private function prepare_jam_anim() : void
        {
            last_played = "finish";
            work_player.stop(false);
            work_player.play(work_anim_end);
            return;
        }

        override public function set_raw_material(a:Number) : void
        {
            super.set_raw_material(a);
            if (next_product_in() <= 0)
            {
                if (mc)
                {
                    mc.anim.funnels.gotoAndStop(a + 1);
                }
            }
            return;
        }

        private function workFinished(event:Event) : void
        {
            if (next_product_in() > 0 && last_played != "finish")
            {
                last_played = "work";
                work_player.play(work_anim_loop);
            }
            else if (mc)
            {
                mc.anim.funnels.gotoAndStop(selected_raw_material + 1);
            }
            return;
        }

        override protected function on_product_complete() : void
        {
            super.on_product_complete();
            honey_updated = false;
            return;
        }

        override protected function get_refill_area(index:Number) : MovieClip
        {
            if (index == 1)
            {
                return super.get_refill_area(index);
            }
            if (!mc)
            {
                return null;
            }
            if (!mc["refill_area" + index])
            {
                return null;
            }
            return mc["refill_area" + index].jar;
        }

        private function honeyFinished(event:Event) : void
        {
            if (valve_opened)
            {
                valve_player.play(close_valve);
                valve_opened = false;
            }
            return;
        }

    }
}
