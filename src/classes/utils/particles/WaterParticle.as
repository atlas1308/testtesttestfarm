package classes.utils.particles {

    public class WaterParticle extends Particle {

        public function WaterParticle(){
            super();
        }
        override protected function init():void{
            particle_skin = 5;
            super.init();
        }

    }
}
