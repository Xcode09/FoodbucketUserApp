//
//  CheckViewVC.swift
//  FoodPlaniOS
//
//  Created by Muhammad Ali on 12/12/2021.
//

import SwiftUI

struct CheckViewVC: View {
    @State private var favoriteColor = 0
    var body: some View {
        NavigationView{
            ZStack{
                VStack(alignment:.center){
                    segmentView.padding()
                    emptyView
                    
                }
               
            }.navigationTitle("Check Out")
                .toolbar {
                    HStack{
                        Button(action: {}) {
                            Text("Icon1")
                        }
//                        Button(action: {}) {
//                            Text("Icon2")
//                        }
                    }
                }
        }
    }
    
    private var emptyView:some View{
        VStack{
            Spacer()
            if favoriteColor == 0{
                Text("No Item found for check Out")
            }else{
                Text("Some Thing")
            }
            Spacer()
        }
        
    }
    
    private var segmentView: some View {
            VStack {
                Picker("What is your favorite color?", selection: $favoriteColor) {
                    Text("Red").tag(0)
                    Text("Green").tag(1)
                    //Text("Blue").tag(2)
                }
                .pickerStyle(.segmented)
            }
        }
}

struct CheckViewVC_Previews: PreviewProvider {
    static var previews: some View {
        CheckViewVC()
    }
}
