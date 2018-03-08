//
//  Usuario.swift
//  sinalize
//
//  Created by Fabricio Curvello on 29/09/17.
//  Copyright © 2017 Fabricio Curvello. All rights reserved.
//

import Foundation

class Usuario {
    
    var nome: String
    var email: String
    var idUsuario: String
    
    init(nome: String, email: String, idUsuario: String) {
        self.nome = nome
        self.email = email
        self.idUsuario = idUsuario
    }
}
