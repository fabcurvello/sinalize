//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "dd-MM-yyyy"
let dataSolicitacao = dateFormatter.string(from: Date())



print (dataSolicitacao)

let dic = [ "bb" : "vvvv", "cc": "gggggg" ]
print (dic)

var solicitacaoDados = [ "endereco" : "1",
                         "referencia" : "2",
                         "descricao" : "3",
                         "idFotoSolicitacao" : "4"]

print (solicitacaoDados)

var vetor = [ "A", "K", "Z", "B"]
vetor.sort()
