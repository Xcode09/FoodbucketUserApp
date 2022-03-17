//
//  ScannerView.swift
//  FoodPlaniOS
//
//  Created by Muhammad Ali on 14/12/2021.
//

import SwiftUI

struct ScannerView: View {
    var body: some View {
        CodeScannerView(
                    codeTypes: [.qr],
                    completion: { result in
                        if case let .success(code) = result {
//                            self.scannedCode = code
//                            self.isPresentingScanner = false
                        }
                    }
                )
    }
}

struct ScannerView_Previews: PreviewProvider {
    static var previews: some View {
        ScannerView()
    }
}
