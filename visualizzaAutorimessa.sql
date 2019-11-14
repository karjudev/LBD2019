create or replace PROCEDURE visualizzaAutorimessa(id_sessione int default 0, nome varchar2, ruolo varchar2, idRiga int) is
    -- Parametri della sede corrente
    autorimessa Autorimesse%ROWTYPE;
    -- Indirizzo della Sede competente
    indirizzo_sede Sedi.indirizzo%TYPE;
    begin
        -- Trova l'autorimessa
        select * into autorimessa
        from Autorimesse
        where Autorimesse.idAutorimessa = idRiga;
        -- Trova il nome del dirigente
        select Sedi.indirizzo into indirizzo_sede
        from Sedi
        where Sedi.idSede = autorimessa.idSede;
        -- Crea la pagina e l'intestazione
        modGUI.apriPagina('HoC | ' || autorimessa.indirizzo, id_sessione, nome, ruolo);
            modGUI.aCapo;

            modGUI.apriIntestazione(2);
                modGUI.inserisciTesto('Autorimessa di ' || autorimessa.indirizzo);
            modGUI.chiudiIntestazione(2);

            modGUI.ApriTabella;
                modGUI.ApriRigaTabella;
                    modGUI.IntestazioneTabella('ID Autorimessa');
                    modGUI.ApriElementoTabella;
                        modGUI.ElementoTabella(autorimessa.idAutorimessa);
                    modGUI.ChiudiElementoTabella;
                modGUI.ChiudiRigaTabella;
                modGUI.ApriRigaTabella;
                    modGUI.IntestazioneTabella('Indirizzo');
                    modGUI.ApriElementoTabella;
                        modGUI.ElementoTabella(autorimessa.indirizzo);
                    modGUI.ChiudiElementoTabella;
                modGUI.ChiudiRigaTabella;
                modGUI.ApriRigaTabella;
                    modGUI.IntestazioneTabella('Telefono');
                    modGUI.ApriElementoTabella;
                        modGUI.ElementoTabella(autorimessa.telefono);
                    modGUI.ChiudiElementoTabella;
                modGUI.ChiudiRigaTabella;
                modGUI.ApriRigaTabella;
                    modGUI.IntestazioneTabella('Coordinate');
                    modGUI.ApriElementoTabella;
                        modGUI.ElementoTabella(autorimessa.coordinate);
                    modGUI.ChiudiElementoTabella;
                modGUI.ChiudiRigaTabella;
                modGUI.ApriRigaTabella;
                    modGUI.IntestazioneTabella('Sede');
                    modGUI.ApriElementoTabella;
                        modGUI.ElementoTabella(indirizzo_sede);
                    modGUI.ChiudiElementoTabella;
                modGUI.ChiudiRigaTabella;
            modGUI.ChiudiTabella;
            
            modGUI.ApriTabella;
                modGUI.ApriRigaTabella;
                    modGUI.ApriElementoTabella;
                        modGUI.InserisciPenna('modificaAutorimessa', id_sessione, nome, ruolo, idRiga);
                    modGUI.ChiudiElementoTabella;
                modGUI.ChiudiRigaTabella;
            modGUI.ChiudiTabella;
            
            -- Tabella delle autorimesse collegate
            modGUI.apriIntestazione(3);
                modGUI.inserisciTesto('Aree');
            modGUI.chiudiIntestazione(3);
            
            modGUI.apriTabella;
                modGUI.ApriRigaTabella;
                    modGUI.intestazioneTabella('ID Area');
                    modGUI.intestazioneTabella('Posti Totali');
                    modGUI.intestazioneTabella('Posti Liberi');
                    modGUI.intestazioneTabella('Stato');
                    modGUI.intestazioneTabella('GAS');
                    modGUI.intestazioneTabella('Dettagli');
                for area in (select * from Aree where Aree.idAutorimessa = autorimessa.idAutorimessa)
                loop
                    modGUI.ApriRigaTabella;
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(area.idArea);
                        modGUI.ChiudiElementoTabella;
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(area.postitotali);
                        modGUI.ChiudiElementoTabella;
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(area.postiliberi);
                        modGUI.ChiudiElementoTabella;
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(area.stato);
                        modGUI.ChiudiElementoTabella;
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(area.gas);
                        modGUI.ChiudiElementoTabella;
                        modGUI.ApriElementoTabella;
                            modGUI.InserisciLente('visualizzaArea', id_sessione, nome, ruolo, area.idArea);
                        modGUI.ChiudiElementoTabella;
                    modGUI.ChiudiRigaTabella;
                end loop;
            modGUI.chiudiTabella;
        modGUI.ChiudiPagina;
    end visualizzaAutorimessa;