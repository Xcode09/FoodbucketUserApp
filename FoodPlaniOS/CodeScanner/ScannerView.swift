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
    var body: some View {
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
                )
    }
}

//struct ScannerView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScannerView()
//    }
//}
