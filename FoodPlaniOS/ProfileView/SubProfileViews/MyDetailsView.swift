//
//  MyDetailsView.swift
//  FoodPlaniOS
//
//  Created by Muhammad Ali on 06/05/2022.
//

import SwiftUI

struct MyDetailsView: View {
    @EnvironmentObject var env:UserStateViewModel
    var body: some View {
        NavigationView{
            VStack(spacing:20){
                Text("Имя")
                    .frame(maxWidth:.infinity,alignment: .leading)
                    .font(.headline)
                Text(env.currentUser?.name ?? "")
                    .frame(maxWidth:.infinity,alignment: .leading)
                Text("Эл. адрес")
                    .frame(maxWidth:.infinity,alignment: .leading)
                    .font(.headline)
                Text(env.currentUser?.email ?? "")
                    .frame(maxWidth:.infinity,alignment: .leading)
                Spacer()
            }.navigationTitle("Мои детали")
                .padding()
        }
    }
}

struct MyDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        MyDetailsView()
    }
}
