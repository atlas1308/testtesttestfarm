package classes.utils.particles {

    public class SoilParticle extends Particle {

        public function SoilParticle(){
            super();
        }
        override protected function init():void{
            if (int((Math.random() * 2)) == 1){
                color = 657419;
                particle_skin = 7;
            } else {
                color = 0x2C1100;
                particle_skin = 8;
            };
            super.init();
        }

    }
}
