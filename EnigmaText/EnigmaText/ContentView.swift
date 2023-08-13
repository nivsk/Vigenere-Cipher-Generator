import SwiftUI

struct ContentView: View {
    @State private var plaintext = ""
    @State private var key = ContentView.generateRandomKey()
    @State private var ciphertext = ""
    @State private var decryptedText = ""
    @State private var taxRate: Double = 0.11
    
    let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Vigenère Cipher Generator")
                .font(.system(size: 24, weight: .bold, design: .default))
                .foregroundColor(.green)
                .padding(10)
                .background(Color.gray)
                .cornerRadius(10)
            
            VStack {
                TextEditorWithBackground(text: $plaintext, placeholder: "Enter plaintext...")
                    .foregroundColor(.black)
                
                TextEditorWithBackground(text: $key, placeholder: "Generated Key: \(key)")
                    .foregroundColor(.black)
                
                HStack {
                    Button("Generate Random Key", action: generateRandomKey)
                        .buttonStyle(StyledButtonStyle(backgroundColor: .blue))
                    
                    Button("Copy Key", action: copyKey)
                        .buttonStyle(StyledButtonStyle(backgroundColor: .orange))
                }
                
                HStack {
                    Button("Encrypt", action: {
                        ciphertext = vigenereEncrypt(plaintext: plaintext, key: key)
                    })
                    .buttonStyle(StyledButtonStyle(backgroundColor: .green))
                    
                    Button("Decrypt", action: {
                        decryptedText = vigenereDecrypt(ciphertext: ciphertext, key: key)
                    })
                    .buttonStyle(StyledButtonStyle(backgroundColor: .red))
                }
                
                TextEditorWithBackground(text: $ciphertext, placeholder: "Enter the ciphertext...")
                    .foregroundColor(.black)
                
                HStack {
                    Button("Copy Encrypted", action: copyEncrypted)
                        .buttonStyle(StyledButtonStyle(backgroundColor: .purple))
                    
                    Button("Paste Encrypted", action: pasteEncrypted)
                        .buttonStyle(StyledButtonStyle(backgroundColor: .pink))
                }
                
                TextEditorWithBackground(text: $decryptedText, placeholder: "Decrypted Text will appear here")
                    .foregroundColor(.black)
                
                Text("Converted and Calculated: \(convertAndCalculate())")
            }
            .padding()
            .background(Color.gray)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
            
            Spacer()
        }
        .padding()
        .background(Color(UIColor.darkGray))
        .foregroundColor(.white)
    }
    
    func vigenereEncrypt(plaintext: String, key: String) -> String {
        var result = ""
        
        let plaintextChars = Array(plaintext)
        let keyChars = Array(key)
        
        for (i, char) in plaintextChars.enumerated() {
            if let charIndex = alphabet.firstIndex(of: char)?.utf16Offset(in: alphabet),
               let keyIndex = alphabet.firstIndex(of: keyChars[i % keyChars.count])?.utf16Offset(in: alphabet) {
                let encryptedIndex = (charIndex + keyIndex) % alphabet.count
                result.append(alphabet[alphabet.index(alphabet.startIndex, offsetBy: encryptedIndex)])
            } else {
                result.append(char)
            }
        }
        
        return result
    }

    func vigenereDecrypt(ciphertext: String, key: String) -> String {
        var result = ""
        
        let ciphertextChars = Array(ciphertext)
        let keyChars = Array(key)
        
        for (i, char) in ciphertextChars.enumerated() {
            if let charIndex = alphabet.firstIndex(of: char)?.utf16Offset(in: alphabet),
               let keyIndex = alphabet.firstIndex(of: keyChars[i % keyChars.count])?.utf16Offset(in: alphabet) {
                var decryptedIndex = charIndex - keyIndex
                if decryptedIndex < 0 {
                    decryptedIndex += alphabet.count
                }
                result.append(alphabet[alphabet.index(alphabet.startIndex, offsetBy: decryptedIndex)])
            } else {
                result.append(char)
            }
        }
        
        return result
    }

    func convertAndCalculate() -> String {
        if let number = Double(plaintext) {
            let result = number * taxRate
            return String(result)
        } else {
            return "Invalid Input"
        }
    }
    
    func generateRandomKey() {
        key = ContentView.generateRandomKey()
    }
    
    func copyKey() {
        UIPasteboard.general.string = key
    }
    
    func copyEncrypted() {
        UIPasteboard.general.string = ciphertext
    }
    
    func pasteEncrypted() {
        ciphertext = UIPasteboard.general.string ?? ""
    }
    
    static func generateRandomKey(length: Int = 20) -> String {
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
        return String((0..<length).map { _ in characters.randomElement()! })
    }
}

struct TextEditorWithBackground: View {
    @Binding var text: String
    var placeholder: String
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .background(Color.gray)
                .padding(0)
                .border(Color.black)
                .frame(height: 80)
            
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.gray)
                    .opacity(0.8)
                    .padding(EdgeInsets(top: 8, leading: 5, bottom: 0, trailing: 0))
            }
        }
    }
}

struct StyledButtonStyle: ButtonStyle {
    var backgroundColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(backgroundColor)
            .foregroundColor(.white)
            .cornerRadius(5)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

var textEditorColors: [String: Color] = [:]
