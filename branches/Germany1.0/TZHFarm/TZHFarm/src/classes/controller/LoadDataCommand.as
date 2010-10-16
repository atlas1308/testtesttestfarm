package classes.controller
{
    import classes.model.*;
    
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.command.*;
    
    import tzh.core.JSDataManager;

    public class LoadDataCommand extends SimpleCommand implements ICommand
    {

        public function LoadDataCommand()
        {
        }

        override public function execute(value:INotification) : void
        {
            var proxy:TransactionProxy = facade.retrieveProxy(TransactionProxy.NAME) as TransactionProxy;
            var fids:String = JSDataManager.getInstance().fids;
            trace("fids " + fids);
            CONFIG::debug {
            	fids = "sandbox.developer.studivz.net:AQFuSMjPJaGwFvfv0pOB-w,sandbox.developer.studivz.net:CF4fo7vmvS1WtR-9BWeH5Q,sandbox.developer.studivz.net:u-mcxK71YUt6QrOx2yIsFQ,sandbox.developer.studivz.net:P_06_OXHrM0wEke4iQr-9Q,sandbox.developer.studivz.net:A9yBgx8b60c8uVZjCCGlGQ,sandbox.developer.studivz.net:2JlGCq3BjaB58BbJtvIZRA,sandbox.developer.studivz.net:Zu46tjW-vApDiaRiv0NgvA,sandbox.developer.studivz.net:qHpqUsAMSYqfb3GNgcWzig,sandbox.developer.studivz.net:X6QADWDp8ZQ5FizscTIl_w,sandbox.developer.studivz.net:KRqyGfXFwriwfwvGvocEfw,sandbox.developer.studivz.net:QfMkd1SUyI0m_CIclwDL2g,sandbox.developer.studivz.net:x4-cHuI4W0neIwUhuP4XQQ,sandbox.developer.studivz.net:0y2CsrwRQPoXcZF6VbUjsw,sandbox.developer.studivz.net:a6LdDSq75KiVTtr5jmAbng,sandbox.developer.studivz.net:zKy0__24yTzmk4zdzuKyQQ,sandbox.developer.studivz.net:Wz5jLMReJtE8mMp9MtbHdw,sandbox.developer.studivz.net:B-NAJv4SVxWIRDmWEeBRMQ,sandbox.developer.studivz.net:vdUAvmyyDlEI4Cz7jF6VfQ,sandbox.developer.studivz.net:yszQ9RVC99HA7C8MOGk7Rg,sandbox.developer.studivz.net:A_qFPbsqM8gFuGEcpkQapQ,sandbox.developer.studivz.net:2heEncS0YJO9erKYGtQbSg,sandbox.developer.studivz.net:k7OhD6tE6cboRCZ_zXYXEQ,sandbox.developer.studivz.net:BhEyM855wmjnQrRXGIGFww,sandbox.developer.studivz.net:x1gyVfO5XkpGrDxTqGfZKg,sandbox.developer.studivz.net:OnZdRS0oNxnxm2-fOXDKdg,sandbox.developer.studivz.net:-RGvO1LfAYlBuuTZIzXdyQ,sandbox.developer.studivz.net:SAatQKNXLyJ392k_ZqMicw,sandbox.developer.studivz.net:j58vklPX3J_txbqaJjWmHQ,sandbox.developer.studivz.net:nMCJxrBHD70ArUc1nuKwxg,sandbox.developer.studivz.net:3PHJ2dGhHzrU8FnB2MABDg,sandbox.developer.studivz.net:uc0PocW9Rp1E6n_qnRDPhA,sandbox.developer.studivz.net:MlVXCu797yViI3i-uHtrHQ,sandbox.developer.studivz.net:4yvdC4ILegGpWGc-9M_26w,sandbox.developer.studivz.net:qTIxJGj4WUi7k-J6LCtpvA,sandbox.developer.studivz.net:J_JZIjghO7_NqSfFuk4D1w,sandbox.developer.studivz.net:k7OhD6tE6cboRCZ_zXYXEQ,sandbox.developer.studivz.net:BhEyM855wmjnQrRXGIGFww,sandbox.developer.studivz.net:x1gyVfO5XkpGrDxTqGfZKg,sandbox.developer.studivz.net:OnZdRS0oNxnxm2-fOXDKdg,sandbox.developer.studivz.net:-RGvO1LfAYlBuuTZIzXdyQ,sandbox.developer.studivz.net:SAatQKNXLyJ392k_ZqMicw,sandbox.developer.studivz.net:j58vklPX3J_txbqaJjWmHQ,sandbox.developer.studivz.net:nMCJxrBHD70ArUc1nuKwxg,sandbox.developer.studivz.net:3PHJ2dGhHzrU8FnB2MABDg,sandbox.developer.studivz.net:uc0PocW9Rp1E6n_qnRDPhA,sandbox.developer.studivz.net:MlVXCu797yViI3i-uHtrHQ,sandbox.developer.studivz.net:4yvdC4ILegGpWGc-9M_26w,sandbox.developer.studivz.net:qTIxJGj4WUi7k-J6LCtpvA,sandbox.developer.studivz.net:J_JZIjghO7_NqSfFuk4D1w";
            }
            var params:Object = new Object();
            params.fids = fids;
            proxy.add(new TransactionBody("retrieve_data", "retrieve",params));
        }

    }
}
