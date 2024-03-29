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
                            self.errorMessage = "Рецепт не найден"
                            return
                            
                        }
                        self.ingredients = ingred
                    }else{
                        self.errorMessage = "Рецепт не найден"
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
    @State var showingAlert = false
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
                    VStack(spacing:5){
                        Spacer()
                        VStack{
                            KFImage.url(URL(string: vm.receips[0].imageURL ?? ""))
                                .resizable()
                                .clipped()
                        }.frame(height:250)
                        Spacer()
                        VStack{
                            Button(action: {
                                isScanTapped.toggle()
                            }) {
                                Text("Сканировать QR-код")
                                    .frame(maxWidth:.infinity)
                                    .foregroundColor(.white)
                                    
                                
                            }.frame(height:46)
                                .background(RoundedRectangle(cornerRadius: 4).fill(Color.iconTintColor))
                            Text("Ингредиенты")
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
                                                .frame(maxWidth:.infinity,alignment: .leading)
                                            Text("\(index.ingredientName?.first?.totalQuantity ?? "") \(index.ingredientName?.first?.unit ?? "")")
                                                .frame(maxWidth:.infinity,alignment: .leading)
                                            
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
                                                .frame(maxWidth:.infinity,alignment: .leading)
                                            Text("\(index.ingredientName?.first?.totalQuantity ?? "") \(index.ingredientName?.first?.unit ?? "")")
                                                .frame(maxWidth:.infinity,alignment: .leading)
                                        }
                                        Spacer()
                                        Image(systemName:"circle")
                                            .foregroundColor(.iconTintColor)
                                    }
                                }

                            }
                        }
                        .padding([.all], 10)
                    }.frame(maxWidth: .infinity)
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
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button(action: {
                            showingAlert.toggle()
                        }) {
                            Text("Готово").foregroundColor(.white)
                                .padding(.all,5)
                        }
                        
                        .background(RoundedRectangle(cornerRadius:4).fill(Color.iconTintColor))
                        .alert(isPresented:$showingAlert) {
                            Alert(
                                title: Text("Выйти из сканирования"),
                                message: Text("Вы хотите остановить сканирование и вернуться?"),
                                primaryButton:
                                        .default(Text("Да").foregroundColor(.iconTintColor)){
                                            presentationMode.wrappedValue.dismiss()
                                        },
                                secondaryButton: .cancel(Text("Нет").foregroundColor(.iconTintColor))
                            )
                        }
                    }
//                    ToolbarItemGroup(placement: .navigationBarLeading) {
//                        Button(action: {
//                            presentationMode.wrappedValue.dismiss()
//                        }) {
//                            Image(systemName: "chevron.left")
//                                .resizable()
//                        }
//                    }
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
