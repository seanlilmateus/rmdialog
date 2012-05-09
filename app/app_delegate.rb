class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launch_opts)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    rmdialog_controller = RMDialogViewController.alloc.init
    nav = UINavigationController.alloc.initWithRootViewController(rmdialog_controller)
    @window.rootViewController = nav
    @window.makeKeyAndVisible
    true
  end  
end
