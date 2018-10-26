import UIKit

extension Scene {
    func viewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        switch self {
            
        case .home(let homeViewModel):
            let nc = storyboard.instantiateViewController(withIdentifier: "Start-Scene") as! UINavigationController
            var svc = nc.viewControllers.first as! TweetsHomeViewController
            svc.bindViewModel(to: homeViewModel)
            return nc
        }
    }
}
