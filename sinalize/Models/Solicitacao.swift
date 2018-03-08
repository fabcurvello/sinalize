//
//  Solicitacao.swift
//  sinalize
//
//  Created by Fabricio Curvello on 29/09/17.
//  Copyright © 2017 Fabricio Curvello. All rights reserved.
//

import Foundation

class Solicitacao {
    
    var endereco: String = ""
    var referencia: String = ""
    var descricao: String = ""
    var urlFotoSolicitacao: String = ""
    var nomeUsuario: String = ""
    var emailUsuario: String = ""
    var idUsuario: String = ""
    var dataSolicitacao: String = ""
    var status: String = ""
    var nomeTecnicoAtendimento: String = ""
    var dataAtendimento: String = ""
    var urlFotoAtendimento: String = ""
    var idSolicitacao: String = "" // É o id String gerado no Firebase
    var idOrderSolicitacao: String = "" // Gerado no app. Usado para ordenar soliciatções na table e para ser transmitido ao usuário como id da sua solicitação
    
//    init( endereco: String, referencia: String, descricao: String, urlFotoSolicitacao: String, nomeUsuario: String, emailUsuario: String, idUsuario: String ) {
//        
//        self.endereco = endereco
//        self.referencia = referencia
//        self.descricao = descricao
//        self.urlFotoSolicitacao = urlFotoSolicitacao
//        self.nomeUsuario = nomeUsuario
//        self.emailUsuario = emailUsuario
//        self.idUsuario = idUsuario
//        
//        //para gerar a data da solicitacao
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
//        let dataSolicitacao = dateFormatter.string(from: Date())
//        
//        self.dataSolicitacao = dataSolicitacao
//        self.status = "Aguardando atendimento"
//        self.nomeTecnicoAtendimento = ""
//        self.dataAtendimento = ""
//        self.urlFotoAtendimento = ""
//        self.idSolicitacao = ""
//        
//    }
    
    
}
