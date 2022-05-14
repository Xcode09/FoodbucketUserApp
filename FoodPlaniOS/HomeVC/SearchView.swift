//
//  SearchView.swift
//  FoodPlaniOS
//
//  Created by Muhammad Ali on 11/05/2022.
//

import SwiftUI
import Combine
import Alamofire
import Kingfisher
final class SearchViewModel:ObservableObject{
    @Published var receips:[Recipes] = []
    @Published var errorMessage = ""
    @Published var isLoading = false
    var rec_id = ""
    var cancellationToken: AnyCancellable?
    func getSearchRecipes(_ url:String,search:String){
        isLoading = true
        let pu : AnyPublisher<DataResponse<RecipesModel, NetworkError>, Never> =  Service.shared.fetchData(url: url, method: "POST",isHeaderToke: true, parameters: ["search":search])
        cancellationToken = pu.sink { (dataResponse) in
            self.isLoading = false
            if dataResponse.error != nil{
                self.errorMessage = dataResponse.error?.initialError ?? ""
            }else{
                if let data = dataResponse.value?.data{
                    guard data.count > 0 else {
                        self.errorMessage = "Поиск не найден"
                        return
                    }
                    self.errorMessage = ""
                    self.receips =  data
                }
                
            }
        }
    }
}
struct SearchView: View {
    @State private var searchTxt = ""
    //private var isEmpty = false
    @State private var isNavigate = false
    @ObservedObject var vm = SearchViewModel()
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView{
            VStack{
                HStack{
                    TextField("search", text: $searchTxt)
                    Button(action: {
                        if searchTxt.isEmpty{
                            return
                        }else{
                            vm.getSearchRecipes(ApiEndPoints.searchRecipes, search: searchTxt)
                        }
                        
                    }) {
                        Text("search").foregroundColor(.white)
                    }.frame(width:80,height: 46)
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.iconTintColor))
                }.padding(.all, 10)
                .frame(height:46)
                Spacer()
                if vm.isLoading{
                    ProgressView().progressViewStyle(CircularProgressViewStyle())
                }else{
                    if vm.errorMessage.isEmpty {
                        ScrollView{
                            cellListView
                        }
                        Spacer()
                    }else{
                        Text(vm.errorMessage).font(.headline)
                        Spacer()
                    }
                    Spacer()
                }
                Spacer()
            }
            
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .resizable()
                    }
                }
            })
            .fullScreenCover(isPresented: $isNavigate, onDismiss: nil) {
                DetailVC(id: vm.rec_id)
            }
            
        }
    }
    private var cellListView:some View{
        LazyVStack(spacing:-10){
            ForEach(vm.receips, id: \.id) { rec in
                ZStack{
                    HStack{
                        KFImage.url(URL(string:rec.imageURL ?? ""))
                            .resizable()
                            .diskCacheExpiration(.never)
                            .cacheMemoryOnly(false)
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
                
                    .onTapGesture {
                        vm.rec_id = "\(rec.id ?? 0)"
                        isNavigate.toggle()
                    }
                    
            }
            
        }
        
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
