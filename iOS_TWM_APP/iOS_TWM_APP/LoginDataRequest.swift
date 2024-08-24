//
//  LoginDataRequest.swift
//  iOS_TWM_APP
//
//  Created by 小妍寶 on 2024/8/23.
//

import Foundation
import UIKit
import Alamofire


class LoginDataRequest {
    
    //let loginVC = LoginViewController()
    //let mapVC = MapVC()
    
    var token: String = ""

    
    func registerData(userID: String, password: String) {
        let parameters: [String: Any] =
        [
            "userName": userID,
            "email": "\(UUID().uuidString)",
            "password": password
        ]
        
        let url = "https://fastapi-production-a532.up.railway.app/register"
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["accept": "application/json", "Content-Type": "application/json"]).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let decodeData = try decoder.decode(Register.self, from: data)
                    print(decodeData)
                } catch {
                    print("fail")
                }
            case .failure(let error):
                print("bb")
            }
            
        }
    }
    
    func loginData(userID: String, password: String, completion: @escaping (String?) -> Void) {
        
        let parameters: [String: String] = [
            "grant_type": "",
            "username": userID,
            "password": password,
            "scope": "",
            "client_id": "",
            "client_secret": ""
        ]
            AF.request("https://fastapi-production-a532.up.railway.app/login",
                       method: .post,
                       parameters: parameters,
                       encoding: URLEncoding.default,
                       headers: ["accept": "application/json", "Content-Type": "application/x-www-form-urlencoded"]).responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let decodeData = try decoder.decode(Login.self, from: data)
                        print("Decoded Response: \(decodeData)")
                        self.token = decodeData.accessToken
                        self.getInformation(self.token)
                        self.getMockData(self.token)
                        completion(self.token)
                        
 
                        
                    } catch let decodingError {
                        print("Decoding Error: \(decodingError)")
                        
                    }
                case .failure(let error):
                    print("Error: \(error)")
                    
                }
            }
        
    }
    
    func getInformation(_ token: String) {
        let headers: HTTPHeaders = [
             "Authorization": "Bearer \(token)",
             "accept": "application/json"
         ]

         AF.request("https://fastapi-production-a532.up.railway.app/info",
                    method: .get, headers: headers).responseData { response in
             switch response.result {
             case .success(let data):
                 do {
                     let decoder = JSONDecoder()
                     let decodeData = try decoder.decode(Register.self, from: data)
                     print("Decoded Response: \(decodeData)")
                 } catch let decodingError {
                     print("Decoding Error: \(decodingError)")
                 }
             case .failure(let error):
                 print("Error: \(error)")
             }
         }
     }
    
    func getMockData(_ token: String) {
        let headers: HTTPHeaders = [
             "Authorization": "Bearer \(token)",
             "accept": "application/json"
         ]

         AF.request("https://fastapi-production-a532.up.railway.app/Info/",
                    method: .get, headers: headers).responseData { response in
             switch response.result {
             case .success(let data):
                 do {
                     let decoder = JSONDecoder()
                     let decodeData = try decoder.decode(MockData.self, from: data)
                     print("MockData Response: \(decodeData)")
                 } catch let decodingError {
                     print("Decoding Error: \(decodingError)")
                 }
             case .failure(let error):
                 print("Error: \(error)")
             }
         }
     }
    
}
