# Lirika
Coordinator + RxMVVM

## init

Создание рутового координатора:

```swift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  let window: UIWindow! = UIWindow()
  private lazy var appCoordinator: AppCoordinator = self.coordinator()
  
  func coordinator() -> AppCoordinator {
    return AppCoordinator(window: window, initialRoute: .authorization)
  }

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    appCoordinator.start()
    return true
  }
}
```

Создание базового координатора:

```swift
enum SampleRoute: Route {  
  case screenOne, screenTwo, back
}

class SampleCoordinator: NavigationCoordinator<SampleRoute>, CoordinatorOutput {
  func configure() -> SampleCoordinator.Output {
    return Output(exampleAction: outputAction.asObservable())
  }
  
  struct Output {
    let logout: Observable<Void>
  }
  
  private let outputAction = PublishSubject<Void>()
  
  override func prepare(route: AboutRoute, completion: PresentationHandler?) {
    switch route {
    case .screenOne:
      router.set([q()], animated: false, completion: completion)
    case .screenTwo:
      outputAction.onNext(())
    case .back:
      router.pop(toRoot: false, completion: completion)
    }
  }
```

## Install

```
source 'https://github.com/alobanov/ALSpec.git'
source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!
platform :ios, '10.0'

target 'Proj' do
  inhibit_all_warnings!
  pod 'Lirika', :git => 'https://github.com/alobanov/Lirika.git', :branch => 'master'
end
```
