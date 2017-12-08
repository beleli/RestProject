//
//  PostService.swift
//  TasksApp
//
//  Created by Aloc SP06447 on 06/12/2017.
//  Copyright © 2017 Aloc SP06447. All rights reserved.
//

import Foundation
import EasyRest
import Genome


class PostService: Service<PostRoute> {
    
    override var base: String {return "http://localhost:8000/api"}
    
    override var interceptors: [Interceptor]? {
        get {
            return [AuthInterceptor()]
        }
    }
    
    func getLogin(username: String, password: String,
                  onSuccess: @escaping (Response<Login>?) -> Void,
                  onError: @escaping (RestError?) -> Void,
                  always: @escaping () -> Void) {
        try! call(.login(username, password), type: Login.self, onSuccess: onSuccess,
                  onError: onError, always: always)
    }
    
    func getTasks(onSuccess: @escaping (Response<TaskList>?) -> Void,
                  onError: @escaping (RestError?) -> Void,
                  always: @escaping () -> Void) {
        try! call(.getTasks, type: TaskList.self, onSuccess: onSuccess,
                  onError: onError, always: always)
    }
    
    func saveTask(task: TaskItem,
                  onSuccess: @escaping (Response<TaskItem>?) -> Void,
                  onError: @escaping (RestError?) -> Void,
                  always: @escaping () -> Void) {
        try! call(.saveTask(task), type: TaskItem.self, onSuccess: onSuccess,
                  onError: onError, always: always)
    }
    
    func editTask(id: String, task: TaskItem,
                  onSuccess: @escaping (Response<TaskItem>?) -> Void,
                  onError: @escaping (RestError?) -> Void,
                  always: @escaping () -> Void) {
        try! call(.editTask(id, task), type: TaskItem.self, onSuccess: onSuccess,
                  onError: onError, always: always)
    }
    
    func deleteTask(id: String,
                  onSuccess: @escaping (Response<TaskItem>?) -> Void,
                  onError: @escaping (RestError?) -> Void,
                  always: @escaping () -> Void) {
        try! call(.deleteTask(id), type: TaskItem.self, onSuccess: onSuccess,
                  onError: onError, always: always)
    }
    
    
}

class Login: BaseModel {
    var access_token: String?
    var expires_in: String?
    var token_type: String?
    var scope: String?
    var refresh_token: String?
    
    override func sequence(_ map: Map) throws {
        try access_token <~> map["access_token"]
        try expires_in <~> map["expires_in"]
        try token_type <~> map["token_type"]
        try scope <~> map["scope"]
        try refresh_token <~> map["refresh_token"]
    }
    
}

class TaskList: BaseModel {
    var count: Int?
    var next: String?
    var previous: String?
    var results: [TaskItem]?
    
    override func sequence(_ map: Map) throws {
        try count <~> map["count"]
        try next <~> map["next"]
        try previous <~> map["previous"]
        try results <~> map["results"]
    }
}

class TaskItem: BaseModel {
    var id: String?
    var expiration_date: String?
    var title: String?
    var descricao: String?
    var is_complete: Bool?
    var owner: String?
    
    override func sequence(_ map: Map) throws {
        try id <~> map["id"]
        try expiration_date <~> map["expiration_date"]
        try title <~> map["title"]
        try descricao <~> map["description"]
        try is_complete <~> map["is_complete"]
        try owner <~> map["owner"]
    }
}


