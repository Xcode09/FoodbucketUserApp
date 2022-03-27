//
//  FavouriteVC.swift
//  FoodPlaniOS
//
//  Created by Muhammad Ali on 12/12/2021.
//

import SwiftUI
import Kingfisher
import Combine
import Alamofire
fileprivate class FavouriteVCModelView:ObservableObject{
    @Published var receips:[Recipe] = []
    @Published var errorMessage = ""
    @Published var quantity = 1
    //    @Published var showToast = false
    var cancellationToken: AnyCancellable?
    func getFavouriteRecipe(){
        let pu : AnyPublisher<DataResponse<FavouriteReceipeDataModel, NetworkError>, Never> =  Service.shared.fetchData(url: ApiEndPoints.customerFavouriteRecipesView, method: "POST", isHeaderToke: true)
        cancellationToken = pu.sink { (dataResponse) in
            if dataResponse.error != nil{
                self.errorMessage = dataResponse.error?.initialError ?? ""
            }else{
                if let data = dataResponse.value?.data
                {
                    for re in data{
                        if let rec = re.recipe {
                            self.receips.append(rec)
                        }
                        
                    }
                    
                }
                
            }
        }
    }
}
struct FavouriteVC: View {
    @ObservedObject fileprivate var vm = FavouriteVCModelView()
    var body: some View {
        NavigationView{
            if vm.receips.count > 0 {
                ZStack{
                    ScrollView{
                        LazyVStack(alignment:.leading,spacing:40){
                            ForEach(vm.receips, id: \.id) { recipe in
                                FavouriteCellRow(rec: recipe)
                            }
                        }.padding()
                    }
                }.navigationTitle("Favourites")
            }else{
                Text("избранное не найдено")
            }
            
        }.onAppear {
            vm.getFavouriteRecipe()
        }
    }
    
//    private var mainCellView:some View{
//        VStack(alignment:.leading){
//            LabelTextView(text: "Receipe for rice", forColor: .textColor, fontWeight: .bold, size: 18)
//            ZStack(alignment:.bottom){
//                Image("A")
//                    .resizable()
//                    .scaledToFill()
//                    .frame(maxWidth:.infinity, maxHeight: 180)
//                VStack(alignment:.trailing){
//                    HStack(spacing:8){
//                        HStack{
//                            Image(systemName: "clock")
//                            Text("75").foregroundColor(.white)
//                                .font(.system(size: 16, weight: .semibold, design: .default))
//                                .shadow(color: .gray, radius: 3, x: 1, y: 1)
//
//                        }
//                        HStack{
//                            Image(systemName: "clock")
//                            Text("1").foregroundColor(.white)
//                                .font(.system(size: 16, weight: .semibold, design: .default))
//                                .shadow(color: .gray, radius: 3, x: 1, y: 1)
//
//                        }
//                        Spacer()
//                    }.foregroundColor(.white)
//                        .padding([.leading,.bottom], 5)
//                }
//                .frame(maxWidth:.infinity)
//
//            }.cornerRadius(10)
//            HStack(spacing:10){
//                LabelTextView(text: "Lopa Lpa lmas ygt.Lopa Lpa lmas ygt", forColor: .textColor, fontWeight: .semibold, size: 16)
//                Spacer()
//                VStack{
//                    Button(action: {}) {
//                        Text("...")
//                    }
//                    Spacer()
//                }
//            }.frame(maxWidth:.infinity)
//        }
//    }
}


fileprivate struct FavouriteCellRow:View{
    let rec:Recipe
    var body :some View{
        VStack(alignment:.leading){
            LabelTextView(text:rec.name ?? "", forColor: .textColor, fontWeight: .bold, size: 18)
            ZStack(alignment:.bottom){
                KFImage.url(URL(string: rec.imageURL ?? ""))
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth:.infinity, maxHeight: 180)
                VStack(alignment:.trailing){
                    HStack(spacing:8){
                        HStack{
                            Image(systemName: "clock")
                            Text(rec.cookingTime ?? "").foregroundColor(.white)
                                .font(.system(size: 16, weight: .semibold, design: .default))
                                .shadow(color: .gray, radius: 3, x: 1, y: 1)
                                
                        }
                        HStack{
                            Image(systemName: "person")
                            Text(rec.servings ?? "").foregroundColor(.white)
                                .font(.system(size: 16, weight: .semibold, design: .default))
                                .shadow(color: .gray, radius: 3, x: 1, y: 1)
                                
                        }
                        Spacer()
                    }.foregroundColor(.white)
                        .padding([.leading,.bottom], 5)
                }
                .frame(maxWidth:.infinity)
                
            }.cornerRadius(10)
            HStack(spacing:10){
                LabelTextView(text:rec.category ?? "", forColor: .textColor, fontWeight: .semibold, size: 16)
                Spacer()
                VStack{
                    Button(action: {}) {
                        Text("...")
                    }
                    Spacer()
                }
            }.frame(maxWidth:.infinity)
        }
    }
}

struct FavouriteVC_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteVC()
    }
}


extension HorizontalAlignment {
   private enum HCenterAlignment: AlignmentID {
      static func defaultValue(in dimensions: ViewDimensions) -> CGFloat {
         return dimensions[HorizontalAlignment.center]
      }
   }
   static let hCenterred = HorizontalAlignment(HCenterAlignment.self)
}
