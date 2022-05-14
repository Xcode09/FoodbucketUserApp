//
//  AppDelegate.swift
//  FoodPlaniOS
//
//  Created by Muhammad Ali on 01/05/2022.
//

import Foundation
import UIKit
class AppState: ObservableObject {
    static let shared = AppState()
    @Published var pageToNavigationTo : String?
}
class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
     
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            print("Dispatch")
            AppState.shared.pageToNavigationTo = "test"
        }
        
        return true
    }
}
