# Lirika
Тут надо описать что такое и зачем вообще нужен этот самый координатор

### Общий пример. Корневой координатор на базе UIWindow (Он же LirikaWindow):

```swift
class MyWindow: LirikaWindow.Container {
  // это собственный класс UIWindow в который можно добавить свою логику
  // ниже смотри как его использовать при инициализации координатора
}

enum AppRoute: Route {
  case root
}

class AppCoordinator: WindowCoordinator<AppRoute> {
  override func drive(route: AppRoute, completion: PresentationHandler?) {
    switch route {
    case .root:
      let controller = UIViewController()
      router.setRoot(controller: controller)
      router.makeKeyAndVisible()
    }
  }

  override func start() {
    trigger(.root) // Вызываем нужный путь для создания транзишна
  }

  override func configureRootViewController() {
    // Тут можно настроить окружение и контейнер, вызывается сразу после старта
    router.container() // Так можно обратиться к контейнеру, в данном примере это UIWindow
  }

  override func deepLink(link: DeepLink) {
    switch link {
    case let item as? ConcreteDeepLink:
      // выполняем переход через trigger(.action)
    default:
      break
    }
  }
}
```

#### Как использовать AppCoordinator, на примере AppDelgate:

```swift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  private lazy var coordinator = AppCoordinator(container: LirikaWindow(container: MyWindow()))

  func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    coordinator.start()
    return true
  }
}

```

---

## Базовые координаторов:

1. ControllerCoordinator - `UIViewController`
2. PageCoordinator - `UIPageViewController`
3. WindowCoordinator - `UIWindow`
4. NavigationCoordinator - `UINavigationController`
5. TabBarCoordinator - `UITabBarController`

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
