//
//  Service.swift
//  FoodPlaniOS
//
//  Created by Muhammad Ali on 17/03/2022.
//

import Foundation
import Combine
import MultipartForm
import Alamofire
struct NetworkError: Error {
    let initialError: String
    //  let backendError: BackendError?
}
//protocol ServiceProtocol {
//    func fetchData<T:Codable>(url:String,method:String,isHeaderToke:Bool) -> AnyPublisher<T,NetworkError>
//}


class Service {
    
    
    static let shared = Service()
    private init() { }
    
    func fetchData<T:Codable>(url:String,method:String="GET",isHeaderToke:Bool=false,parameters:[String:String]=[:]) -> AnyPublisher<DataResponse<T, NetworkError>, Never> {
        let url : URLConvertible  = URL(string: url)!
        //var request = URLRequest(url: url)
        var headers : HTTPHeaders = [
            "Content-Type":"application/json"
        ]
        if let user : LoginDataModel = UserDefaults.standard.get(StringKeys.saveUserKey) {
            headers.add(name: "Authorization", value: "Bearer \(user.accessToken ?? "")")
        }
        return AF.request(url, method: HTTPMethod.init(rawValue: method), parameters: parameters.isEmpty == true ? nil : parameters, encoder:.json, headers: headers)
            .validate()
            .publishDecodable(type: T.self)
            .map { response in
                response.mapError { error in
                    if error.responseCode == 500{
                        return NetworkError(initialError:StringKeys.authError)
                    }else{
                        let backendError = response.data.flatMap { try? JSONDecoder().decode(BasicModel.self, from: $0)}
                        return NetworkError(initialError:  backendError?.message ?? error.localizedDescription)
                    }
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
    }
    
    func uploadFormData<T:Codable>(url:String,method:String="GET",isHeaderToke:Bool=false,parameters:[String:String]=[:],imgData:Data)-> AnyPublisher<DataResponse<T, NetworkError>, Never>
    
    {
        var headers : HTTPHeaders = [
            "Content-Type":"application/json"
        ]
        if let user : LoginDataModel = UserDefaults.standard.get(StringKeys.saveUserKey) {
            headers.add(name: "Authorization", value: "Bearer \(user.accessToken ?? "")")
        }
        
        
        return AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "imageUrl",fileName: "userProfile.jpg", mimeType: "image/jpg")
            for (key, value) in parameters {
                multipartFormData.append(value.data(using:.utf8)!, withName: key)
            }
        }, to: url,method: HTTPMethod.init(rawValue: method),headers:headers)
            .validate()
            .publishDecodable(type: T.self)
            .map { response in
                response.mapError { error in
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BasicModel.self, from: $0)}
                    return NetworkError(initialError: backendError?.message ?? error.localizedDescription)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
