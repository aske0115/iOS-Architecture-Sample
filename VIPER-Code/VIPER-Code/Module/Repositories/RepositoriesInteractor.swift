//
//  RepositoriesInteractor.swift
//  VIPER-Code
//
//  Created giftbot on 2017. 10. 10..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import Foundation

protocol RepositoriesInteractorInputProtocol: class {
  // Presenter -> Interactor
  var currentSetting: ServiceSetting { get }
  func requestRepositoriesData()
  func changeServiceSetting(to serviceSetting: ServiceSetting)
}

// MARK: - Class Implementation

final class RepositoriesInteractor: RepositoriesInteractorInputProtocol {
  
  // MARK: Properties
  
  weak var presenter: RepositoriesInteractorOutputProtocol!
  
  var currentSetting: ServiceSetting
  private let gitHubService: GitHubServiceType
  
  // MARK: Initializing
  
  init(service: GitHubServiceType, serviceSetting: ServiceSetting) {
    gitHubService = service
    currentSetting = serviceSetting
  }
  
  // MARK: RepositoriesInteractorInputProtocol
  
  func changeServiceSetting(to serviceSetting: ServiceSetting) {
    currentSetting = serviceSetting
    currentSetting.encoded()
  }
  
  func requestRepositoriesData() {
    gitHubService.fetchGitHubRepositories(by: currentSetting) { [weak self] result in
      guard let `self` = self else { return }
      DispatchQueue.main.async {
        switch result {
        case .success(let repositories):
          self.presenter.setRepositories(repositories)
        case .error(let error):
          self.presenter.didReceivedError(error)
        }
      }
    }
  }
}
