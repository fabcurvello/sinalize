//
//  DetalhesSolicitacaoViewController.swift
//  sinalize
//
//  Created by Fabricio Curvello on 30/09/17.
//  Copyright © 2017 Fabricio Curvello. All rights reserved.
//

import UIKit
import SDWebImage // Para facilitar o download da foto do Firebase Storage

class DetalhesSolicitacaoViewController: UIViewController {
    
    
    @IBOutlet weak var lbOrderSolicitacao: UILabel!
    @IBOutlet weak var lbDescricao: UILabel!
    @IBOutlet weak var lbEndereco: UILabel!
    @IBOutlet weak var lbReferencia: UILabel!
    @IBOutlet weak var lbDataSolicitacao: UILabel!
    @IBOutlet weak var imgFotoSolicitacao: UIImageView!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var lbDataAtendimento: UILabel!
    @IBOutlet weak var imgFotoAtendimento: UIImageView!
    @IBOutlet weak var lbNomeTecnicoAtendimento: UILabel!
    
    var solicitacaoClicada = Solicitacao()

    override func viewDidLoad() {
        super.viewDidLoad()

        //Para ocultar a tabBar (barra de rodapé)
        self.tabBarController?.tabBar.isHidden = true
        
        //Atualizar campos com valores da solicitação
        print(self.solicitacaoClicada.idOrderSolicitacao)

        self.lbOrderSolicitacao.text = self.solicitacaoClicada.idOrderSolicitacao
        self.lbEndereco.text = self.solicitacaoClicada.endereco
        self.lbReferencia.text = self.solicitacaoClicada.referencia
        self.lbDescricao.text = self.solicitacaoClicada.descricao
        
        let urlFotoSolicitacao = URL(string: self.solicitacaoClicada.urlFotoSolicitacao)
        self.imgFotoSolicitacao.sd_setImage(with: urlFotoSolicitacao) { (imagem, erro, cache, url) in
            
            if erro == nil {
                print("Foto da Solicitação exibida OK")
            }
        }
        
        self.lbDataSolicitacao.text = "Data da solicitação: \(self.solicitacaoClicada.dataSolicitacao)"
        self.lbStatus.text = "Status: \(self.solicitacaoClicada.status)"
        
        //Se status for Aguardando atendimento então os campos de atendimento devem ser "zerados"
        if self.solicitacaoClicada.status == "Aguardando atendimento" {
            
            self.lbDataAtendimento.text = ""
            self.imgFotoAtendimento.image = nil
            self.lbNomeTecnicoAtendimento.text = "A CET-Rio agradece a sua solicitação"
            
        } else {
            
            self.lbDataAtendimento.text = "Data do atendimento: \(self.solicitacaoClicada.dataAtendimento)"
            
            let urlFotoAtendimento = URL(string: self.solicitacaoClicada.urlFotoAtendimento)
            self.imgFotoAtendimento.sd_setImage(with: urlFotoAtendimento) { (imagem, erro, cache, url) in
                
                if erro == nil {
                    print("Foto do Atendimento exibida OK")
                }
            }
            
            self.lbNomeTecnicoAtendimento.text = "Responsável: \(self.solicitacaoClicada.nomeTecnicoAtendimento)"
        }
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
