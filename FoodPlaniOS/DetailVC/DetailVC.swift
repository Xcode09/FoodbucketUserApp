//
//  DetailVC.swift
//  FoodPlaniOS
//
//  Created by Muhammad Ali on 15/12/2021.
//

import SwiftUI
import Kingfisher
import Combine
import AlertToast
import Alamofire
fileprivate class DetailVCModelView:ObservableObject{
    @Published var receips:[Recipes] = []
    @Published var errorMessage = ""
    @Published var quantity = 1
    @EnvironmentObject var userState: UserStateViewModel
    //    @Published var showToast = false
    var cancellationToken: AnyCancellable?
    func getSelectRecipe(_ url:String,id:String){
        let pu : AnyPublisher<DataResponse<RecipesModel, NetworkError>, Never> =  Service.shared.fetchData(url: url, method: "POST", isHeaderToke: true,parameters: ["r_id":id])
        cancellationToken = pu.sink { (dataResponse) in
            if dataResponse.error != nil{
                self.errorMessage = dataResponse.error?.initialError ?? ""
            }else{
                if let data = dataResponse.value?.data{
                    self.receips =  data
                }
                
            }
        }
    }
    
    func addRecipeToFav(){
        let pu : AnyPublisher<DataResponse<BasicModel, NetworkError>, Never> =  Service.shared.fetchData(url: ApiEndPoints.addFavouriteRecipe, method: "POST", isHeaderToke: true,parameters: ["r_id":"\(self.receips[0].id ?? 0)"])
        cancellationToken = pu.sink { (dataResponse) in
            if dataResponse.error != nil{
                self.errorMessage = dataResponse.error?.initialError ?? ""
            }else{
                if let data = dataResponse.value{
                    //self.receips =  data
                    self.errorMessage = data.message
                }
                
            }
        }
    }
}
struct DetailVC: View {
    @State var isShopListTapped = false
    @State var uiTabarController: UITabBarController?
    @State var showToast = false
    @ObservedObject fileprivate var vm = DetailVCModelView()
    var r_id : String
    @Environment(\.presentationMode) var presentationMode
    init(id:String){
        self.r_id = id
        vm.getSelectRecipe(ApiEndPoints.customerSelectRecipes, id: id)
    }
    
