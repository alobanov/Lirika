// Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import Foundation
import RxCocoa
import RxSwift
import UIKit

enum ControllerFlowRoute: Route {
  case setup, close
}

class ControllerFlowCoordinator: ControllerCoordinator<ControllerFlowRoute>, CoordinatorOutput {
  func configure() -> Output {
    return Output(exit: exit.asDriver(onErrorJustReturn: ()))
  }

  struct Output {
    let exit: Driver<Void>
  }

  private let exit = PublishRelay<Void>()
  private let pageFlow = PublishRelay<Void>()
  fileprivate let bag = DisposeBag()

  override func drive(route: ControllerFlowRoute, completion _: PresentationHandler?) {
    switch route {
    case .setup:
      let page = pageCoord()
      startCoordinator(page)
      router.add(page.presentable())

    case .close:
      if let coord = child(presentId: "Onboard") {
        router.remove(coord.presentable())
      }
      exit.accept(())
    }
  }

  override func start() {
    trigger(.setup)
  }

  override func configureRootViewController() {
    guard let view = router.container().view else {
      return
    }

    view.backgroundColor = UIColor.white

    let rec1 = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 200))
    rec1.backgroundColor = .gray
    view.addSubview(rec1)

    rec1.snp.makeConstraints { make in
      make.bottom.equalTo(-100)
      make.centerX.equalToSuperview()
      make.size.equalTo(400)
    }

    let rec = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
    rec.backgroundColor = .red
    view.addSubview(rec)

    rec.snp.makeConstraints { make in
      make.top.equalTo(200)
      make.centerX.equalToSuperview()
      make.size.equalTo(300)
    }
  }

  deinit {
    print("Dead ControllerFlowCoordinator")
  }
}

extension ControllerFlowCoordinator {
  fileprivate func pageCoord() -> Coordinatorable {
    let container = LirikaPage.Container(style: .scroll, orientation: .horizontal)
    let root = LirikaPage(container: container)

    let pageCoord = PageFlowCoordinator(container: root, initialRoute: .prepareFirstPage)
    pageCoord.define(coordinatorCustomPresentId: "Onboard")
    let output = pageCoord.configure()

    output.exit.asDriver(onErrorJustReturn: ()).drive(onNext: { [weak pageCoord, weak self] in
      pageCoord?.presentable().removeFromParent()
      self?.removeChild(pageCoord)
      self?.trigger(.close)
    }).disposed(by: bag)

    return pageCoord
  }
}
