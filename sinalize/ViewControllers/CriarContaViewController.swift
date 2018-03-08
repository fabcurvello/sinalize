//
//  CriarContaViewController.swift
//  sinalize
//
//  Created by Fabricio Curvello on 23/09/17.
//  Copyright © 2017 Fabricio Curvello. All rights reserved.
//

import UIKit
import FirebaseAuth // Para autenticação no Firebase
import FirebaseDatabase // Para salvar dados no Firebase

class CriarContaViewController: UIViewController {
    
    @IBOutlet weak var tfNome: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfSenha: UITextField!
    @IBOutlet weak var tfConfirmarSenha: UITextField!
    
    @IBAction func criarConta(_ sender: Any) {
        
        // A validação de dados no app será apenas comparar se as senhas inseridas são iguais e se o nome do usuário foi preenchido.
        // As demais validações ocorrerão no Firebase
        if let nome = self.tfNome.text {
            if nome == "" {
                
                let alerta = Alerta(titulo: "Erro ao criar usuário:", mensagem: "Necessário inserir o seu nome completo. Tente novamente!")
                self.present(alerta.getAlerta(), animated: true, completion: nil)
                
            } else {
                
                if let email = self.tfEmail.text {
                    if let senha = self.tfSenha.text {
                        if let senhaConfirmacao = self.tfConfirmarSenha.text {
                            
                            // Validar senha
                            if senha == senhaConfirmacao {
                                // print("Senhas iguais, validação ok")
                                
                                // Criar conta no Firebase
                                let autenticacao = Auth.auth()
                                autenticacao.createUser(withEmail: email, password: senha, completion: { (usuario, erro) in
                                    
                                    if erro == nil {
                                        
                                        if usuario == nil {
                                            
                                            let alerta = Alerta(titulo: "Erro ao autenticar:", mensagem: "Problemas ao realizar a autenticação. Tente novamente!")
                                            self.present(alerta.getAlerta(), animated: true, completion: nil)
                                            
                                        } else {
                                            
                                            enderecoMapa = "" //zerar o endereco
                                            
                                            
                                            // Acessar raiz da referência do Database no Firebase
                                            let database = Database.database().reference()
                                            
                                            // Acessar (ou criar) nó chamado usuarios
                                            let usuarios = database.child("usuarios")
                                            
                                            // Criar dicionário de dados com nome e e-mail do usuário
                                            let usuarioDados = ["nome": nome, "email": email]
                                            
                                            // Criar um nó com o id do usuário e salvar nome e e-mail do usuário
                                            usuarios.child( (usuario?.uid)! ).setValue(usuarioDados)
                                            
                                            
                                            // Redirecionar usuário para a tela principal
                                            // Quando o usuário é criado no Firebase ele já fica logado
                                            self.performSegue(withIdentifier: "CriarContaSegue", sender: nil)
                                        }
                                        
                                    } else {
                                        //print("Erro ao cadastrar usuário.")
                                        
                                        let erroFirebase = erro! as NSError
                                        if let codigoErro = erroFirebase.userInfo["error_name"] {
                                            
                                            let erroTexto = codigoErro as! String
                                            var mensagemErro = ""
                                            switch erroTexto {
                                                
                                            case "ERROR_INVALID_EMAIL" :
                                                mensagemErro = "E-mail inválido, digite um e-mail válido!"
                                                break
                                                
                                            case "ERROR_WEAK_PASSWORD" :
                                                mensagemErro = "A senha precisa ter no mínimo 6 caracteres."
                                                break
                                                
                                            case "ERROR_EMAIL_ALREADY_IN_USE" :
                                                mensagemErro = "Este e-mail já foi cadastrado. Crie sua conta utilizando outro e-mail."
                                                break
                                                
                                            default :
                                                mensagemErro = "Dados digitados estão incorretos."
                                            } // fim switch
                                            
                                            let alerta = Alerta(titulo: "Dados inválidos:", mensagem: mensagemErro)
                                            self.present(alerta.getAlerta(), animated: true, completion: nil)
                                            
                                        }
                                    } // Fim validação de erro do Firebase
                                })
                                
                            } else {
                                // print("Senhas diferentes. As senhas precisam ser iguais")
                                let alerta = Alerta(titulo: "Dados inválidos:", mensagem: "As senhas não estão iguais. Digite novamente!")
                                self.present(alerta.getAlerta(), animated: true, completion: nil)
                                
                            } // fim if senha == senhaConfirmacao
                            
                        }
                    }
                }
            }
        }
        
    }// fim criarConta()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // Para exibir a barra de navegação (Navigation Bar / Navigation Item)
    // Uma vez que ela foi ocultada em InicioViewController
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // Para que o teclado recolha ao final clicar fora da Text Field
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
