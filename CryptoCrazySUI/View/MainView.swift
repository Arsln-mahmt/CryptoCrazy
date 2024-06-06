//
//  ContentView.swift
//  CryptoCrazySUI
//
//  Created by Mahmut Arslan on 19.03.2024.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var cryptoListViewModel : CryptoListViewModel
    
    init() {
        self.cryptoListViewModel = CryptoListViewModel()
    }
    
    
    var body: some View {
        
        
        NavigationView {
            
            List(cryptoListViewModel.cryptoList,id:\.id) { crypto in
                
                VStack{
                    Text(crypto.currency)
                        .font(.title3)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(crypto.price)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
            }.toolbar(content: {
                Button(action: {
                    Task.init {
                        //cryptoListViewModel.cryptoList = []
                        await cryptoListViewModel.downloadCryptosConinuation(url: URL(string: "https://raw.githubusercontent.com/atilsamancioglu/K21-JSONDataSet/master/crypto.json")!)
                    }
                    
                }, label: {
                    Text("Refresh")
                })
            })
            
            .navigationTitle(Text("Crypto Crazy"))
        }.task {
            
            await cryptoListViewModel.downloadCryptosConinuation(url: URL(string: "https://raw.githubusercontent.com/atilsamancioglu/K21-JSONDataSet/master/crypto.json")!)
            
            
            //await cryptoListViewModel.downloadCryptosAsync(url: URL(string: "https://raw.githubusercontent.com/atilsamancioglu/K21-JSONDataSet/master/crypto.json")!)
        }
        
        /*
         .onAppear {
         
         
         
         //cryptoListViewModel.downloadCryptos(url: URL(string: "https://raw.githubusercontent.com/atilsamancioglu/K21-JSONDataSet/master/crypto.json")!)
         }
         
         }
         */
    }
    
    #Preview {
        MainView()
    }
}
