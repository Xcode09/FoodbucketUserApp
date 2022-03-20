//
//  ViewModels.swift
//  FoodPlaniOS
//
//  Created by Muhammad Ali on 20/03/2022.
//

import Foundation
import SwiftUI
import Combine
@MainActor
class UserStateViewModel: ObservableObject {

    @Published var isLoggedIn = false
    @Published var isBusy = false
    var currentUser : User? = nil
    func getUserData(key:String){
        if let user : LoginDataModel = UserDefaults.standard.get(key){
            currentUser = user.user
            isLoggedIn = true
        }
    }
//    func saveData<T:Codable>(key:String,model:T,isLoginToggle:Bool=false){
//        UserDefaults.standard.save(key, model: model)
//    }

    func signOut() async -> Result<Bool,NetworkError>  {
        isBusy = true
        do{
            UserDefaults.standard.remove(StringKeys.saveUserKey)
            try await Task.sleep(nanoseconds: 1_000_000_000)
            isLoggedIn = false
            isBusy = false
            return .success(true)
        }catch{
            isBusy = false
            return .failure(NetworkError.init(initialError: "Something went worng"))
        }
    }
}

