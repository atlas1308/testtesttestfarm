package jam_machine_fla
{
    import flash.display.*;

    dynamic public class MainTimeline extends MovieClip
    {
        public var honey:MovieClip;
        public var extra_hit_area:MovieClip;
        public var refill_hit_area2:MovieClip;
        public var anim:MovieClip;
        public var raw_material1:MovieClip;
        public var valve_anim:MovieClip;
        public var switch_hit_area:MovieClip;
        public var raw_material:Number;
        public var collect_hit_area:MovieClip;
        public var product:MovieClip;
        public var honey_levels:MovieClip;
        public var switch_area:MovieClip;
        public var refill_area1:MovieClip;
        public var refill_area2:MovieClip;

        public function MainTimeline()
        {
            addFrameScript(0, this.frame1);
            return;
        }// end function

        function frame1()
        {
            this.raw_material = 3;
            return;
        }// end function

    }
}
