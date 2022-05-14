//
//  CheckViewVC.swift
//  FoodPlaniOS
//
//  Created by Muhammad Ali on 12/12/2021.
//

import SwiftUI
import Combine
import Alamofire
import AlertToast
fileprivate class CheckOutViewModel:ObservableObject{
    @Published var shop : ShopListModel?
    @Published var recipes = [Recipes]()
    @Published var errorMessage = ""
    @Published var successMessage = ""
    @Published var isLoading = false
    var cancellationToken: AnyCancellable?
    func getSelectRecipe(_ url:String,id:String,shop_id:String){
        let pu : AnyPublisher<DataResponse<CheckOutModel, NetworkError>, Never> =  Service.shared.fetchData(url: url, method: "POST", isHeaderToke: true,parameters: ["r_id":id,"latitude":"\(golbalLocation?.latitude ?? 0.0)","longitude":"\(golbalLocation?.longitude ?? 0.0)","shop_id":shop_id,"serving_no":""])
        cancellationToken = pu.sink { (dataResponse) in
            if dataResponse.error != nil{
                self.errorMessage = dataResponse.error?.initialError ?? ""
            }else{
                if let data = dataResponse.value?.shopDetails,
                   let rec = dataResponse.value?.recipesDetails
                {
                    debugPrint(data)
                    self.shop = data
                    debugPrint(rec)
                    self.recipes = rec
                }
            }
        }
    }
    func placeOrder(_ url:String,id:String,shop_id:String,servings:String){
        isLoading = true
        let pu : AnyPublisher<DataResponse<BasicModel, NetworkError>, Never> =  Service.shared.fetchData(url: url, method: "POST", isHeaderToke: true,parameters: ["r_id":id,"s_id":shop_id,"serving_no":servings])
        cancellationToken = pu.sink { (dataResponse) in
            if dataResponse.error != nil{
                self.isLoading = false
                self.errorMessage = dataResponse.error?.initialError ?? ""
            }else{
                if let data = dataResponse.value?.message
                {
                    self.isLoading = false
                    self.errorMessage = data
                }
            }
        }
    }
}
struct CheckViewVC: View {
    @State private var favoriteColor = 0
    @State var showToast = false
    //@State private var isPlaceOrderTapped = false
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject fileprivate var vm = CheckOutViewModel()
    var shop_id : String
    var rec_id:String
    var servings:String
    var body: some View {
        NavigationView{
            ZStack{
                VStack(alignment:.leading, spacing:20){
                    shopDetailView
                    receipeDetailView
                    //Spacer()
                    HStack(spacing:10){
                        Spacer()
                        if vm.isLoading{
                            ProgressView().progressViewStyle(CircularProgressViewStyle())
                        }else{
                            Button(action: {
                                vm.placeOrder(ApiEndPoints.placeOrder, id: rec_id, shop_id: shop_id, servings: servings)
                            }) {
                                Text("Разместить заказ")
                                    .foregroundColor(.white)
                            }.frame(maxWidth:.infinity)
                            .padding()
                            .background(Color.iconTintColor)
                            .cornerRadius(8)
                        }
                        Spacer()
                    }.frame(height:46)
                    Spacer()
                }
            }.navigationTitle("Check Out")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .resizable()
                        }
                    }
                }
                .onAppear {
                    vm.getSelectRecipe(ApiEndPoints.checkout, id: rec_id, shop_id: shop_id)
                }
                .toast(isPresenting: $showToast) {
                    AlertToast(type: .regular, title:vm.errorMessage)
                }
                .onChange(of: vm.errorMessage) { newValue in
                    showToast.toggle()
                }
        }
    }
    
    private var shopDetailView:some View{
        VStack(alignment:.leading,spacing:20){
            Text("Детали магазина")
                .font(.system(size: 24, weight: .bold, design: .default))
            HStack{
                Text("Название магазина")
                    .font(.system(size: 18, weight: .bold, design: .default))
                Spacer()
                Text(vm.shop?.name ?? "")
            }
            HStack{
                Text("Расстояние")
                    .font(.system(size: 18, weight: .bold, design: .default))
                Spacer()
                Text("\(vm.shop?.distance?.getDistance() ?? "") Km")
            }
            HStack{
                Text("Место нахождения")
                    .font(.system(size: 18, weight: .bold, design: .default))
                Spacer()
                Text(vm.shop?.address ?? "")
            }
        }
        .padding()
    }
    
    private var receipeDetailView:some View{
        VStack(alignment:.leading,spacing:20){
            Text("детали рецепта")
                .font(.system(size: 24, weight: .bold, design: .default))
            HStack{
                Text("название рецепта")
                    .font(.system(size: 16, weight: .bold, design: .default))
                Spacer()
                Text(vm.recipes.first?.name ?? "")
            }
            Text("Ингредиенты")
                .font(.system(size: 18, weight: .bold, design: .default))
            ScrollView{
                ForEach(vm.recipes,id:\.id){
                    
                    rec in
                    ForEach(rec.ingredients ?? [],id:
                                \.id){
                        ingre in
                        
                        HStack{
                            Text(ingre.ingredientName?.first?.name ?? "")
                                .font(.system(size: 16, weight: .bold, design: .default))
                            Spacer()
                            HStack{
                                Text(ingre.ingredientName?.first?.amount ?? "")
                                Text("₽")
                            }
                        }.padding()
                    }
                }
            }
            
        }
        .padding()
    }
    
    
  
}

//struct CheckViewVC_Previews: PreviewProvider {
//    static var previews: some View {
//        CheckViewVC(shop_id: "", rec_id: ""shop_id: <#String#>, rec_id: <#String#>)
//    }
//}
