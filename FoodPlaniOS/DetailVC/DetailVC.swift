//
//  DetailVC.swift
//  FoodPlaniOS
//
//  Created by Muhammad Ali on 15/12/2021.
//

import SwiftUI

struct DetailVC: View {
    @State var isShopListTapped = false
    var body: some View {
        NavigationView{
            VStack{
                ScrollView{
                    mainHeaderView
                    HStack{
                        Spacer().frame(width:5)
                        Image(systemName: "clock")
                        Text("Sample").foregroundColor(.textColor)
                        Text("Sample").foregroundColor(.secondaryTextColor)
                        Spacer()
                        Stepper("", onIncrement: {}, onDecrement: {})
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
    
    private var horizontalView:some View{
        VStack(alignment:.leading){
            Text("Sample")
                .font(.system(size: 18, weight: .bold, design: .default))
                .foregroundColor(.textColor)
            ScrollView(.horizontal){
                LazyHStack(spacing:10){
                    ForEach(0..<5,id:\.self){
                        index in
                        VStack(alignment:.center,spacing:10){
                            Image(ImagesName.meat.rawValue)
                                .resizable()
                                .frame(width:120,height: 80)
                                .cornerRadius(10)
                            Text("Sample 2").foregroundColor(.textColor)
                            Text("Sample").foregroundColor(.red)
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
            Image("A")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .overlay(ImageOverlay(message: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem Ipsum has been the industry",subText: "75",subText2: "4",subImage: ImagesName.clock.rawValue,subImage1: ImagesName.user.rawValue,isBottomViewEnable: true,lineL: 3), alignment: .bottomLeading)
            
        }
            
    }
    
    private var stepsView:some View{
        LazyVStack(){
            ForEach(0..<5,id:\.self){
                _ in
                LazyVStack(alignment:.leading,spacing: 20){
                    Text("Sample")
                        .font(.system(size: 18, weight: .bold, design: .default))
                        .foregroundColor(.textColor)
                    Image("A")
                        .resizable()
                    Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.")
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
        DetailVC()
    }
}
