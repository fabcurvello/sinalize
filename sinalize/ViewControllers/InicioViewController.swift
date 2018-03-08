//
//  InicioViewController.swift
//  sinalize
//
//  Created by Fabricio Curvello on 23/09/17.
//  Copyright © 2017 Fabricio Curvello. All rights reserved.
//

import UIKit
import FirebaseAuth

class InicioViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //Se o usuário já estiver logado no Firebase, transferir direto para a tela principal.
        let autenticacao = Auth.auth()
        autenticacao.addStateDidChangeListener { (autenticacao, usuario) in
            
            if usuario != nil {
                
                enderecoMapa = "" //zerar o endereco
                
                self.performSegue(withIdentifier: "LoginAutomaticoSegue", sender: nil)
            }
        }
        
    }
    
    // Para esconder a barra de navegação (Navigation Bar / Navigation Item)
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
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
