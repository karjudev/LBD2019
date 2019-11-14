create or replace procedure visualizzaSede(id_sessione int default 0, nome varchar2, ruolo varchar2, id_sede int) is
    -- Parametri della sede corrente
    sede Sedi%ROWTYPE;
    -- Nome del dipendente dirigente
    nome_dirigente Persone.Nome%TYPE;
    cognome_dirigente Persone.Cognome%TYPE;
    begin
        -- Trova la sede
        select * into sede
        from Sedi
        where Sedi.idSede = id_sede;
        -- Trova il nome del dirigente
        select nome, cognome into nome_dirigente, cognome_dirigente
        from Persone
        join Dipendenti on Dipendenti.idPersona = Persone.idPersona
        where Dipendenti.idDipendente = sede.idDipendente;
        -- Crea la pagina e l'intestazione
        modGUI.apriPagina('HoC | ' || sede.indirizzo, id_sessione, nome, ruolo);
            modGUI.aCapo;

            modGUI.apriIntestazione(2);
                modGUI.inserisciTesto(sede.indirizzo);
            modGUI.chiudiIntestazione(2);

            modGUI.ApriTabella;
                modGUI.ApriRigaTabella;
                    modGUI.IntestazioneTabella('ID Sede');
                    modGUI.ApriElementoTabella;
                        modGUI.ElementoTabella(sede.idSede);
                    modGUI.ChiudiElementoTabella;
                modGUI.ChiudiRigaTabella;
                modGUI.ApriRigaTabella;
                    modGUI.IntestazioneTabella('Indirizzo');
                    modGUI.ApriElementoTabella;
                        modGUI.ElementoTabella(sede.indirizzo);
                    modGUI.ChiudiElementoTabella;
                modGUI.ChiudiRigaTabella;
                modGUI.ApriRigaTabella;
                    modGUI.IntestazioneTabella('Telefono');
                    modGUI.ApriElementoTabella;
                        modGUI.ElementoTabella(sede.telefono);
                    modGUI.ChiudiElementoTabella;
                modGUI.ChiudiRigaTabella;
                modGUI.ApriRigaTabella;
                    modGUI.IntestazioneTabella('Coordinate');
                    modGUI.ApriElementoTabella;
                        modGUI.ElementoTabella(sede.coordinate);
                    modGUI.ChiudiElementoTabella;
                modGUI.ChiudiRigaTabella;
                modGUI.ApriRigaTabella;
                    modGUI.IntestazioneTabella('Dirigente');
                    modGUI.ApriElementoTabella;
                        modGUI.ElementoTabella(nome_dirigente || ' ' || cognome_dirigente);
                    modGUI.ChiudiElementoTabella;
                modGUI.ChiudiRigaTabella;
            modGUI.ChiudiTabella;
            
            -- Tabella delle autorimesse collegate
            modGUI.apriIntestazione(3);
                modGUI.inserisciTesto('AUTORIMESSE');
            modGUI.chiudiIntestazione(3);
            
            modGUI.apriTabella;
                modGUI.ApriRigaTabella;
                    modGUI.intestazioneTabella('ID Autorimessa');
                    modGUI.intestazioneTabella('Indirizzo');
                    modGUI.intestazioneTabella('Telefono');
                    modGUI.intestazioneTabella('Coordinate');
                for autorimessa in (select * from Autorimesse where Autorimesse.idSede = sede.idSede)
                loop
                    modGUI.ApriRigaTabella;
                        modGUI.ApriElementoTabella;
                            modGUI.Collegamento(autorimessa.idAutorimessa, Costanti.macchina2 || Costanti.radice || 'visualizzaAutorimessa?id_sessione=' || id_sessione || '&nome=' || nome || '&ruolo=' || ruolo || '&id_autorimessa=' || autorimessa.idAutorimessa);
                        modGUI.ChiudiElementoTabella;
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(autorimessa.indirizzo);
                        modGUI.ChiudiElementoTabella;
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(autorimessa.telefono);
                        modGUI.ChiudiElementoTabella;
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(autorimessa.coordinate);
                        modGUI.ChiudiElementoTabella;
                    modGUI.ChiudiRigaTabella;
                end loop;
            modGUI.chiudiTabella;
        modGUI.ChiudiPagina;
    end visualizzaSede;