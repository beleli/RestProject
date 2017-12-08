//
//  PostRoute.swift
//  TasksApp
//
//  Created by Aloc SP06447 on 06/12/2017.
//  Copyright © 2017 Aloc SP06447. All rights reserved.
//

import Foundation
import EasyRest

enum PostRoute: Routable {
    
    case login(String, String)
    case getTasks
    case saveTask(TaskItem)
    case editTask(String, TaskItem)
    case deleteTask(String)
    
    var rule: Rule {
        switch self {
        case let .login(username, password):
            return Rule(method: .post, path: "/oauth/token/", isAuthenticable: true, parameters: [.query:
                [
                    "client_id": "6unozdxbSSRqubiEcHrrlCC6unQgaE7QTsGYJBWq",
                    "client_secret": "WEUBbQpAeNzvXUXnO8YU00DoNHCOtNaKsc5aFdWhrKmIdXtlj5ZnngYEgGqHD2rA42Iv87zFCLkieVQewdFT8qVcIvrF4mPqbA6zZpJXxzZgVv2SJIUIyEemyPO2XpT8",
                    "grant_type": "password",
                    "username": username,
                    "password": password
                ]
                ])

        case .getTasks:
            return Rule(method: .get, path: "/v1/tasks/", isAuthenticable: false, parameters: [:])
            
        case let .saveTask(task):
            return Rule(method: .post, path: "/v1/tasks/", isAuthenticable: false, parameters: [.body: task])
        
        case let .editTask(id, task):
            return Rule(method: .put, path: "/v1/tasks/\(id)/", isAuthenticable: false, parameters: [.body: task])
            
        case let .deleteTask(id):
            return Rule(method: .delete, path: "/v1/tasks/\(id)/", isAuthenticable: false, parameters: [:])

        }
    }
}
