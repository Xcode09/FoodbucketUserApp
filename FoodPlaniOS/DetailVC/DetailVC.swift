//
//  DetailVC.swift
//  FoodPlaniOS
//
//  Created by Muhammad Ali on 15/12/2021.
//

import SwiftUI
import Kingfisher
import Combine
import Alamofire
fileprivate class DetailVCModelView:ObservableObject{
    @Published var receips:[Recipes] = []
    @Published var errorMessage = ""
    @Published var quantity = 1
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
}
struct DetailVC: View {
    @State var isShopListTapped = false
   @ObservedObject fileprivate var vm = DetailVCModelView()
    var r_id : String
    init(id:String){
        self.r_id = id
        vm.getSelectRecipe(ApiEndPoints.customerSelectRecipes, id: id)
    }
    
    var body: some View {
        if vm.receips.count > 0{
            NavigationView{
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
                        }
                        
                        Button(action: {}) {
                            Text("...").font(.system(size: 18, weight: .medium, design: .default))
                        }
                    }
                })
                .edgesIgnoringSafeArea(.all)
                
                .sheet(isPresented: $isShopListTapped, onDismiss: nil) {
                    ShopsList()
                }
            }
        }
        else{
            Text(vm.errorMessage)
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
                                .frame(width:120,height: 80)
                                .cornerRadius(10)
                            Text(ingre.ingredientName?[0].name ?? "").foregroundColor(.textColor)
                            Text("\(1*vm.quantity)").foregroundColor(.red)
                        }
                            .background(Color.bgColor)
                            .cornerRadius(10)
                            .shadow(color: .gray, radius: 1, x: 1, y: 1)
                    }
                }.padding([.all], 5)
            }.frame(height:150)
                
                
        }.padding([.all], 5)
            
        
        
    }
    
    private var mainHeaderView:some View{
        VStack(alignment:.leading){
            KFImage.url(URL(string:vm.receips[0].imageURL ?? ""))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .overlay(ImageOverlay(message:vm.receips[0].category ?? "",subText:vm.receips[0].cookingTime ?? "",subText2:vm.receips[0].servings ?? "",subImage: ImagesName.clock.rawValue,subImage1: ImagesName.user.rawValue,isBottomViewEnable: true,lineL: 3), alignment: .bottomLeading)
            
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
                    Text(step.stepRecipeDescription ?? "")
                    Divider()
                }
            }
        }
        
    }
    
    private var bottomNavBar:some View{
        HStack(spacing:10){
            Spacer()
            Button(action: {}) {
                VStack{
                    Image(systemName: "heart")
                        .resizable()
                        .frame(maxWidth:20,maxHeight: 20)
                        .clipped()
                }
            }
            Spacer()
            Button(action: {
                isShopListTapped.toggle()
            }) {
                VStack{
                    Image(systemName: "list.bullet.rectangle.portrait")
                        .resizable()
                        .frame(maxWidth:20,maxHeight: 20)
                        .clipped()
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
