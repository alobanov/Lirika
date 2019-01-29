//
//  About+Structures.swift
//  CoordinatorExperiment
//
//  Created by Lobanov Aleksey on 17/01/2019.
//  Copyright (c) 2019 Lobanov Aleksey. All rights reserved.

import Foundation
import RxSwift

extension AboutViewModel {
  
  enum OutputModuleActionType {
    case showSomething
  }
  
  // MARK: - initial module data
  struct ModuleInputData {
    
  }
  
  // MARK: - module input structure
  struct ModuleInput {
    
  }
  
  // MARK: - module output structure
  struct ModuleOutput {
    let moduleAction: Observable<OutputModuleActionType>
  }
  
}
