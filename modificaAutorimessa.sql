create or replace procedure modificaAutorimessa(id_sessione int default 0, nome varchar2, ruolo varchar2, idRiga int) AS
    autorimessa Autorimesse%ROWTYPE;
    id_dipendente_sede Dipendenti.idDipendente%TYPE;
    id_dipendente_corrente Dipendenti.idDipendente%TYPE;
BEGIN

    -- ID del dipendente corrente
    begin
        select Dipendenti.idDipendente
        into id_dipendente_corrente
        from Dipendenti
            join PersoneL on PersoneL.idPersona = Dipendenti.idPersona
            join Sessioni on Sessioni.idPersona = PersoneL.idPersona
        where Sessioni.idSessione = id_sessione;
    exception
        when NO_DATA_FOUND then
            id_dipendente_corrente := null;
    end;

    -- ID del dipendente responsabile della sede
    begin
        select Sedi.idDipendente
        into id_dipendente_sede
        from Sedi
            join Autorimesse on Autorimesse.idSede = Sedi.idSede
        where Autorimesse.idAutorimessa = autorimessa.idAutorimessa;
    exception
        when NO_DATA_FOUND then
            id_dipendente_sede := null;
    end;

    select * into autorimessa
    from Autorimesse
    where Autorimesse.idAutorimessa = idRiga;

    modGUI.apriPagina('HoC | Modifica Autorimessa di ' || autorimessa.indirizzo, id_Sessione, nome, ruolo);
        modGUI.aCapo;
        modGUI.apriDiv;
            if (ruolo = 'A' or (ruolo = 'R' and (id_dipendente_corrente = id_dipendente_sede))) then
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

                    modGUI.inserisciBottoneReset();
                    modGUI.inserisciBottoneForm();
                modgui.chiudiForm;
            else
                modGUI.esitoOperazione('KO', 'Non sei autorizzato a svolgere questa operazione');
            end if;
        modGUI.ChiudiDiv;
    modGUI.chiudiPagina;
end modificaAutorimessa;