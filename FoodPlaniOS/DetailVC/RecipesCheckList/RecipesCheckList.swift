//
//  RecipesCheckList.swift
//  FoodPlaniOS
//
//  Created by Muhammad Ali on 02/04/2022.
//

import SwiftUI
import Alamofire
import Combine
import Kingfisher
fileprivate class RecipesCheckListViewModel:ObservableObject{
    @Published var receips:[Recipes] = []
    @Published var ingredients : [Ingredient] = []
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
                    if data.count > 0 {
                        self.receips =  data
                        guard let ingred = data.first?.ingredients else {
                            self.errorMessage = "No Recipe Found"
                            return
                            
                        }
                        self.ingredients = ingred
                    }else{
                        self.errorMessage = "No Recipe Found"
                        self.receips =  data
                    }
                    
                }
                
            }
        }
    }
}
struct RecipesCheckList: View {
    @State private var selection: [String]? = []
    @State private var isScanTapped = false
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var vm = RecipesCheckListViewModel()
////    let receipes : [Recipes]
//    let ingredients : [Ingredient]
    init(rec_id:String){
//        self.receipes = rec
//        self.ingredients = rec[0].ingredients ?? []
        
        vm.getSelectRecipe(ApiEndPoints.customerSelectRecipes, id: rec_id)
    }
    var body: some View {
        NavigationView{
            if vm.receips.count > 0{
                ScrollView{
                    VStack(spacing:10){
                        Spacer()
                        
                        KFImage.url(URL(string: vm.receips[0].imageURL ?? ""))
                            .resizable()
                            .scaledToFill()
                        Spacer()
                        Button(action: {
                            isScanTapped.toggle()
                        }) {
                            Text("Scan Qr Code")
                                .frame(maxWidth:.infinity)
                                .foregroundColor(.white)
                                
                            
                        }.frame(height:46)
                            .background(RoundedRectangle(cornerRadius: 8).fill(Color.iconTintColor))
                        Text("Ingredients")
                            .frame(maxWidth:.infinity,alignment: .leading)
                            .font(.system(size: 18, weight: .bold, design: .default))
                            .foregroundColor(.black)
                        ForEach(vm.ingredients,id:\.id)
                        {
                            index in
                            if selection?.count ?? 0 > 0,
                               selection!.contains(index.ingredientName?.first?.ingreID ?? "")
                            {
                                HStack {
                                    KFImage.url(URL(string: index.ingredientName?.first?.imageURL ?? ""))
                                        .resizable()
                                        .frame(maxWidth:80,maxHeight:80)
                                    VStack{
                                        Text(index.ingredientName?.first?.name ?? "")
                                        Text("\(index.ingredientName?.first?.totalQuantity ?? "") \(index.ingredientName?.first?.unit ?? "")")
                                        
                                    }
                                    Spacer()
                                    Image("check")
                                }
                            }else{
                                HStack {
                                    KFImage.url(URL(string: index.ingredientName?.first?.imageURL ?? ""))
                                        .resizable()
                                        .frame(maxWidth:80,maxHeight:80)
                                    VStack{
                                        Text(index.ingredientName?.first?.name ?? "")
                                        Text("\(index.ingredientName?.first?.totalQuantity ?? "") \(index.ingredientName?.first?.unit ?? "")")
                                    }
                                    Spacer()
                                    Image(systemName:"circle")
                                        .foregroundColor(.iconTintColor)
                                }
                            }

                        }
                        
                    }.frame(maxWidth: .infinity)
                        .padding([.all], 10)
                        .fullScreenCover(isPresented: $isScanTapped) {
                            ScannerView(isPresented: $isScanTapped, text: $selection, recipe: .constant(nil))
                        }
                        .onChange(of: selection) { newValue in
                            debugPrint("ddd",selection)
                        }
                    
                    
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(Text(vm.receips.first?.name ?? ""))
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
            }else{
                Text(vm.errorMessage)
                    .font(.largeTitle)
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle(Text(""))
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
            }
        }
        
    }
}

struct RecipesCheckList_Previews: PreviewProvider {
    static var previews: some View {
        RecipesCheckList(rec_id: "")
    }
}
