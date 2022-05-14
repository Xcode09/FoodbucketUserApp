//
//  ShopsList.swift
//  FoodPlaniOS
//
//  Created by Muhammad Ali on 01/02/2022.
//

import SwiftUI
import Kingfisher
fileprivate class ShopsListViewModel:ObservableObject{
    @Published var shops = [ShopListModel]()
    @Published var errorMessage = ""
    func getShops(rec_id:String,radius:String = ""){
        var para : [String:Any] = ["latitude":golbalLocation?.latitude ?? 0.0,"longitude":golbalLocation?.latitude ?? 0.0,"recipe_id":rec_id]
        if radius != "" {
            para["radius"] = radius
        }
        debugPrint("PPP",para)
        Service.shared.getNearByShops(url: ApiEndPoints.distance, parameters:para) { lists, error in
            if error != nil {
                self.errorMessage = error?.localizedDescription ?? ""
            }else{
                
                guard lists?.count ?? 0 > 0 else {
                    self.errorMessage = "магазин не найден"
                    return
                }
                self.errorMessage = ""
                self.shops = lists!
            }
        }
    }
}
struct ShopsList: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject fileprivate var vm = ShopsListViewModel()
    var rec_id : String
    var servings = ""
    @State var radius = "50"
    var body: some View {
        NavigationView{
            if vm.errorMessage.isEmpty {
                ScrollView{
                    ForEach(vm.shops,id:\.id){
                        shop in
                        ShopCellView(shop: shop, rec_id: rec_id, servings: servings)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(Text("Рядом магазины"))
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .resizable()
                        }
                    }
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        DropDownMenu(value: $radius)
                    }
                }
            }
            else{
                Text(vm.errorMessage).font(.largeTitle)
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle(Text("Рядом магазины"))
                    .toolbar {
                        ToolbarItemGroup(placement: .navigationBarLeading) {
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "chevron.left")
                                    .resizable()
                            }
                        }
                        
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            DropDownMenu(value: $radius)
                        }
                    }
            }
        }
        .onAppear {
            vm.getShops(rec_id: rec_id)
        }
        .onChange(of: radius, perform: { newValue in
            vm.getShops(rec_id: rec_id,radius: newValue)
        })
        .background(Color(UIColor.secondarySystemBackground).edgesIgnoringSafeArea(.all))
    }
}

struct DropDownMenu:View{
    @Binding var value : String
    var placeholder = "Выберите радиус"
    var dropDownList = ["50", "25", "15", "10", "5"]
    var body: some View {
        Menu {
            ForEach(dropDownList, id: \.self){ client in
                Button(client) {
                    self.value = client
                }
            }
        } label: {
            VStack(spacing: 5){
                HStack{
                    Text(value.isEmpty ? placeholder : "\(value) Km")
                        .foregroundColor(value.isEmpty ? .gray : .black)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(Color.gray)
                        .font(Font.system(size: 16, weight: .bold))
                }
                .padding(.horizontal)
            }.background(RoundedRectangle(cornerRadius: 5).fill(Color.white.opacity(0.7)))
                .frame(height:60)
        }
    }
}

struct ShopCellView:View{
    var shop:ShopListModel
    var rec_id:String
    var servings:String
    @State var isShopSelected = false
    var body: some View{
        HStack{
            ZStack{
                Color(UIColor.systemGray6)
                KFImage.url(URL(string:shop.imageURL ?? ""))
                    .resizable()
                    .cornerRadius(10)
                    .frame(width: 120, height: 120, alignment: .center)
                    .cornerRadius(15)
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                
            }.frame(maxWidth:140,maxHeight:140)
                .cornerRadius(15)
                .padding([.all], 5)
            Spacer()
            
            
            VStack(spacing:10){
                Text(shop.name ?? "")
                    .frame(maxWidth:.infinity,alignment: .leading)
                    .font(.system(size: 18, weight: .bold, design: .default))
                    .foregroundColor(.textColor)
                Text(shop.address ?? "")
                    .frame(maxWidth:.infinity,alignment: .leading)
                HStack{
                    Image(systemName: "location")
                        .frame(width:25,alignment: .leading)
                    Text("\(shop.distance ?? "") Km")
                        .frame(maxWidth:.infinity,alignment: .leading)
                }
            }
        }
        .frame(maxHeight:240)
        .background(RoundedRectangle(cornerRadius: 15).fill(.white)
            .shadow(color: Color(UIColor.systemGray4), radius: 25, x:5, y:5)
        )
        .padding([.leading,.trailing], 10)
        .onTapGesture {
            isShopSelected.toggle()
        }
        .fullScreenCover(isPresented: $isShopSelected) {
            CheckViewVC(shop_id: shop.id ?? "", rec_id: rec_id,servings:servings)
        }
    }
}



struct ShopsList_Previews: PreviewProvider {
    static var previews: some View {
        ShopsList(rec_id: "", servings: "")
    }
}