    var body: some View {
        return NavigationView{
            if vm.receips.count > 0 {
                VStack{
                    ScrollView{
                        mainHeaderView
                        HStack{
                            Spacer().frame(width:5)
                            Image(systemName: "clock")
                            Text(vm.receips[0].cookingTime ?? "").foregroundColor(.textColor)
                            Text(vm.receips[0].servings ?? "").foregroundColor(.secondaryTextColor)
                            Spacer()
                            Stepper("", onIncrement: {
                                vm.quantity += 1
                            }, onDecrement: {
                                if vm.quantity > 1 {
                                    vm.quantity -= 1
                                }
                            })
                        }.padding([.all], 5)
                        
                        
                        horizontalView
                        
                        stepsView.padding([.all], 5)
                        
                    }
                    bottomNavBar.padding()
                }
                
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(content: {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button(action: {}) {
                            Image.init(systemName: "square.and.arrow.up")
                                .foregroundColor(.iconTintColor)
                        }
                        
                        Button(action: {}) {
                            Text("...").font(.system(size: 18, weight: .medium, design: .default))
                                .foregroundColor(.iconTintColor)
                        }
                    }
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .resizable()
                        }
                    }
                })
                .edgesIgnoringSafeArea(.all)
                .fullScreenCover(isPresented: $isShopListTapped, onDismiss: nil) {
                    ShopsList()
                }
                .toast(isPresenting: $showToast) {
                    AlertToast(type: .regular, title:vm.errorMessage)
                }
            }
            
        }
        .onChange(of: vm.errorMessage) { _ in
            showToast.toggle()
        }
        
        
        
    }
    
    private var horizontalView:some View{
        VStack(alignment:.leading){
            Text("Sample")
                .font(.system(size: 18, weight: .bold, design: .default))
                .foregroundColor(.textColor)
            ScrollView(.horizontal){
                LazyHStack(spacing:10){
                    ForEach(vm.receips[0].ingredients ?? [],id:\.id)
                    {
                        ingre in
                        VStack(alignment:.center,spacing:10){
                            KFImage.url(URL(string:ingre.ingredientName?[0].imageURL ?? ""))
                                .resizable()
                                .diskCacheExpiration(.never)
                                .cacheMemoryOnly(false)
                                .frame(width:120,height: 80)
                                .cornerRadius(10)
                            Text(ingre.ingredientName?[0].name ?? "").foregroundColor(.textColor)
                            
                            let qunty = Int(ingre.quantity?.replacingOccurrences(of: " ", with: "") ?? "") ?? 1
                            Text("\(qunty*vm.quantity) \(ingre.ingredientName?[0].unit ?? "")").foregroundColor(.red)
                        }
                        .background(Color.bgColor)
                        //                            .cornerRadius(10)
                        //                            .shadow(color: .gray, radius: 1, x: 1, y: 1)
                    }
                }.padding([.all], 5)
            }.frame(height:150)
            
            
        }.padding([.all], 5)
        
        
        
    }
    
    private var mainHeaderView:some View{
        VStack(alignment:.leading){
            KFImage.url(URL(string:vm.receips.count > 0 ? vm.receips[0].imageURL ?? "" : ""))
                .resizable()
                .diskCacheExpiration(.never)
                .cacheMemoryOnly(false)
                .aspectRatio(contentMode: .fill)
                .overlay(ImageOverlay(message:vm.receips.count > 0 ? vm.receips[0].category ?? "" : "",subText:vm.receips.count > 0 ? vm.receips[0].cookingTime ?? "":"",subText2:vm.receips.count > 0 ? vm.receips[0].servings ?? "" : "",subImage: ImagesName.clock.rawValue,subImage1: ImagesName.user.rawValue,isBottomViewEnable: true,lineL: 3), alignment: .bottomLeading)
            
        }
        
    }
    
    private var stepsView:some View{
        LazyVStack(){
            ForEach(vm.receips[0].stepRecipe ?? [],id:\.id){
                step in
                LazyVStack(alignment:.leading,spacing: 20){
                    Text(step.title ?? "")
                        .font(.system(size: 18, weight: .bold, design: .default))
                        .foregroundColor(.textColor)
                    KFImage.url(URL(string:step.imageURL ?? ""))
                        .resizable()
                        .diskCacheExpiration(.never)
                        .cacheMemoryOnly(false)
                    Text(step.stepRecipeDescription ?? "")
                    Divider()
                }
            }
        }
        
    }
    
    private var bottomNavBar:some View{
        HStack(spacing:10){
            Spacer()
            
            Button(action: {
                vm.addRecipeToFav()
            }) {
                VStack{
                    Image(systemName: "heart")
                        .resizable()
                        .frame(maxWidth:20,maxHeight: 20)
                        .clipped()
                        .foregroundColor(.iconTintColor)
                }
            }
            Spacer()
            
//            NavigationLink(destination: {
//                ShopsList()
//            }) {
//                VStack{
//                    Image("cart")
//                        .resizable()
//                        .frame(maxWidth:20,maxHeight: 20)
//                        .clipped()
//                        .foregroundColor(.iconTintColor)
//                }
//            }.buttonStyle(PlainButtonStyle())
            
            Button(action: {
                isShopListTapped.toggle()
            }) {
                VStack{
                    Image("cart")
                        .resizable()
                        .frame(maxWidth:20,maxHeight: 20)
                        .clipped()
                        .foregroundColor(.iconTintColor)
                }
            }
            
            Spacer()
        }
        .frame(height:34)
    }
}

struct DetailVC_Previews: PreviewProvider {
    static var previews: some View {
        DetailVC(id: "")
    }
}
