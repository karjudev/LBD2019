create or replace procedure modificaSede(id_sessione int default 0, nome varchar2, ruolo varchar2, idRiga int) AS
    sede Sedi%ROWTYPE;
BEGIN

    select * into sede
    from Sedi
    where Sedi.idSede = idRiga;
    
    modGUI.apriPagina('HoC | Modifica Sede di ' || sede.indirizzo, id_Sessione, nome, ruolo);
        modGUI.aCapo;
            modGUI.apriDiv;
            -- Se il ruolo dell'utente non è amministratore esce
            if (ruolo <> 'A') then
                modGUI.esitoOperazione('KO', 'Non sei un amministratore');
            else
                modGUI.apriIntestazione(2);
                    modGUI.inserisciTesto('Modifica Sede di ' || sede.indirizzo);
                modGUI.chiudiIntestazione(2);
                /* 
                * Il primo parametro di apriForm indica l'azione da compiere una volta cliccato il tasto di invio
                * (classico esempio reindirizzamento ad una procedura che si occupa della query di inserimento degli input immessi)
                */
                modGUI.apriForm('updateSede');
                    modGUI.inserisciInputHidden('id_sessione', id_sessione);
                    modGUI.inserisciInputHidden('nome', nome);
                    modGUI.inserisciInputHidden('ruolo', ruolo);
                    modGUI.inserisciInputHidden('idRiga', idRiga);

                    /* esempi di input testo del form*/
                    modGUI.inserisciInput(
                        etichetta => 'Indirizzo',
                        nome => 'var_indirizzo',
                        valore => sede.indirizzo,
                        richiesto => true
                    );
                    modGUI.inserisciInput(
                        tipo => 'number',
                        etichetta => 'Telefono',
                        nome => 'var_telefono',
                        valore => sede.telefono,
                        richiesto => true
                    );
                    modGUI.inserisciInput(
                        etichetta => 'Coordinate',
                        nome => 'var_coordinate',
                        valore => sede.coordinate,
                        richiesto => true
                    );
                    modGUI.inserisciBottoneReset('RESET');
                    modGUI.inserisciBottoneForm();
                modgui.chiudiForm;
            end if;
        modGUI.ChiudiDiv;
    modGUI.chiudiPagina;
end modificaSede;