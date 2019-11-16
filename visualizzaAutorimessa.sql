create or replace procedure visualizzaAutorimessa(id_sessione int default 0, nome varchar2, ruolo varchar2, idRiga int) is
    -- Parametri dell'autorimessa corrente
    autorimessa Autorimesse%ROWTYPE;
    -- Indirizzo della sede di riferimento
    indirizzo_sede Sedi.Indirizzo%TYPE;
    begin
        -- Trova la sede
        select * into autorimessa
        from Autorimesse
        where Autorimesse.idAutorimessa = idRiga;
        -- Trova l'indirizzo della sede
        select Sedi.Indirizzo into indirizzo_sede
        from Sedi
        where Sedi.idSede = autorimessa.idSede;
        -- Crea la pagina e l'intestazione
        modGUI.apriPagina('HoC | Autorimessa di ' || autorimessa.indirizzo, id_sessione, nome, ruolo);
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
                        modGUI.ElementoTabella(autorimessa.Indirizzo);
                    modGUI.ChiudiElementoTabella;
                modGUI.ChiudiRigaTabella;
                modGUI.ApriRigaTabella;
                    modGUI.IntestazioneTabella('Telefono');
                    modGUI.ApriElementoTabella;
                        modGUI.ElementoTabella(autorimessa.Telefono);
                    modGUI.ChiudiElementoTabella;
                modGUI.ChiudiRigaTabella;
                modGUI.ApriRigaTabella;
                    modGUI.IntestazioneTabella('Coordinate');
                    modGUI.ApriElementoTabella;
                        modGUI.ElementoTabella(autorimessa.Coordinate);
                    modGUI.ChiudiElementoTabella;
                modGUI.ChiudiRigaTabella;
                modGUI.ApriRigaTabella;
                    modGUI.IntestazioneTabella('Sede');
                    modGUI.ApriElementoTabella;
                        modGUI.Collegamento(indirizzo_sede, Costanti.macchina2 || Costanti.radice || 'visualizzaSede?id_sessione=' || id_sessione || '&nome=' || nome || '&ruolo=' || ruolo || '&idRiga=' || autorimessa.idSede);
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
                    modGUI.intestazioneTabella('Larghezza Massima');
                    modGUI.intestazioneTabella('Lunghezza Massima');
                    modGUI.intestazioneTabella('Altezza Massima');
                    modGUI.intestazioneTabella('Peso Massimo');
                    modGUI.intestazioneTabella('Dettaglio');
                for area in (select * from Aree where Aree.idAutorimessa = idRiga)
                loop
                    modGUI.ApriRigaTabella;
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(area.idArea);
                        modGUI.ChiudiElementoTabella;
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(area.LarghezzaMax || ' mm');
                        modGUI.ChiudiElementoTabella;
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(area.LunghezzaMax || ' mm');
                        modGUI.ChiudiElementoTabella;
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(area.AltezzaMax || ' mm');
                        modGUI.ChiudiElementoTabella;
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(area.PesoMax || ' kg');
                        modGUI.ChiudiElementoTabella;
                        modGUI.ApriElementoTabella;
                            modGUI.inserisciLente('visualizzaArea', id_sessione, nome, ruolo, area.idArea);
                        modGUI.ChiudiElementoTabella;
                    modGUI.ChiudiRigaTabella;
                end loop;
            modGUI.chiudiTabella;
        modGUI.ChiudiPagina;
    end visualizzaAutorimessa;