//
//  Service.swift
//  FoodPlaniOS
//
//  Created by Muhammad Ali on 17/03/2022.
//

import Foundation
import Combine
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
    
    
    func getNearByShops(url:String,parameters:[String:Any],complicationHandler:@escaping (([ShopListModel]?,NetworkError?)->Void)){
        
        var headers : HTTPHeaders = [
            "Content-Type":"application/json"
        ]
        if let user : LoginDataModel = UserDefaults.standard.get(StringKeys.saveUserKey) {
            headers.add(name: "Authorization", value: "Bearer \(user.accessToken ?? "")")
        }
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { result in
                switch result.result{
                case .success(let value):
                    if let dic = value as? [String:Any]{
                        if let data = dic["data"] as? [String:Any]{
                            if let shops = data["2"] as? [NSDictionary]{
                                do{
                                    let js = try JSONSerialization.data(withJSONObject: shops, options: .fragmentsAllowed)
                                    let model = try JSONDecoder().decode([ShopListModel].self, from: js)
                                    complicationHandler(model,nil)
                                }catch let er{
                                    complicationHandler(nil,NetworkError.init(initialError: er.localizedDescription))
                                }
                            }
                        }
                        else{
                            complicationHandler([],nil)
                        }
                    }
                    else{
                        complicationHandler(nil,NetworkError.init(initialError: "Error in dictionry"))
                    }
                case .failure(let e):
                    complicationHandler(nil,NetworkError.init(initialError: e.localizedDescription))
                }
            }
    }
}
