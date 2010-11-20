package classes.utils.particles {

    public class StarParticle extends Particle {

        public function StarParticle(){
            super();
        }
        override protected function init():void{
            particle_skin = 3;
            super.init();
        }

    }
}
