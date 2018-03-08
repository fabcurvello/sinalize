//
//  EntrarViewController.swift
//  sinalize
//
//  Created by Fabricio Curvello on 23/09/17.
//  Copyright © 2017 Fabricio Curvello. All rights reserved.
//

import UIKit
import FirebaseAuth

class EntrarViewController: UIViewController {
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfSenha: UITextField!
    
    @IBAction func entrar(_ sender: Any) {
        
        // Recuperar dados digitados pelo usuário
        if let email = self.tfEmail.text {
            if let senha = self.tfSenha.text {
                
                // Autenticar usuário no Firebase
                let autenticacao = Auth.auth()
                autenticacao.signIn(withEmail: email, password: senha, completion: { (usuario, erro) in
                    if erro == nil {
                        if usuario == nil {
                            
                            let alerta = Alerta(titulo: "Erro ao autenticar:", mensagem: "Problema ao realizar a autenticação. Tente novamente!")
                            self.present(alerta.getAlerta(), animated: true, completion: nil)
                            
                        } else {
                            
                            enderecoMapa = "" //zerar o endereco
                            
                            // Redirecionar usuário para a tela principal
                            self.performSegue(withIdentifier: "EntrarSegue", sender: nil)
                            
                        }
                    } else {
                        let alerta = Alerta(titulo: "Dados incorretos:", mensagem: "Verifique os dados digitados e tente novamente!")
                        self.present(alerta.getAlerta(), animated: true, completion: nil)
                    }
                })
                
            }
        }
    }
    
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
