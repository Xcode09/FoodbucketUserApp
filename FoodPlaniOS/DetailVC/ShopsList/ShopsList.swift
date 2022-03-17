//
//  ShopsList.swift
//  FoodPlaniOS
//
//  Created by Muhammad Ali on 01/02/2022.
//

import SwiftUI

struct ShopsList: View {
    var body: some View {
        ZStack{
            Color(UIColor.secondarySystemBackground).edgesIgnoringSafeArea(.all)
            ScrollView{
                ForEach(0..<2){
                    _ in
                    ShopCellView()
                }
            }
        }
        
    }
}

struct ShopCellView:View{
    var body: some View{
        HStack{
            ZStack{
                Color(UIColor.systemGray6)
                Image("A")
                    .frame(width: 120, height: 120, alignment: .center)
                    .cornerRadius(15)
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                
            }.frame(maxWidth:140,maxHeight:140)
                .cornerRadius(15)
                .padding([.all], 5)
            Spacer()
            
            
            VStack(spacing:10){
                Text("Shop Name")
                    .font(.system(size: 18, weight: .bold, design: .default))
                    .foregroundColor(.textColor)
                Text("Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit..")
                Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book")
                
                HStack{
                    Text("$$$")
                        .font(.system(size: 18, weight: .bold, design: .default))
                        .foregroundColor(.textColor)
                    Spacer()
                    Button(action: {}) {
                        VStack{
                            Text("Order")
                                .font(.system(size: 18, weight: .semibold, design: .default))
                                .foregroundColor(.white)
                        }.frame(width: 80, height: 46, alignment: .center)
                    }.background(Capsule().fill(.black))
                    
                    
                    
                }.padding([.leading,.trailing], 10)
                
            }
        }
        .frame(maxHeight:240)
        .background(RoundedRectangle(cornerRadius: 15).fill(.white)
                        .shadow(color: Color(UIColor.systemGray4), radius: 25, x:5, y:5)
        )
        .padding([.leading,.trailing], 10)
        
    }
}



struct ShopsList_Previews: PreviewProvider {
    static var previews: some View {
        ShopsList()
    }
}
