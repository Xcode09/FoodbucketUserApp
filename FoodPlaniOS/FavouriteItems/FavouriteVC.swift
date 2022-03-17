//
//  FavouriteVC.swift
//  FoodPlaniOS
//
//  Created by Muhammad Ali on 12/12/2021.
//

import SwiftUI

struct FavouriteVC: View {
    var body: some View {
        NavigationView{
            ZStack{
                ScrollView{
                    LazyVStack(alignment:.leading,spacing:40){
                        ForEach(0..<2, id: \.self) { _ in
                            mainCellView
                            //Divider()
                        }
                    }.padding()
                }
            }.navigationTitle("Favourites")
        }
    }
    
    private var mainCellView:some View{
        VStack(alignment:.leading){
            LabelTextView(text: "Receipe for rice", forColor: .textColor, fontWeight: .bold, size: 18)
            ZStack(alignment:.bottom){
                Image("A")
                    .resizable()
                    .frame(width: 180, height: 120)
                VStack(alignment:.trailing){
                    HStack(spacing:8){
                        HStack{
                            Image(systemName: "clock")
                            Text("75").foregroundColor(.white)
                                .font(.system(size: 16, weight: .semibold, design: .default))
                                .shadow(color: .gray, radius: 3, x: 1, y: 1)
                                
                        }
                        HStack{
                            Image(systemName: "clock")
                            Text("1").foregroundColor(.white)
                                .font(.system(size: 16, weight: .semibold, design: .default))
                                .shadow(color: .gray, radius: 3, x: 1, y: 1)
                                
                        }
                        Spacer()
                    }.foregroundColor(.white)
                        .padding([.leading,.bottom], 5)
                }
                .frame(width:180)
                
            }.cornerRadius(10)
            HStack(spacing:10){
                LabelTextView(text: "Lopa Lpa lmas ygt.Lopa Lpa lmas ygt", forColor: .textColor, fontWeight: .semibold, size: 16)
                Spacer()
                VStack{
                    Button(action: {}) {
                        Text("...")
                    }
                    Spacer()
                }
            }.frame(width:180)
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
