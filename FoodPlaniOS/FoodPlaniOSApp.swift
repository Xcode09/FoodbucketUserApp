//
//  FoodPlaniOSApp.swift
//  FoodPlaniOS
//
//  Created by Muhammad Ali on 12/12/2021.
//

import SwiftUI

@main
struct FoodPlaniOSApp: App {
    @StateObject var userStateViewModel = UserStateViewModel()
    
    var body: some Scene {
        WindowGroup {
            //RecipesCheckList()
            //ShopsList()
            ContentView().environmentObject(userStateViewModel)
            
            //LoginView()
        }
    }
}
