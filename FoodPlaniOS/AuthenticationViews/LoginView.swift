//
//  LoginView.swift
//  FoodPlaniOS
//
//  Created by Muhammad Ali on 19/03/2022.
//

import SwiftUI
import Combine
import Alamofire
fileprivate class LoginViewModel:ObservableObject{
    
    @Published var isEmailCriteriaValid = true
    @Published var isPasswordCriteriaValid = true
    @Published var isPasswordConfirmValid = true
    //@Published var isAgeValid = false
    @Published var canSubmit = false
    @Published var isLoginSuccess = false
    @Published var errorMessage = ""
    var cancellationToken: AnyCancellable?
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", "(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])")
    let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]{8,}$")
    
//    func validateEmail()->Bool{
//        self.isEmailCriteriaValid = self.emailPredicate.evaluate(with: self.email)
//        return self.isEmailCriteriaValid
//    }
//    var vm = AuthenticationViewModel()
    
    func loginTapped(_ url:String,email:String,password:String){
        self.canSubmit = true
        let pu : AnyPublisher<DataResponse<LoginDataModel, NetworkError>, Never> =  Service.shared.fetchData(url: url, method: "POST", isHeaderToke: true,parameters: ["email":email,"password":password])
        cancellationToken = pu.sink { (dataResponse) in
            if dataResponse.error != nil{
                self.canSubmit = false
                self.errorMessage = dataResponse.error?.initialError ?? ""
            }else{
                if let _ = dataResponse.value?.user{
                    guard let model = dataResponse.value else {
                        return
                    }
                    UserDefaults.standard.save(StringKeys.saveUserKey, model: model)
                    DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                        self.isLoginSuccess = true
                        self.canSubmit = false
                    }
                }else{
                    self.canSubmit = false
                    self.errorMessage = "Invalid Credentials"
                }
            }
        }
    }
    
}
struct LoginView: View {
    @State var isSignUp = false
    @State var email = ""
    @State var password = ""
    @ObservedObject fileprivate var vm = LoginViewModel()
    @EnvironmentObject var userState: UserStateViewModel
    var body: some View {
        if vm.isLoginSuccess{
            userState.isLoggedIn = true
        }
        return VStack(spacing:20){
            Text("Добро пожаловать,")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.black)
                .font(.system(size: 25, weight: .regular, design: .default))
            Text("Войдите, чтобы продолжить")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.black)
                .font(.system(size: 18, weight: .regular, design: .default))
            SignUpRow(title: "Эл. адрес", placeholder: "Введите ваш адрес электронной почты", imageIcon: "envelope", isSecure: false, iconTint: .green, text: $email)
            SignUpRow(title: "Пароль", placeholder: "Введите ваш пароль", imageIcon: "lock", isSecure: true, iconTint: .green, text: $password)
            
            Button(action: {}) {
                Text("Забыли пароль")
                    .foregroundColor(.black)
            }
            if vm.canSubmit{
                ProgressView().progressViewStyle(CircularProgressViewStyle())
            }else{
                Button(action: {
                    if email.isEmpty && password.isEmpty{
                        vm.errorMessage = "Электронная почта или пароль пусты"
                    }else{
                       
                        vm.loginTapped(ApiEndPoints.login,email: email,password: password)
                    }
                }) {
                    VStack{
                        Text("Войти").foregroundColor(.white)
                            .font(.system(size: 18, weight: .medium, design: .default))
                    }.padding()
                        .frame(maxWidth:UIScreen.main.bounds.width - 20,maxHeight: 46)
                        .background(Color.green)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                }
            }
            
            HStack{
                Text("У вас нет аккаунта?")
                Text("Зарегистрироваться")
                    .foregroundColor(.green)
                    .onTapGesture {
                        self.isSignUp.toggle()
                    }
            }
            if vm.errorMessage != ""{
                Text(vm.errorMessage)
                    .foregroundColor(.red)
            }
            Spacer()
        }.padding([.all], 10)
            .fullScreenCover(isPresented:$isSignUp, onDismiss: nil, content: {
                SignUpView()
            })
            .onChange(of: email) { newValue in
                vm.errorMessage = ""
            }
            .onChange(of: password) { newValue in
                vm.errorMessage = ""
            }
        
//        if vm.isLoginSuccess {
//            TabView{
//                HomeVC().tabItem {
//                    Label("Menu", systemImage: ImagesName.house_fill.rawValue)
//                }
//                CheckViewVC().tabItem {
//                    Label("Check", systemImage: "list.dash")
//                }
////                ScannerView().tabItem {
////                    Label("QR Scan", systemImage: "list.dash")
////                }
//                FavouriteVC().tabItem {
//                    Label("Favourite", systemImage: ImagesName.heart.rawValue)
//                }
//                ProfileView().tabItem {
//                    Label("Profile", systemImage: ImagesName.user.rawValue)
//                }
//            }
//        }else{
//
//        }
       
    }
    
}
struct SignUpRow:View{
    let title:String
    let placeholder:String
    let imageIcon:String
    let isSecure:Bool
    let iconTint:Color
    let textCase:Text.Case = .lowercase
    @Binding var text:String
    var body: some View{
        VStack(alignment:.leading)
        {
            Text(title).foregroundColor(.black)
                .font(.system(size: 18, weight: .medium, design: .default))
            HStack {
                Image(systemName:imageIcon)
                    .foregroundColor(iconTint)
                if isSecure{
                    SecureField(placeholder, text: $text)
                        .textCase(textCase)
                }else{
                    TextField(placeholder, text: $text)
                        .textCase(textCase)
                }
            }
            .padding()
            .overlay(Capsule().stroke(lineWidth: 0.5).foregroundColor(Color.gray))
        }
    }
    
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
