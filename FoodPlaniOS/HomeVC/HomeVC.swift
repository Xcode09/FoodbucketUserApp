//
//  HomeVC.swift
//  FoodPlaniOS
//
//  Created by Muhammad Ali on 12/12/2021.
//

import SwiftUI
import Combine
import Kingfisher
import Alamofire
final class HomeVCViewModel:ObservableObject{
    @Published var receips:[Recipes] = []
    @Published var errorMessage = ""
    @Published var isLoading = false
    var rec_id = ""
    var cancellationToken: AnyCancellable?
    
    func getRecipes(_ url:String){
        let pu : AnyPublisher<DataResponse<RecipesModel, NetworkError>, Never> =  Service.shared.fetchData(url: url, method: "GET", isHeaderToke: true)
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

struct HomeVC: View {
    @State private var isNavigate = false
    @State private var isQrCodeTapped = false
    @State private var isReceipesList = false
    @State private var isSearchClick = false
    @State private var scannedRecipeId:String? = ""
    private var categories = ["lunch","dinner","breakfast"]
    @State private var selectedCategory = ""
    @ObservedObject var vm = HomeVCViewModel()
    @EnvironmentObject var userState: UserStateViewModel
    init(){
        vm.getRecipes(ApiEndPoints.fetchAllRecipes)
    }
    var body: some View {
        if vm.receips.count > 0{
            NavigationView{
                ScrollView{
                    ZStack{
                        VStack(alignment: .leading){
                            horizontalStoires
                            headerView
                            if vm.isLoading{
                                Spacer()
                                HStack{
                                    Spacer()
                                    ProgressView().progressViewStyle(CircularProgressViewStyle())
                                    Spacer()
                                }.padding()
                                Spacer()
                            }else{
                                cellListView
                            }
                            
                            Spacer()
                        }
                    }
                }
                .navigationBarTitle("Menu")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button(action: {
                            isSearchClick.toggle()
                        }) {
                            Image(systemName: "magnifyingglass")
                                .resizable()
                        }
                        Button(action: {
                            isQrCodeTapped.toggle()
                        }) {
                            Image(systemName: "qrcode.viewfinder")
                                .resizable()
                        }
                    }
                }
                .fullScreenCover(isPresented: $isNavigate, onDismiss: nil) {
                    DetailVC(id: vm.rec_id)
                }
                .fullScreenCover(isPresented: $isQrCodeTapped, onDismiss: nil, content: {
                    ScannerView(isPresented: $isQrCodeTapped, text: .constant(nil), recipe: $scannedRecipeId)
                })
                .fullScreenCover(isPresented: $isSearchClick, content: {
                    SearchView().environmentObject(userState)
                })
                .onChange(of: vm.errorMessage) { _ in
                    if vm.errorMessage == StringKeys.authError{
                        userState.authOut()
                    }
                }
                .onChange(of: scannedRecipeId!) { newValue in
                    debugPrint(newValue)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.isReceipesList.toggle()
                    }
                }
                
            }.fullScreenCover(isPresented: $isReceipesList, onDismiss: nil, content: {
                RecipesCheckList(rec_id: scannedRecipeId ?? "")

            })
                            
            
            
            
        }
        else{
            Text(vm.errorMessage)
        }
        
    }
    
    private func link<Destination: View>(destination: Destination) -> some View {
            NavigationLink(destination: destination) {
                destination
            }
        }
    private var horizontalStoires:some View{
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(categories, id: \.self) { index in
                    ZStack(alignment:.bottom){
                        Image("A")
                            .resizable()
                            .overlay(ImageOverlay(message:index,font: .callout,lineL: 2), alignment: .bottomLeading)
                            .frame(width: 120, height: 120)
                    }.cornerRadius(10)
                        .onTapGesture {
                            self.userState.category = index
                            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                                self.isSearchClick.toggle()
                            }
                        }
                }
            }.padding()
            
                
        }
        .frame(height:130)
        
        
    }
    
    private var cellListView:some View{
        LazyVStack(spacing:-10){
            ForEach(vm.receips, id: \.id) { rec in
                ZStack{
                    HStack{
                        KFImage.url(URL(string:rec.imageURL?.replacingOccurrences(of: " ", with: "%20") ?? ""))
                            .resizable()
                            .diskCacheExpiration(.never)
                            .cacheMemoryOnly(false)
                            .frame(width: 120)
                            .cornerRadius(10)
                            .padding()
                        
                        Spacer().frame(width:2)
                        VStack(alignment: .leading, spacing: 8){
                            LabelTextView(text: rec.name ?? "", forColor:.textColor, fontWeight: .bold, size: 18)
                            LabelTextView(text: rec.category ?? "", forColor:.textColor, fontWeight: .regular, size: 16)
                            HStack(spacing:8){
                                HStack{
                                    Image(systemName: ImagesName.clock.rawValue)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth:15,maxHeight: 15)
                                    //Text(rec.cookingTime ?? "")
                                    LabelTextView(text: rec.cookingTime ?? "", forColor:.textColor, fontWeight: .regular, size: 16)
                                }
                                HStack{
                                    Image(systemName: ImagesName.user.rawValue)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth:15,maxHeight: 15)
                                    //Text(rec.servings ?? "")
                                    LabelTextView(text: rec.servings ?? "", forColor:.textColor, fontWeight: .regular, size: 16)
                                }
                            }
                            //Spacer()
                        }
                        Spacer()
                    }
                }
                .frame(height:140)
                
                    .onTapGesture {
                        vm.rec_id = "\(rec.id ?? 0)"
                        isNavigate.toggle()
                    }
                    
            }
            
        }
        
    }
    
    
    private var headerView:some View{
        HStack{
            LabelTextView(text: "Недавний", forColor: .textColor, fontWeight: .bold, size: 18)
//            Text("CeronuE").padding(5).background(RoundedRectangle(cornerRadius: 8).fill(.gray.opacity(0.3)))
//            Spacer()
//            Image(systemName: "text.book.closed").resizable()
//                .frame(width:25,height: 25)
        }.padding([.leading,.trailing], 8)
        
    }
}

struct LabelTextView:View{
    let text:String
    let forColor:Color
    let fontWeight:Font.Weight
    let size:CGFloat
    var body:some View{
        Text(text).foregroundColor(forColor)
            .font(.system(size: size, weight: fontWeight, design: .default))
            .lineLimit(3)
            .minimumScaleFactor(0.5)
    }
}

struct HomeVC_Previews: PreviewProvider {
    static var previews: some View {
        HomeVC()
    }
}
