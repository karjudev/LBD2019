create or replace procedure visualizzaArea(id_sessione int default 0, nome varchar2, ruolo varchar2, idRiga int) is
    -- Parametri dell'autorimessa corrente
    area Aree%ROWTYPE;
    -- Indirizzo dell'autorimessa di riferimento
    indirizzo_autorimessa Autorimesse.Indirizzo%TYPE;
    -- ID e indirizzo della sede di riferimento
    id_sede Sedi.idSede%TYPE;
    indirizzo_sede Sedi.Indirizzo%TYPE;
    begin
        -- Trova la sede
        select * into area
        from Aree
        where Aree.idArea = idRiga;
        -- Trova ID della sede e indirizzo dell'autorimessa
        select Autorimesse.idSede, Autorimesse.Indirizzo into id_sede, indirizzo_autorimessa
        from Autorimesse
        where Autorimesse.idAutorimessa = area.idAutorimessa;
        -- Trova l'indirizzo dell'autorimessa
        select Sedi.Indirizzo into indirizzo_sede
        from Sedi
        where Sedi.idSede = id_sede;
        -- Crea la pagina e l'intestazione
        modGUI.apriPagina('HoC | Area ' || area.idArea || ' di ' || indirizzo_autorimessa, id_sessione, nome, ruolo);
            modGUI.aCapo;

            modGUI.apriIntestazione(2);
                modGUI.inserisciTesto('Area ' || area.idArea || ' di ' || autorimessa.indirizzo);
            modGUI.chiudiIntestazione(2);

            modGUI.ApriTabella;
                modGUI.ApriRigaTabella;
                    modGUI.IntestazioneTabella('ID Area');
                    modGUI.ApriElementoTabella;
                        modGUI.ElementoTabella(area.idArea);
                    modGUI.ChiudiElementoTabella;
                modGUI.ChiudiRigaTabella;
                modGUI.ApriRigaTabella;
                    modGUI.IntestazioneTabella('Posti Totali');
                    modGUI.ApriElementoTabella;
                        modGUI.ElementoTabella(area.PostiTotali);
                    modGUI.ChiudiElementoTabella;
                modGUI.ChiudiRigaTabella;
                modGUI.ApriRigaTabella;
                    modGUI.IntestazioneTabella('Posti Liberi');
                    modGUI.ApriElementoTabella;
                        modGUI.ElementoTabella(area.PostiLiberi);
                    modGUI.ChiudiElementoTabella;
                modGUI.ChiudiRigaTabella;
                modGUI.ApriRigaTabella;
                    modGUI.IntestazioneTabella('Stato');
                    modGUI.ApriElementoTabella;
                        modGUI.ElementoTabella(area.Stato);
                    modGUI.ChiudiElementoTabella;
                modGUI.ChiudiRigaTabella;
                modGUI.ApriRigaTabella;
                    modGUI.IntestazioneTabella('Gas');
                    modGUI.ApriElementoTabella;
                        modGUI.ElementoTabella(area.Gas);
                    modGUI.ChiudiElementoTabella;
                modGUI.ChiudiRigaTabella;
                modGUI.ApriRigaTabella;
                    modGUI.IntestazioneTabella('Lunghezza Massima');
                    modGUI.ApriElementoTabella;
                        modGUI.ElementoTabella(area.LunghezzaMax);
                    modGUI.ChiudiElementoTabella;
                modGUI.ChiudiRigaTabella;
                modGUI.ApriRigaTabella;
                    modGUI.IntestazioneTabella('Larghezza Massima');
                    modGUI.ApriElementoTabella;
                        modGUI.ElementoTabella(area.LarghezzaMax);
                    modGUI.ChiudiElementoTabella;
                modGUI.ChiudiRigaTabella;
                modGUI.ApriRigaTabella;
                    modGUI.IntestazioneTabella('Altezza Massima');
                    modGUI.ApriElementoTabella;
                        modGUI.ElementoTabella(area.AltezzaMax);
                    modGUI.ChiudiElementoTabella;
                modGUI.ChiudiRigaTabella;
                modGUI.ApriRigaTabella;
                    modGUI.IntestazioneTabella('Peso Massimo');
                    modGUI.ApriElementoTabella;
                        modGUI.ElementoTabella(area.PesoMax);
                    modGUI.ChiudiElementoTabella;
                modGUI.ChiudiRigaTabella;
                modGUI.ApriRigaTabella;
                    modGUI.IntestazioneTabella('Costo Abbonamento');
                    modGUI.ApriElementoTabella;
                        modGUI.ElementoTabella(area.CostoAbbonamento);
                    modGUI.ChiudiElementoTabella;
                modGUI.ChiudiRigaTabella;
                modGUI.ApriRigaTabella;
                    modGUI.IntestazioneTabella('Autorimessa');
                    modGUI.ApriElementoTabella;
                        modGUI.ElementoTabella(indirizzo_autorimessa);
                    modGUI.ChiudiElementoTabella;
                modGUI.ChiudiRigaTabella;
            modGUI.ChiudiTabella;

            modGUI.ApriTabella;
                modGUI.ApriRigaTabella;
                    modGUI.ApriElementoTabella;
                        modGUI.InserisciPenna('modificaArea', id_sessione, nome, ruolo, idRiga);
                    modGUI.ChiudiElementoTabella;
                modGUI.ChiudiRigaTabella;
            modGUI.ChiudiTabella;

            -- Tabella delle autorimesse collegate
            modGUI.apriIntestazione(3);
                modGUI.inserisciTesto('Aree');
            modGUI.chiudiIntestazione(3);

            modGUI.apriTabella;
                modGUI.ApriRigaTabella;
                    modGUI.intestazioneTabella('ID Box');
                    modGUI.intestazioneTabella('Numero');
                    modGUI.intestazioneTabella('Piano');
                    modGUI.intestazioneTabella('Colonna');
                    modGUI.intestazioneTabella('Dettaglio');
                for box in (select * from Box where Box.idArea = idRiga)
                loop
                    modGUI.ApriRigaTabella;
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(box.idBox);
                        modGUI.ChiudiElementoTabella;
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(box.Numero);
                        modGUI.ChiudiElementoTabella;
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(box.Piano);
                        modGUI.ChiudiElementoTabella;
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(box.NumeroColonna);
                        modGUI.ChiudiElementoTabella;
                        modGUI.ApriElementoTabella;
                            modGUI.inserisciLente('visualizzaBox', id_sessione, nome, ruolo, box.idBox);
                        modGUI.ChiudiElementoTabella;
                    modGUI.ChiudiRigaTabella;
                end loop;
            modGUI.chiudiTabella;
        modGUI.ChiudiPagina;
    end visualizzaArea;