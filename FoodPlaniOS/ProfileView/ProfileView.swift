//
//  ProfileView.swift
//  FoodPlaniOS
//
//  Created by Muhammad Ali on 14/12/2021.
//

import SwiftUI
import Alamofire
import Kingfisher
fileprivate struct CellDataModel:Identifiable{
    let id = UUID()
    let name:String
    let icon:String
}
extension CellDataModel{
    static func getData()->[CellDataModel]{
        return [
            .init(name: "Мои детали", icon: "user"),
            .init(name: "Уведомление", icon: "user"),
            .init(name: "Задайте вопрос", icon: "user"),
            .init(name: "Поделитесь приложением", icon: "user")
        ]
    }
}
struct ProfileView: View {
    @EnvironmentObject var vm: UserStateViewModel
    var dummyArr = ["one","two","three","four"]
    var body: some View {
        NavigationView{
            ScrollView{
                VStack{
                    Spacer().frame(height:20)
                    VStack(alignment:.center,spacing: 10){
                        KFImage.url(URL(string: vm.currentUser?.imageURL ?? "")).resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .cornerRadius(50)
                        Text(vm.currentUser?.name ?? "Guest")
                    }
                    Spacer().frame(height:20)
                    LazyVStack(alignment: .leading, spacing: 10){
                        ForEach(CellDataModel.getData(),id:\.id){
                            index in
                            CellRow(cellIcon:index.icon, cellTitle:index.name).environmentObject(vm)
                            Divider()
                        }
                        
                        
                    }.background(Color.white)
                }
                Spacer().frame(height:30)
                
                VStack(spacing:10)
                {
                    Text("Политика конфиденциальности")
                        .foregroundColor(.green)
                    
                    Text("Условия использования")
                        .foregroundColor(.green)
                }
                Spacer().frame(height:20)
                if vm.isBusy {
                    ProgressView().progressViewStyle(CircularProgressViewStyle())
                }else{
                    Button(action: {
                        Task{
                            await vm.signOut()
                        }
                        
                    }) {
                        Text("Logout")
                            .foregroundColor(.red)
                    }
                }
                
                
                
                
            }
            .background(Color(UIColor.groupTableViewBackground))
            .navigationBarTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

fileprivate struct CellRow:View{
    let cellIcon:String
    let cellTitle:String
    @State var myDetailsTapped = false
    @EnvironmentObject var env : UserStateViewModel
    var body: some View{
        ZStack{
            HStack{
                Image(cellIcon)
                    .scaledToFill()
                    .frame(maxWidth:30)
                    .clipped()
                Text(cellTitle)
                    .foregroundColor(.black)
                    .frame(maxWidth:.infinity,alignment: .leading)
                Spacer()
                Image(systemName:"chevron.right")
                    .frame(maxWidth:30)
                Spacer().frame(width:10)
                
            }
            .padding([.all], 10)
            .onTapGesture {
                if cellTitle == CellDataModel.getData().first?.name{
                    myDetailsTapped.toggle()
                }
            }
            .sheet(isPresented: $myDetailsTapped) {
                MyDetailsView().environmentObject(env)
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

