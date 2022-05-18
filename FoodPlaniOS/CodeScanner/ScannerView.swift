//
//  ScannerView.swift
//  FoodPlaniOS
//
//  Created by Muhammad Ali on 14/12/2021.
//

import SwiftUI

struct ScannerView: View {
    @Binding var isPresented : Bool
    @Binding var text:[String]?
    @Binding var recipe:String?
    @State var showingAlert = false
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView{
            CodeScannerView(
                        codeTypes: [.qr],
                        completion: { result in
                            if case let .success(code) = result {
                                if recipe != nil {
                                    recipe = code
                                    self.isPresented.toggle()
                                }else{
                                    self.text?.append(code)
                                    self.isPresented.toggle()
                                }
                            }
                        }
            ).ignoresSafeArea()
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button(action: {
                            showingAlert.toggle()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.iconTintColor)
                        }
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
        }
        
    }
}

//struct ScannerView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScannerView()
//    }
//}
