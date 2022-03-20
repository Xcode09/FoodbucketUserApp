//
//  SignUpView.swift
//  FoodPlaniOS
//
//  Created by Muhammad Ali on 19/03/2022.
//

import SwiftUI
import Combine
import Alamofire
fileprivate class SignUpViewModel:ObservableObject{
    
    @Published var canSubmit = false
    
    @Published var errorMessage = ""
    var cancellationToken: AnyCancellable?
    @Environment(\.presentationMode) var presentationMode
    func signUpTapped(_ url:String,para:[String:String],image:UIImage)
    {
        self.canSubmit = true
        guard let data = image.jpegData(compressionQuality: 0.7) else {return}
        let pu : AnyPublisher<DataResponse<BasicModel, NetworkError>, Never> =  Service.shared.uploadFormData(url: url, method: "POST", isHeaderToke: true, parameters: para, imgData: data)
        cancellationToken = pu.sink { (dataResponse) in
            if dataResponse.error != nil{
                self.canSubmit = false
                self.errorMessage = dataResponse.error?.initialError ?? ""
            }else{
                if let _ = dataResponse.value{
                    self.errorMessage = dataResponse.value?.message ?? ""
                    self.canSubmit = false
                    self.presentationMode.wrappedValue.dismiss()
                }
                
            }
        }
    }
}
struct SignUpView: View {
    @ObservedObject fileprivate var vm = SignUpViewModel()
    @State var image: UIImage? = nil
    @State var isImageTapped = false
    @State var email = ""
    @State var password = ""
    @State var userName = ""
   
    var body: some View {
        VStack(spacing:20){
            Text("Welcome,")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.black)
                .font(.system(size: 25, weight: .regular, design: .default))
            
            Text("Sign up to continune")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.black)
                .font(.system(size: 18, weight: .regular, design: .default))
            
            Image(uiImage: image ?? UIImage())
                .resizable()
                .frame(maxWidth:100,maxHeight: 100)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray, lineWidth: 0.5))
                .onTapGesture {
                    isImageTapped.toggle()
                }
            
            SignUpRow(title: "Username", placeholder: "Enter Your Username", imageIcon: "person", isSecure: false, iconTint: .green, text: $userName)
            SignUpRow(title: "Email", placeholder: "Enter Your Email", imageIcon: "envelope", isSecure: false, iconTint: .green, text: $email)
            SignUpRow(title: "Password", placeholder: "Enter Your Password", imageIcon: "lock", isSecure: true, iconTint: .green, text: $password)
            if vm.canSubmit{
                ProgressView().progressViewStyle(CircularProgressViewStyle())
            }else{
                Button(action: {
                    if email.isEmpty && password.isEmpty && userName.isEmpty
                    {
                        vm.errorMessage = "Email or password empty"
                        return
                    }else{
                       let para = [
                        "name":userName,
                        "email":email,
                        "password":password,
                        "role_id":"3"
                       ]
                        vm.signUpTapped(ApiEndPoints.createAccount, para: para, image: self.image!)
                    }
                }) {
                    VStack{
                        Text("Sign up").foregroundColor(.white)
                            .font(.system(size: 18, weight: .medium, design: .default))
                    }.padding()
                        .frame(maxWidth:UIScreen.main.bounds.width - 20,maxHeight: 46)
                        .background(Color.green)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                }
            }
            
            HStack{
                Text("Already have an account?")
                Text("Sign In")
                    .foregroundColor(.green)
            }
            
            if vm.errorMessage != ""{
                Text(vm.errorMessage)
                    .foregroundColor(.red)
            }
            
            Spacer()
        }.padding([.all], 10)
            .sheet(isPresented: $isImageTapped, onDismiss: nil) {
                ImagePicker(sourceType: .photoLibrary) { uimage in
                    self.image = uimage
                }
            }
            .onChange(of: email) { newValue in
                vm.errorMessage = ""
            }
            .onChange(of: password) { newValue in
                vm.errorMessage = ""
            }
            .onChange(of: userName) { newValue in
                vm.errorMessage = ""
            }
            .onChange(of: image) { newValue in
                vm.errorMessage = ""
            }
    }
    
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
struct ImagePicker: UIViewControllerRepresentable {

    @Environment(\.presentationMode)
    private var presentationMode

    let sourceType: UIImagePickerController.SourceType
    let onImagePicked: (UIImage) -> Void

    final class Coordinator: NSObject,
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate {

        @Binding
        private var presentationMode: PresentationMode
        private let sourceType: UIImagePickerController.SourceType
        private let onImagePicked: (UIImage) -> Void

        init(presentationMode: Binding<PresentationMode>,
             sourceType: UIImagePickerController.SourceType,
             onImagePicked: @escaping (UIImage) -> Void) {
            _presentationMode = presentationMode
            self.sourceType = sourceType
            self.onImagePicked = onImagePicked
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            onImagePicked(uiImage)
            presentationMode.dismiss()

        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            presentationMode.dismiss()
        }

    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(presentationMode: presentationMode,
                           sourceType: sourceType,
                           onImagePicked: onImagePicked)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<ImagePicker>) {

    }

}
