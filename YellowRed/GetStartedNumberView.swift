//
//  GetStartedNumberView.swift
//  YellowRed
//
//  Created by Krish Mehta on 29/5/23.
//

import SwiftUI

// struct Country: Hashable {
//     let name: String
//     let code: String
// }

struct GetStartedNumberView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var phoneNumber: String = ""
    @State private var isPhoneNumberValid: Bool = true
    
    @State private var verificationCode: String = ""
    @State private var verificationCodeSent: String = ""
    
    @State private var isVerificationEnabled: Bool = false
    
    @State private var display: Bool = false
    @State private var next: Bool = false
    
    //    @State private var country: Country = Country(name: "United States", code: "+1")
    
    let fullName: String
    var firstName: String {
        return fullName.components(separatedBy: " ").first ?? ""
    }
    
    //    let countries = [
    //        Country(name: "Afghanistan", code: "+93"),
    //        Country(name: "Albania", code: "+355"),
    //        Country(name: "Algeria", code: "+213"),
    //        Country(name: "American Samoa", code: "+1 (684)"),
    //        Country(name: "Andorra", code: "+376"),
    //        Country(name: "Angola", code: "+244"),
    //        Country(name: "Anguilla", code: "+1 (264)"),
    //        Country(name: "Antigua and Barbuda", code: "+1 (268)"),
    //        Country(name: "Argentina", code: "+54"),
    //        Country(name: "Armenia", code: "+374"),
    //        Country(name: "Aruba", code: "+297"),
    //        Country(name: "Ascension", code: "+247"),
    //        Country(name: "Australia", code: "+61"),
    //        Country(name: "Austria", code: "+43"),
    //        Country(name: "Azerbaijan", code: "+994"),
    //        Country(name: "Bahamas", code: "+1 (242)"),
    //        Country(name: "Bahrain", code: "+973"),
    //        Country(name: "Bangladesh", code: "+880"),
    //        Country(name: "Barbados", code: "+1 (246)"),
    //        Country(name: "Belarus", code: "+375"),
    //        Country(name: "Belgium", code: "+32"),
    //        Country(name: "Belize", code: "+501"),
    //        Country(name: "Benin", code: "+229"),
    //        Country(name: "Bermuda", code: "+1 (441)"),
    //        Country(name: "Bhutan", code: "+975"),
    //        Country(name: "Bolivia", code: "+591"),
    //        Country(name: "Bosnia and Herzegovina", code: "+387"),
    //        Country(name: "Botswana", code: "+267"),
    //        Country(name: "Brazil", code: "+55"),
    //        Country(name: "British Indian Ocean Territory", code: "+246"),
    //        Country(name: "British Virgin Islands", code: "+1 (284)"),
    //        Country(name: "Brunei", code: "+673"),
    //        Country(name: "Bulgaria", code: "+359"),
    //        Country(name: "Burkina Faso", code: "+226"),
    //        Country(name: "Burundi", code: "+257"),
    //        Country(name: "Cambodia", code: "+855"),
    //        Country(name: "Cameroon", code: "+237"),
    //        Country(name: "Canada", code: "+1"),
    //        Country(name: "Cape Verde", code: "+238"),
    //        Country(name: "Cayman Islands", code: "+1 (345)"),
    //        Country(name: "Central African Republic", code: "+236"),
    //        Country(name: "Chad", code: "+235"),
    //        Country(name: "Chile", code: "+56"),
    //        Country(name: "China", code: "+86"),
    //        Country(name: "Christmas Island", code: "+61"),
    //        Country(name: "Cocos (Keeling) Islands", code: "+61"),
    //        Country(name: "Colombia", code: "+57"),
    //        Country(name: "Comoros", code: "+269"),
    //        Country(name: "Cook Islands", code: "+682"),
    //        Country(name: "Costa Rica", code: "+506"),
    //        Country(name: "Croatia", code: "+385"),
    //        Country(name: "Cuba", code: "+53"),
    //        Country(name: "Curacao", code: "+599"),
    //        Country(name: "Cyprus", code: "+357"),
    //        Country(name: "Czech Republic", code: "+420"),
    //        Country(name: "Democratic Republic of the Congo", code: "+243"),
    //        Country(name: "Denmark", code: "+45"),
    //        Country(name: "Djibouti", code: "+253"),
    //        Country(name: "Dominica", code: "+1 (767)"),
    //        Country(name: "Dominican Republic", code: "+1 (809)"),
    //        Country(name: "East Timor", code: "+670"),
    //        Country(name: "Ecuador", code: "+593"),
    //        Country(name: "Egypt", code: "+20"),
    //        Country(name: "El Salvador", code: "+503"),
    //        Country(name: "Equatorial Guinea", code: "+240"),
    //        Country(name: "Eritrea", code: "+291"),
    //        Country(name: "Estonia", code: "+372"),
    //        Country(name: "Ethiopia", code: "+251"),
    //        Country(name: "Falkland Islands", code: "+500"),
    //        Country(name: "Faroe Islands", code: "+298"),
    //        Country(name: "Fiji", code: "+679"),
    //        Country(name: "Finland", code: "+358"),
    //        Country(name: "France", code: "+33"),
    //        Country(name: "French Polynesia", code: "+689"),
    //        Country(name: "Gabon", code: "+241"),
    //        Country(name: "Gambia", code: "+220"),
    //        Country(name: "Georgia", code: "+995"),
    //        Country(name: "Germany", code: "+49"),
    //        Country(name: "Ghana", code: "+233"),
    //        Country(name: "Gibraltar", code: "+350"),
    //        Country(name: "Greece", code: "+30"),
    //        Country(name: "Greenland", code: "+299"),
    //        Country(name: "Grenada", code: "+1 (473)"),
    //        Country(name: "Guam", code: "+1 (671)"),
    //        Country(name: "Guatemala", code: "+502"),
    //        Country(name: "Guernsey", code: "+44 (1481)"),
    //        Country(name: "Guinea", code: "+224"),
    //        Country(name: "Guinea-Bissau", code: "+245"),
    //        Country(name: "Guyana", code: "+592"),
    //        Country(name: "Haiti", code: "+509"),
    //        Country(name: "Honduras", code: "+504"),
    //        Country(name: "Hong Kong", code: "+852"),
    //        Country(name: "Hungary", code: "+36"),
    //        Country(name: "Iceland", code: "+354"),
    //        Country(name: "India", code: "+91"),
    //        Country(name: "Indonesia", code: "+62"),
    //        Country(name: "Iran", code: "+98"),
    //        Country(name: "Iraq", code: "+964"),
    //        Country(name: "Ireland", code: "+353"),
    //        Country(name: "Isle of Man", code: "+44 (1624)"),
    //        Country(name: "Israel", code: "+972"),
    //        Country(name: "Italy", code: "+39"),
    //        Country(name: "Ivory Coast", code: "+225"),
    //        Country(name: "Jamaica", code: "+1 (876)"),
    //        Country(name: "Japan", code: "+81"),
    //        Country(name: "Jersey", code: "+44 (1534)"),
    //        Country(name: "Jordan", code: "+962"),
    //        Country(name: "Kazakhstan", code: "+7"),
    //        Country(name: "Kenya", code: "+254"),
    //        Country(name: "Kiribati", code: "+686"),
    //        Country(name: "Kosovo", code: "+383"),
    //        Country(name: "Kuwait", code: "+965"),
    //        Country(name: "Kyrgyzstan", code: "+996"),
    //        Country(name: "Laos", code: "+856"),
    //        Country(name: "Latvia", code: "+371"),
    //        Country(name: "Lebanon", code: "+961"),
    //        Country(name: "Lesotho", code: "+266"),
    //        Country(name: "Liberia", code: "+231"),
    //        Country(name: "Libya", code: "+218"),
    //        Country(name: "Liechtenstein", code: "+423"),
    //        Country(name: "Lithuania", code: "+370"),
    //        Country(name: "Luxembourg", code: "+352"),
    //        Country(name: "Macau", code: "+853"),
    //        Country(name: "Macedonia", code: "+389"),
    //        Country(name: "Madagascar", code: "+261"),
    //        Country(name: "Malawi", code: "+265"),
    //        Country(name: "Malaysia", code: "+60"),
    //        Country(name: "Maldives", code: "+960"),
    //        Country(name: "Mali", code: "+223"),
    //        Country(name: "Malta", code: "+356"),
    //        Country(name: "Marshall Islands", code: "+692"),
    //        Country(name: "Mauritania", code: "+222"),
    //        Country(name: "Mauritius", code: "+230"),
    //        Country(name: "Mayotte", code: "+262"),
    //        Country(name: "Mexico", code: "+52"),
    //        Country(name: "Micronesia", code: "+691"),
    //        Country(name: "Moldova", code: "+373"),
    //        Country(name: "Monaco", code: "+377"),
    //        Country(name: "Mongolia", code: "+976"),
    //        Country(name: "Montenegro", code: "+382"),
    //        Country(name: "Montserrat", code: "+1 (664)"),
    //        Country(name: "Morocco", code: "+212"),
    //        Country(name: "Mozambique", code: "+258"),
    //        Country(name: "Myanmar", code: "+95"),
    //        Country(name: "Namibia", code: "+264"),
    //        Country(name: "Nauru", code: "+674"),
    //        Country(name: "Nepal", code: "+977"),
    //        Country(name: "Netherlands", code: "+31"),
    //        Country(name: "Netherlands Antilles", code: "+599"),
    //        Country(name: "New Caledonia", code: "+687"),
    //        Country(name: "New Zealand", code: "+64"),
    //        Country(name: "Nicaragua", code: "+505"),
    //        Country(name: "Niger", code: "+227"),
    //        Country(name: "Nigeria", code: "+234"),
    //        Country(name: "Niue", code: "+683"),
    //        Country(name: "Norfolk Island", code: "+672"),
    //        Country(name: "North Korea", code: "+850"),
    //        Country(name: "Northern Mariana Islands", code: "+1 (670)"),
    //        Country(name: "Norway", code: "+47"),
    //        Country(name: "Oman", code: "+968"),
    //        Country(name: "Pakistan", code: "+92"),
    //        Country(name: "Palau", code: "+680"),
    //        Country(name: "Palestine", code: "+970"),
    //        Country(name: "Panama", code: "+507"),
    //        Country(name: "Papua New Guinea", code: "+675"),
    //        Country(name: "Paraguay", code: "+595"),
    //        Country(name: "Peru", code: "+51"),
    //        Country(name: "Philippines", code: "+63"),
    //        Country(name: "Poland", code: "+48"),
    //        Country(name: "Portugal", code: "+351"),
    //        Country(name: "Puerto Rico", code: "+1 (787)"),
    //        Country(name: "Qatar", code: "+974"),
    //        Country(name: "Republic of the Congo", code: "+242"),
    //        Country(name: "Reunion", code: "+262"),
    //        Country(name: "Romania", code: "+40"),
    //        Country(name: "Russia", code: "+7"),
    //        Country(name: "Rwanda", code: "+250"),
    //        Country(name: "Saint Barthelemy", code: "+590"),
    //        Country(name: "Saint Helena", code: "+290"),
    //        Country(name: "Saint Kitts and Nevis", code: "+1 (869)"),
    //        Country(name: "Saint Lucia", code: "+1 (758)"),
    //        Country(name: "Saint Martin", code: "+590"),
    //        Country(name: "Saint Pierre and Miquelon", code: "+508"),
    //        Country(name: "Saint Vincent and the Grenadines", code: "+1 (784)"),
    //        Country(name: "Samoa", code: "+685"),
    //        Country(name: "San Marino", code: "+378"),
    //        Country(name: "Sao Tome and Principe", code: "+239"),
    //        Country(name: "Saudi Arabia", code: "+966"),
    //        Country(name: "Senegal", code: "+221"),
    //        Country(name: "Serbia", code: "+381"),
    //        Country(name: "Seychelles", code: "+248"),
    //        Country(name: "Sierra Leone", code: "+232"),
    //        Country(name: "Singapore", code: "+65"),
    //        Country(name: "Sint Maarten", code: "+1 (721)"),
    //        Country(name: "Slovakia", code: "+421"),
    //        Country(name: "Slovenia", code: "+386"),
    //        Country(name: "Solomon Islands", code: "+677"),
    //        Country(name: "Somalia", code: "+252"),
    //        Country(name: "South Africa", code: "+27"),
    //        Country(name: "South Korea", code: "+82"),
    //        Country(name: "South Sudan", code: "+211"),
    //        Country(name: "Spain", code: "+34"),
    //        Country(name: "Sri Lanka", code: "+94"),
    //        Country(name: "Sudan", code: "+249"),
    //        Country(name: "Suriname", code: "+597"),
    //        Country(name: "Swaziland", code: "+268"),
    //        Country(name: "Sweden", code: "+46"),
    //        Country(name: "Switzerland", code: "+41"),
    //        Country(name: "Syria", code: "+963"),
    //        Country(name: "Taiwan", code: "+886"),
    //        Country(name: "Tajikistan", code: "+992"),
    //        Country(name: "Tanzania", code: "+255"),
    //        Country(name: "Thailand", code: "+66"),
    //        Country(name: "Togo", code: "+228"),
    //        Country(name: "Tokelau", code: "+690"),
    //        Country(name: "Tonga", code: "+676"),
    //        Country(name: "Trinidad and Tobago", code: "+1 (868)"),
    //        Country(name: "Tunisia", code: "+216"),
    //        Country(name: "Turkey", code: "+90"),
    //        Country(name: "Turkmenistan", code: "+993"),
    //        Country(name: "Turks and Caicos Islands", code: "+1 (649)"),
    //        Country(name: "Tuvalu", code: "+688"),
    //        Country(name: "Uganda", code: "+256"),
    //        Country(name: "Ukraine", code: "+380"),
    //        Country(name: "United Arab Emirates", code: "+971"),
    //        Country(name: "United Kingdom", code: "+44"),
    //        Country(name: "United States", code: "+1"),
    //        Country(name: "Uruguay", code: "+598"),
    //        Country(name: "US Virgin Islands", code: "+1 (340)"),
    //        Country(name: "Uzbekistan", code: "+998"),
    //        Country(name: "Vanuatu", code: "+678"),
    //        Country(name: "Vatican City", code: "+39"),
    //        Country(name: "Venezuela", code: "+58"),
    //        Country(name: "Vietnam", code: "+84"),
    //        Country(name: "Wallis and Futuna", code: "+681"),
    //        Country(name: "Yemen", code: "+967"),
    //        Country(name: "Zambia", code: "+260"),
    //        Country(name: "Zimbabwe", code: "+263")
    //    ]
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.yellow, .red]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Welcome, \(firstName)...")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.bottom, 50)
                
                Text("Enter Phone Number")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                
                VStack {
                    //                    Picker(selection: $country, label: Text("Select Country")) {
                    //                        ForEach(countries, id: \.self) { country in
                    //                            Text(country.name)
                    //                                .tag(country)
                    //                        }
                    //                    }
                    //                    .pickerStyle(MenuPickerStyle())
                    //                    .font(.title3)
                    //                    .fontWeight(.medium)
                    //                    .foregroundColor(.black)
                    //                    .frame(width: 300)
                    //                    .background(.white)
                    //                    .cornerRadius(10)
                    
                    HStack(spacing: 0) {
                        Text("+1")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(.black)
                            .padding(.vertical)
                            .frame(width: 75)
                        
                        TextField("(123) 456-7890", text: $phoneNumber)
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(.black)
                            .padding(.vertical)
                            .frame(width: 225)
                    }
                    .background(.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.black, lineWidth: isPhoneNumberValid ? 0 : 1)
                    )
                    .disabled(isVerificationEnabled)
                    
                    if !isPhoneNumberValid {
                        Text("Please enter a valid phone number!")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                }
                
                if isVerificationEnabled {
                    TextField("Verification Code", text: $verificationCode)
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                        .autocapitalization(.none)
                        .padding()
                        .frame(width: 300)
                        .background(.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.black, lineWidth: display ? 1 : 0)
                        )
                    
                    if display {
                        Text("Invalid verification code. Please try again!")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                }
                
                Button(action: {
                    isPhoneNumberValid = validatePhoneNumber(phoneNumber)
                    if isPhoneNumberValid {
                        if isVerificationEnabled && verificationCode == verificationCodeSent {
                            display = false
                            next = true
                        } else if isVerificationEnabled {
                            display = true
                        } else {
                            isVerificationEnabled = true
                            sendVerificationCode()
                        }
                    }
                }) {
                    Text(isVerificationEnabled ? "Next" : "Verify")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(10)
                        .frame(width: 100)
                        .background(.yellow)
                        .cornerRadius(10)
                }
                .padding()
                .cornerRadius(20)
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: backButton)
                .background(
                    NavigationLink(
                        destination: GetStartedEmailView(fullName: fullName),
                        isActive: $next,
                        label: {
                            EmptyView()
                        }
                    )
                    .hidden()
                )
            }
        }
    }
    
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundColor(.blue)
                Text("Back")
                    .foregroundColor(.blue)
            }
        }
    }
    
    private func validatePhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneRegex = "^[2-9]\\d{9}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phoneNumber)
    }
    
    private func sendVerificationCode() {
        // Generate a random six-digit code
        let randomCode = String(format: "%06d", Int.random(in: 0..<100000))
        
        // TODO: Implement code to send the verification code via SMS to the phoneNumber
        // For demonstration purposes, we'll print the code to the console
        print("Verification Code: \(randomCode)")
        
        // Update the verificationCodeSent with the generated code
        verificationCodeSent = randomCode
    }
    
}

struct GetStartedNumberView_Previews: PreviewProvider {
    static var previews: some View {
        GetStartedNumberView(fullName: "John Smith")
    }
}
