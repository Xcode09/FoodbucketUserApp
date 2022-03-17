//
//  ContentView.swift
//  FoodPlaniOS
//
//  Created by Muhammad Ali on 12/12/2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack{
            TabView{
                HomeVC().tabItem {
                    Label("Menu", systemImage: ImagesName.house_fill.rawValue)
                }
                CheckViewVC().tabItem {
                    Label("Check", systemImage: "list.dash")
                }
//                ScannerView().tabItem {
//                    Label("QR Scan", systemImage: "list.dash")
//                }
                FavouriteVC().tabItem {
                    Label("Favourite", systemImage: ImagesName.heart.rawValue)
                }
                ProfileView().tabItem {
                    Label("Profile", systemImage: ImagesName.user.rawValue)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
struct ImageOverlay: View {
    var message:String
    var subText:String = ""
    var subText2:String = ""
    var subImage:String = ""
    var subImage1:String = ""
    var isBottomViewEnable = false
    var font:Font = .headline
    var lineL:Int = 0
    var body: some View {
        VStack(alignment:.leading){
            Text(message)
                .font(.headline)
                .lineLimit(lineL)
                .padding(6)
                .foregroundColor(.white)
            if isBottomViewEnable {
                HStack(spacing:8){
                    HStack{
                        Image(systemName: subImage)
                        Text("75")
                    }
                    HStack{
                        Image(systemName: subImage1)
                        Text("2")
                    }
                }.padding([.all], 5)
                    .font(font)
                .foregroundColor(.white)
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.black.opacity(0.5)))
            }
            
        }.cornerRadius(10.0)
        .padding(6)
    }
}
