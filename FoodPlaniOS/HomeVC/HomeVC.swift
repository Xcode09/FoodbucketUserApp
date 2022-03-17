//
//  HomeVC.swift
//  FoodPlaniOS
//
//  Created by Muhammad Ali on 12/12/2021.
//

import SwiftUI
import Combine
import Kingfisher

class HomeVCViewModel:ObservableObject{
    @Published var receips:[Recipes] = []
    @Published var errorMessage = ""
    var cancellationToken: AnyCancellable?
    
    func getRecipes(_ url:String){
        let pu : AnyPublisher<RecipesModel,NetworkError> =  Service.shared.fetchData(url: url, method: "Get", isHeaderToke: true)
        cancellationToken = pu.sink { err in
            switch err{
            case .failure(let erro):
                self.errorMessage = erro.initialError
            default:
                break
            }
        } receiveValue: { model in
            guard let da = model.data else{
                return
            }
            self.receips = da
        }
    }
}

struct HomeVC: View {
    @State private var isNavigate = false
    @ObservedObject var vm = HomeVCViewModel()
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
                            cellListView.onTapGesture {
                                isNavigate.toggle()
                            }
                            
                            Spacer()
                        }
                    }
                }
                
                .navigationBarTitle("Menu")
                .toolbar {
                    HStack{
                        Button(action: {}) {
                            Image("icon_search").resizable().aspectRatio(contentMode: .fit)
                        }
                    }
                }
                .sheet(isPresented: $isNavigate, onDismiss: nil) {
                    DetailVC()
                }
            }
        }
        else{
            Text(vm.errorMessage)
        }
        
    }
    
    
    private var horizontalStoires:some View{
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(0...2, id: \.self) { index in
                    ZStack(alignment:.bottom){
                        Image("A")
                            .resizable()
                            .overlay(ImageOverlay(message: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem Ipsum has been the industry",font: .callout,lineL: 2), alignment: .bottomLeading)
                            .frame(width: 120, height: 120)
                    }.cornerRadius(10)
                }
            }.padding()
                
        }
        .frame(height:130)
        
        
    }
    
    private var cellListView:some View{
        ScrollView{
            LazyVStack(spacing:-10){
                ForEach(vm.receips, id: \.id) { rec in
                    ZStack{
                        HStack{
                            KFImage.url(URL(string:rec.imageURL ?? ""))
                                .resizable()
                                .frame(width: 120)
                                .cornerRadius(10)
                                .padding()
                            
                            Spacer().frame(width:2)
                            VStack(alignment: .leading, spacing: 8){
                                LabelTextView(text: rec.name ?? "", forColor:.textColor, fontWeight: .bold, size: 18)
                                LabelTextView(text: rec.servings ?? "", forColor: .secondaryTextColor, fontWeight: .regular, size: 16)
                                HStack(spacing:8){
                                    HStack{
                                        Image(systemName: ImagesName.clock.rawValue)
                                        Text(rec.cookingTime ?? "")
                                    }
                                    HStack{
                                        Image(systemName: ImagesName.user.rawValue)
                                        Text(rec.servings ?? "")
                                    }
                                }
                                //Spacer()
                            }
                            Spacer()
                            Button(action: {}) {
                                VStack{
                                    Text("...").font(.system(size: 20, weight: .bold, design: .default))
                                }
                            }.padding([.trailing], 8)
                            //Spacer()
                        }
                    }.frame(height:140)
                    
                }
            }
            
            
        }
        
    }
    
    
    private var headerView:some View{
        HStack{
            LabelTextView(text: "Bockpecehbe 12.12", forColor: .textColor, fontWeight: .bold, size: 18)
            Text("CeronuE").padding(5).background(RoundedRectangle(cornerRadius: 8).fill(.gray.opacity(0.3)))
            Spacer()
            Image(systemName: "text.book.closed").resizable()
                .frame(width:25,height: 25)
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
