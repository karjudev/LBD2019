create or replace procedure modificaArea(id_sessione int default 0, nome varchar2, ruolo varchar2, idRiga int) AS
    area Aree%ROWTYPE;
    indirizzo_autorimessa Autorimesse.Indirizzo%TYPE;
    id_responsabile Dipendenti.idDipendente%TYPE;
    id_dipendente Dipendenti.idDipendente%TYPE;
BEGIN

    -- ID del dipendente corrente
    begin
        select Dipendenti.idDipendente
        into id_dipendente
        from Dipendenti
            join PersoneL on PersoneL.idPersona = Dipendenti.idPersona
            join Sessioni on Sessioni.idPersona = PersoneL.idPersona
        where Sessioni.idSessione = id_sessione;
    exception
        when NO_DATA_FOUND then
            id_dipendente := null;
    end;

    -- ID del dipendente responsabile della sede
    begin
        select Sedi.idDipendente
        into id_responsabile
        from Sedi
            join Autorimesse on Autorimesse.idSede = Sedi.idSede
            join Aree on Aree.idAutorimessa = Autorimesse.idAutorimessa
        where Aree.idArea = idRiga;
    exception
        when NO_DATA_FOUND then
            id_responsabile := null;
    end;

    select * into area
    from Aree
    where Aree.idArea = idRiga;

    select Autorimesse.Indirizzo into indirizzo_autorimessa
    from Autorimesse
    where Autorimesse.idAutorimessa = area.idAutorimessa;
    
    modGUI.apriPagina('HoC | Modifica Area ' || area.idArea || ' di ' || indirizzo_autorimessa, id_Sessione, nome, ruolo);
        modGUI.apriDiv;
        if ((ruolo = 'A') or ((ruolo = 'R') and (id_dipendente = id_responsabile))) then
            modGUI.apriIntestazione(2);
                modGUI.inserisciTesto('Modifica Area ' || area.idArea || ' di ' || indirizzo_autorimessa);
            modGUI.chiudiIntestazione(2);
            /* 
            * Il primo parametro di apriForm indica l'azione da compiere una volta cliccato il tasto di invio
            * (classico esempio reindirizzamento ad una procedura che si occupa della query di inserimento degli input immessi)
            */
            modGUI.apriForm('updateArea');
                modGUI.inserisciInputHidden('id_sessione', id_sessione);
                modGUI.inserisciInputHidden('nome', nome);
                modGUI.inserisciInputHidden('ruolo', ruolo);
                modGUI.inserisciInputHidden('idRiga', idRiga);

                /* esempi di input testo del form*/
                modGUI.inserisciInput(
                    tipo => 'number',
                    etichetta => 'Posti Totali',
                    nome => 'var_posti_totali',
                    valore => area.PostiTotali,
                    richiesto => true
                );
                modGUI.inserisciInput(
                    tipo => 'number',
                    etichetta => 'Posti Liberi',
                    nome => 'var_posti_liberi',
                    valore => area.PostiLiberi,
                    richiesto => true
                );
                modGUI.inserisciInput(
                    tipo => 'number',
                    etichetta => 'Stato',
                    nome => 'var_stato',
                    valore => area.Stato,
                    richiesto => true
                );
                modGUI.inserisciInput(
                    tipo => 'number',
                    etichetta => 'Gas',
                    nome => 'var_gas',
                    valore => area.Gas,
                    richiesto => true
                );
                modGUI.inserisciInput(
                    tipo => 'number',
                    etichetta => 'Larghezza Massima',
                    nome => 'var_larghezza_max',
                    valore => area.LarghezzaMax,
                    richiesto => true
                );
                modGUI.inserisciInput(
                    tipo => 'number',
                    etichetta => 'Lunghezza Massima',
                    nome => 'var_lunghezza_max',
                    valore => area.LunghezzaMax,
                    richiesto => true
                );
                modGUI.inserisciInput(
                    tipo => 'number',
                    etichetta => 'Altezza Massima',
                    nome => 'var_altezza_max',
                    valore => area.AltezzaMax,
                    richiesto => true
                );
                modGUI.inserisciInput(
                    tipo => 'number',
                    etichetta => 'Peso Massimo',
                    nome => 'var_peso_max',
                    valore => area.PesoMax,
                    richiesto => true
                );
                modGUI.inserisciInput(
                    tipo => 'number',
                    etichetta => 'Costo Abbonamento',
                    nome => 'var_costo_abbonamento',
                    valore => area.CostoAbbonamento,
                    richiesto => true
                );
                modGUI.inserisciInput(
                    tipo => 'number',
                    etichetta => 'Peso Massimo',
                    nome => 'var_peso_max',
                    valore => area.Stato,
                    richiesto => true
                );

                modGUI.inserisciBottoneReset('RESET');
                modGUI.inserisciBottoneForm();
            modgui.chiudiForm;
        else
            modGUI.esitoOperazione('KO', 'Non sei autorizzato');
        end if;
        modGUI.ChiudiDiv;
    modGUI.chiudiPagina;
end modificaArea;