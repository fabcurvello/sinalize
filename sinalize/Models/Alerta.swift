//
//  Alerta.swift
//  sinalize
//
//  Created by Fabricio Curvello on 28/09/17.
//  Copyright © 2017 Fabricio Curvello. All rights reserved.
//


// Classe para gerar Alerts 
import UIKit

class Alerta {
    
    var titulo: String
    var mensagem: String
    
    init(titulo: String, mensagem: String) {
        self.titulo = titulo
        self.mensagem = mensagem
    }
    
    func getAlerta() -> UIAlertController {
        
        let alerta = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        let acaoOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alerta.addAction( acaoOk )
        return alerta
    }
    
    
}
