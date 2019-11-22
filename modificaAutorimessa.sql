create or replace procedure modificaAutorimessa(id_sessione int default 0, nome varchar2, ruolo varchar2, idRiga int) AS
    autorimessa Autorimesse%ROWTYPE;
BEGIN
    select * into autorimessa
    from Autorimesse
    where Autorimesse.idAutorimessa = idRiga;
    
    modGUI.apriPagina('HoC | Modifica Autorimessa di ' || autorimessa.indirizzo, id_Sessione, nome, ruolo);
        modGUI.aCapo;
        modGUI.apriDiv;
            modGUI.apriIntestazione(2);
                modGUI.inserisciTesto('Modifica Autorimessa di ' || autorimessa.indirizzo);
            modGUI.chiudiIntestazione(2);
           /* 
            * Il primo parametro di apriForm indica l'azione da compiere una volta cliccato il tasto di invio
            * (classico esempio reindirizzamento ad una procedura che si occupa della query di inserimento degli input immessi)
            */
            modGUI.apriForm('updateAutorimessa');
                modGUI.inserisciInputHidden('id_sessione', id_sessione);
                modGUI.inserisciInputHidden('nome', nome);
                modGUI.inserisciInputHidden('ruolo', ruolo);
                modGUI.inserisciInputHidden('idRiga', idRiga);

                /* esempi di input testo del form*/
                modGUI.inserisciInput(
                    etichetta => 'Indirizzo',
                    nome => 'var_indirizzo',
                    valore => autorimessa.indirizzo,
                    richiesto => true
                );
                modGUI.inserisciInput(
                    tipo => 'number',
                    etichetta => 'Telefono',
                    nome => 'var_telefono',
                    valore => autorimessa.telefono,
                    richiesto => true
                );
                modGUI.inserisciInput(
                    etichetta => 'Coordinate',
                    nome => 'var_coordinate',
                    valore => autorimessa.coordinate,
                    richiesto => true
                );

                modGUI.inserisciBottoneReset('RESET');
                modGUI.inserisciBottoneForm('Submit','Submit','SUBMIT');
            modgui.chiudiForm;
        modGUI.ChiudiDiv;
    modGUI.chiudiPagina;
end modificaAutorimessa;