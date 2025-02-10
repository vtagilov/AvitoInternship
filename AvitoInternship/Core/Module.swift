import UIKit

protocol View: UIViewController { }
protocol Interactor { }
protocol Presenter { }
protocol Router { }
protocol Context { }

protocol Module {
    associatedtype V: View
    associatedtype I: Interactor
    associatedtype P: Presenter
    associatedtype R: Router

    var view: V { get }
    var interactor: I { get }
    var presenter: P { get }
    var router: R { get }
}

protocol ModuleFactory {
    associatedtype ViewController: UIViewController
    associatedtype ModuleContext: Context

    func makeModule(_ context: ModuleContext) -> any Module
}
