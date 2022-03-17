    //
    //  ProfileView.swift
    //  FoodPlaniOS
    //
    //  Created by Muhammad Ali on 14/12/2021.
    //

    import SwiftUI
    struct ProfileView: View {
        var dummyArr = ["one","two","three","four"]
        var body: some View {
            NavigationView{
                ScrollView{
                    VStack{
                        VStack(alignment:.center,spacing: 10){
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .cornerRadius(50)
                            Text("Sample")
                        }
                        VStack{
                            
                        }.frame(height:50)
                        LazyVStack(alignment: .leading, spacing: 10){
                            ForEach(0..<dummyArr.count,id:\.self){
                                index in
                                Text("\(dummyArr[index])")
                                    .padding()
                                Divider()
                            }
                            
                            
                        }.background(Color.white)
                    }
                    Spacer().frame(height:30)
                    Button(action: {}) {
                        Text("Logout")
                    }
                }
                .background(Color(UIColor.groupTableViewBackground))
                .navigationBarTitle("Ali")
                .navigationBarTitleDisplayMode(.automatic)
            }
        }
    }

    struct ProfileView_Previews: PreviewProvider {
        static var previews: some View {
            ProfileView()
        }
    }
