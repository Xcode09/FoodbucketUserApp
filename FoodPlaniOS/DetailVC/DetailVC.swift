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
import AVKit
import Alamofire
fileprivate class DetailVCModelView:ObservableObject{
    @Published var receips:[Recipes] = []
    @Published var errorMessage = ""
    @Published var quantity = 1
    @Published var noServings = ""
    @Published var thumbnailImage : UIImage?
    @EnvironmentObject var userState: UserStateViewModel
    //    @Published var showToast = false
    var cancellationToken: AnyCancellable?
    func getSelectRecipe(_ url:String,id:String){
        let pu : AnyPublisher<DataResponse<RecipesModel, NetworkError>, Never> =  Service.shared.fetchData(url: url, method: "POST", isHeaderToke: true,parameters: ["r_id":id])
        cancellationToken = pu.sink { [weak self] (dataResponse) in
            guard let self = self else {return}
            if dataResponse.error != nil{
                self.errorMessage = dataResponse.error?.initialError ?? ""
            }else{
                if let data = dataResponse.value?.data{
                    self.noServings = data.first?.servings ?? ""
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
    
    private func getThumbnilImage(uri:String){
        guard let url = URL(string: "https://img.youtube.com/vi/\(uri)/0.jpg") else {return}
        DispatchQueue.global().async {
            let asset = AVAsset(url: url)
            let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
            assetImgGenerate.appliesPreferredTrackTransform = true
            let time = CMTimeMake(value: 1, timescale: 2)
            let img = try? assetImgGenerate.copyCGImage(at: .zero, actualTime: nil)
            if img != nil {
                let frameImg  = UIImage(cgImage: img!)
                DispatchQueue.main.async(execute: {
                    self.thumbnailImage = frameImg
                })
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
//                            Image(systemName: "clock")
//                            Text(vm.receips[0].cookingTime ?? "").foregroundColor(.textColor)
                            Image(systemName: ImagesName.user.rawValue)
                            Text(vm.noServings).foregroundColor(.textColor)
                            Spacer()
                            Stepper("", onIncrement: {
                                vm.quantity += 1
                                vm.noServings = "\((Int(vm.noServings) ?? 0) + 1)"
                                
                            }, onDecrement: {
                                if vm.quantity > 1 {
                                    vm.noServings = "\((Int(vm.noServings) ?? 0) - 1)"
                                    vm.quantity -= 1
                                }else{
                                    vm.quantity = 1
                                }
                            })
                        }.padding([.all], 5)
                        HStack(spacing:10){
                            VStack{
                                Text("\(vm.receips.first?.calories ?? "")")
                                Text("калории")
                            }
                            Spacer()
                            VStack{
                                Text("\(vm.receips.first?.proteins ?? "")")
                                Text("белки")
                            }
                            Spacer()
                            VStack{
                                Text("\(vm.receips.first?.carbohydrates ?? "")")
                                Text("углеводы")
                            }
                            Spacer()
                            VStack{
                                Text("\(vm.receips.first?.fats ?? "")")
                                Text("жиры")
                            }
                            Spacer()
                        }.padding()
                        
                        
                        horizontalView
                        
                        stepsView.padding([.all], 5)
                        
                        if vm.receips.first?.videoURL != nil {
                            youtubeView
                        }
                        
                    }
                    bottomNavBar.padding()
                }
                .navigationTitle(vm.receips[0].name ?? "")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(content: {
                    //                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                    //                        Button(action: {}) {
                    //                            Image.init(systemName: "square.and.arrow.up")
                    //                                .foregroundColor(.iconTintColor)
                    //                        }
                    //
                    //                        Button(action: {}) {
                    //                            Text("...").font(.system(size: 18, weight: .medium, design: .default))
                    //                                .foregroundColor(.iconTintColor)
                    //                        }
                    //                    }
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .resizable()
                        }
                    }
                })
                //                .edgesIgnoringSafeArea(.all)
                .fullScreenCover(isPresented: $isShopListTapped, onDismiss: nil)
                {
                    ShopsList(rec_id:"\(vm.receips[0].id ?? 0)",servings: "\(vm.quantity)")
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
                            KFImage.url(URL(string:ingre.ingredientName?.first?.imageURL ?? ""))
                                .resizable()
                            
                                .diskCacheExpiration(.never)
                                .cacheMemoryOnly(false)
                                .scaledToFill()
                                .frame(width:120,height: 80)
                                .cornerRadius(10)
                            Text(ingre.ingredientName?.first?.name ?? "").foregroundColor(.textColor)
                            
                            let qunty = Int(ingre.quantity?.replacingOccurrences(of: " ", with: "") ?? "") ?? 1
                            Text("\(qunty*vm.quantity) \(ingre.ingredientName?.first?.unit ?? "")").foregroundColor(.red)
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
                        .scaledToFill()
                        .frame(height:250)
                    
                    Text(step.stepRecipeDescription ?? "")
                    Divider()
                }
            }
        }
        
    }
        private var youtubeView:some View{
            ZStack(alignment:.center){
                KFImage.url(URL(string:"https://img.youtube.com/vi/\(vm.receips.first?.videoURL?.replacingOccurrences(of: "https://www.youtube.com/watch?v=", with: "") ?? "")/0.jpg"))
                    .resizable()
                    .frame(height:250,alignment: .center)
                    .scaledToFill()
                    .cornerRadius(10)
                Image("yt")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .modifier(InsetViewModifier())
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
struct InsetViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        GeometryReader { proxy in
            VStack {
                content
                    .frame(width: proxy.size.width * 0.8, height: proxy.size.height * 0.8, alignment: .center)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
