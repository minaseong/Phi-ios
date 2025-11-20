//
//  LoginView.swift
//  Citizen_Alerts
//
//  Created by Mina on 11/18/25.
//

import SwiftUI

struct CheckBoxView: View { // apparently iOS checkbox toggle isn't default?!?!?!?! so yah declared
    @Binding var checked: Bool

    var body: some View {
        Image(systemName: checked ? "checkmark.square.fill" : "square")
            .foregroundColor(checked ? Color(UIColor.systemBlue) : Color.secondary)
            .onTapGesture {
                self.checked.toggle()
            }
    }
}

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var rememberMe: Bool = false
    @State private var emailTouched: Bool = false
    @State private var passwordTouched: Bool = false
    
    @State private var isLoggedIn: Bool = false
    @State private var loginError: String? = nil

    private var isEmailValid: Bool { Validator.validateEmail(email) }
    private var isPasswordValid: Bool { Validator.validatePassword(password) }
    private var canSubmit: Bool { isEmailValid && isPasswordValid }

    var body: some View {
        NavigationStack{
            ZStack {
                Color(.systemGray6)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    
                    // top black header
                    ZStack {
                        
                        Color("navyGray")   // from asset
                            .ignoresSafeArea()
                        
                        VStack(spacing: 16) {
                            Image("phi_with_text")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 30)
                                .padding(.top, 40)
                            VStack(spacing: 8) {
                                Text("Sign in to your\nAccount")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(Color("primaryWhite"))
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(6)
                                
                                Text("Enter your email and password to log in")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color("primaryWhite"))
                                    .padding(.top, 8)
                            }
                            .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal, 32)
                        
                    }
                    .frame(height: 380)
                    
                    // log in block
                    VStack(alignment: .leading, spacing: 8) {
                        
                        // Email & PW field
                        VStack(alignment: .leading, spacing: 4) {
                            TextField("Email address",
                                      text: $email,
                                      onEditingChanged: { began in
                                if !began { emailTouched = true }
                            })
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(emailTouched && !isEmailValid ? Color.red : Color.gray.opacity(0.3),
                                            lineWidth: 1)
                            )
                            .padding(.top, 12)
                            
                            if emailTouched && !isEmailValid {
                                Text("Please enter a valid email address.")
                                    .font(.system(size: 12))
                                    .foregroundColor(.red)
                            }
                            
                            SecureField("At least 8 characters", text: $password, onCommit: {
                                passwordTouched = true
                            })
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(passwordTouched && !isPasswordValid ? Color.red : Color.gray.opacity(0.3),
                                            lineWidth: 1)
                            )
                            .padding(.top, 8)
                            
                            if passwordTouched && !isPasswordValid {
                                // change the logic at helpers validations if necessary
                                // also change this text if u indeed ended up changing the logic
                                Text("Min 8 chars, 1 capital letter, 1 number, 1 symbol.")
                                    .font(.system(size: 12))
                                    .foregroundColor(.red)
                            }
                        }
                        
                        // Remember me + Forgot Password
                        HStack {
                            HStack { // Remember me
                                CheckBoxView(checked: $rememberMe)
                                Spacer()
                                    .frame(width: 5)
                                Text("Remember me")
                                    .font(.system(size: 14))
                                    .foregroundStyle(Color.gray)
                            }
                            Spacer()
                            Button(action: {
                                // TODO: Forgot password action
                            }) {
                                Text("Forgot Password ?")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color("primaryBlue"))
                            }
                        }
                        .padding(.top, 8)
                        
                        // Log In button
                        Button(action: {
                            guard canSubmit else { return }

                            loginError = nil

                            Task {
                                do {
                                    let user = try await AuthAPI.login(email: email, password: password)
                                    print("Logged in as \(user.email)")
                                    // later: store User(from: user) in app state if you want
                                    isLoggedIn = true
                                } catch APIError.invalidStatusCode(401) {
                                    loginError = "Incorrect email or password."
                                } catch {
                                    loginError = "Could not reach server. Please try again."
                                    print("Login error:", error)
                                }
                            }
                        }) {
                            Text("Log In")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color("primaryWhite"))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    LinearGradient(
                                        colors: [Color("navyGray"), Color("navyGray").opacity(0.7)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(10)
                                .opacity(canSubmit ? 1.0 : 0.5)
                        }
                        .disabled(!canSubmit)
                        .padding(.top, 16)
                        
                        if let loginError {
                            Text(loginError)
                                .font(.system(size: 12))
                                .foregroundColor(.red)
                                .padding(.top, 4)
                        }
                        
                        // Sign up option
                        HStack(spacing: 4) {
                            Text("Don’t have an account?")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            
                            Button(action: {
                                // TODO: Navigate to sign up tlqkf!!! same thing again!!! tlqkf!!!
                            }) {
                                Text("Sign Up")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color("primaryBlue"))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 16)
                        .padding(.bottom, 12)
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                    )
                    .padding(24)
                    .offset(y: -75)   // lifts the log in card to go over the header a lil bit
                    Spacer()
                }
            }
            .navigationDestination(isPresented: $isLoggedIn) {MapView() }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
