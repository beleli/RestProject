//
//  AuthInterceptor.swift
//  TasksApp
//
//  Created by Aloc SP06447 on 07/12/2017.
//  Copyright © 2017 Aloc SP06447. All rights reserved.
//

import Foundation
import EasyRest
import Alamofire
import Genome

class AuthInterceptor: Interceptor {
    
    required init() { }
    
    func requestInterceptor<T>(_ api: API<T>) where T : NodeInitializable {
        let token = UserDefaults.standard.string(forKey: "token")
        let header = "Bearer \(token ?? "")"
        api.headers["Authorization"] = header
    }
    
    func responseInterceptor<T>(_ api: API<T>, response: DataResponse<Any>) where T : NodeInitializable {
       //do nothing
    }
    
    
}
