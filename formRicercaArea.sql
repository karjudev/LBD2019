create or replace procedure formRicercaArea(id_Sessione int, nome varchar2, ruolo varchar2) is
  begin
    modGUI.apriPagina('HoC | Ricerca Area', id_Sessione, nome, ruolo);
      modGUI.aCapo;
      modGUI.apriIntestazione(2);
        modGUI.inserisciTesto('RICERCA AREA');
      modGUI.chiudiIntestazione(2);

      modGUI.apriForm('graphicResultRicercaArea');
        modGUI.inserisciInputHidden('id_Sessione', id_Sessione);
        modGUI.inserisciInputHidden('nome', nome);
        modGUI.inserisciInputHidden('ruolo', ruolo);
        modGUI.apriSelect('autorimessa', 'AUTORIMESSA');
            for cur_autorimesse in (select idAutorimessa, indirizzo from Autorimesse)
                loop
                    modGUI.inserisciOpzioneSelect(cur_autorimesse.idAutorimessa, cur_autorimesse.indirizzo);
                end loop;
        modGUI.chiudiSelect;
        modGUI.apriSelect('veicolo', 'VEICOLO', richiesto=>true);
            for cur_veicoli in (
                select Veicoli.idVeicolo, Veicoli.Modello, Veicoli.Produttore , Veicoli.Targa
                from Veicoli, VeicoliClienti, Clienti, Sessioni
                where Sessioni.idSessione = id_Sessione AND
                      Clienti.idPersona = Sessioni.idPersona AND
                      VeicoliClienti.idCliente = Clienti.idCliente AND
                      Veicoli.idVeicolo = VeicoliClienti.idVeicolo

            )
                loop
                    modGUI.inserisciOpzioneSelect(cur_veicoli.idVeicolo, cur_veicoli.Produttore || ' ' || cur_veicoli.Modello || ' - ' || cur_veicoli.Targa);
                end loop;
        modGUI.chiudiSelect;
        modGUI.inserisciBottoneReset;
        modGUI.inserisciBottoneForm(testo=>'RICERCA AREA');
      modGUI.chiudiForm;
    modGUI.chiudiPagina;
  end formRicercaArea;
