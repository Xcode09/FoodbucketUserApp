//
//  Extensions.swift
//  FoodPlaniOS
//
//  Created by Muhammad Ali on 21/12/2021.
//

import Foundation
import SwiftUI
extension View {
    /// Navigate to a new view.
    /// - Parameters:
    ///   - view: View to navigate to.
    ///   - binding: Only navigates when this condition is `true`.
    func navigate<NewView: View>(to view: NewView, when binding: Binding<Bool>) -> some View {
        NavigationView {
            ZStack {
                self
                    .navigationBarTitle("")
                    .navigationBarHidden(true)

                NavigationLink(
                    destination: view
                        .navigationBarTitle("")
                        .navigationBarHidden(false),
                    isActive: binding
                ) {
                    EmptyView()
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

enum ImagesName:String{
    case user = "person"
    case clock = "clock"
    case house_fill = "house.fill"
    case heart = "heart.fill"
    case meat
}

extension Color{
    static let textColor = Color(UIColor.black)
    static let bgColor = Color(UIColor.white)
    static let secondaryTextColor = Color(UIColor.lightText)
}

extension String{
    func parseToInt() -> Int? {
        return Int(self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
    }
}
extension UserDefaults{
    func save<T:Codable>(_ ey:String,model:T){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(model) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey:ey)
            defaults.synchronize()
        }
    }
    func get<T:Codable>(_ ey:String)->T?{
        let defaults = UserDefaults.standard
        if let savedPerson = defaults.object(forKey: ey) as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(T.self, from: savedPerson) {
                return loadedPerson
            }
        }
        return nil
    }
    
    func remove(_ ey:String){
        UserDefaults.standard.removeObject(forKey: ey)
        UserDefaults.standard.synchronize()
    }
}
