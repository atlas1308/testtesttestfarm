package jam_machine_fla
{
    import flash.display.*;

    dynamic public class animatie_2 extends MovieClip
    {
        public var funnels:MovieClip;

        public function animatie_2()
        {
            addFrameScript(0, this.frame1, 1, this.frame2);
            return;
        }// end function

        function frame1()
        {
            stop();
            return;
        }// end function

        function frame2()
        {
            this.funnels.gotoAndStop(MovieClip(parent).raw_material);
            return;
        }// end function

    }
}
