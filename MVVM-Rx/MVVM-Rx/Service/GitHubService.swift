//
//  GitHubService.swift
//  MVC-Code
//
//  Created by giftbot on 2017. 9. 27..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import RxCocoa
import RxSwift

struct GitHubService: GitHubServiceType {
  
  // MARK: Properties
  
  private let session: URLSession
  
  // MARK: Initialize
  
  init(session: URLSession = URLSession.shared) {
    self.session = session
  }
  
  // MARK: DataTask

  func fetchGitHubRepositories(by setting: ServiceSetting) -> Single<[Repository]> {
    let baseUrl  = "https://api.github.com/search/repositories?q="
    let language = "language:\(setting.language)"
    let userID   = setting.userID == .all ? "" : "+user:\(setting.userID)"
    let sortType = "&sort=\(setting.sortType)"
    
    guard let url = URL(string: baseUrl + language + userID + sortType) else {
      return .error(ServiceError.urlTransformFailed)
    }
    
    return session.rx.dataTask(request: URLRequest(url: url))
      .map { data throws in
        let repositories = try data.decode(Repositories.self)
        return repositories.items
      }
  }
}
