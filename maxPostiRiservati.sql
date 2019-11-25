create or replace procedure maxPostiRiservati(
    id_sessione int,
    nome varchar2,
    ruolo varchar2,
    inizio date,
    fine date
) as
id_autorimessa Autorimesse.idAutorimessa%TYPE;
indirizzo Autorimesse.Indirizzo%TYPE;
abbonamenti int;

cursor autorimesse_cursor is
    select Autorimesse.idAutorimessa, Autorimesse.Indirizzo, count(Abbonamenti.idAbbonamento) as num_abbonamenti
    from Autorimesse
        join Aree on Aree.idAutorimessa = Autorimesse.idAutorimessa
        join Box on Box.idArea = Aree.idArea
        join IngressiAbbonamenti on IngressiAbbonamenti.idBox = Box.idBox
        join Abbonamenti on Abbonamenti.idAbbonamento = IngressiAbbonamenti.idAbbonamento
    where
        least(Abbonamenti.DataInizio, inizio) <= greatest(Abbonamenti.DataFine, fine)
    group by Autorimesse.Indirizzo
    order by num_abbonamenti;

begin

    modGUI.apriPagina('HoC | Massimo numero posti riservati', id_sessione, nome, ruolo);
        modGUI.apriIntestazione(2);
            modGUI.inserisciTesto('Massimo numero posti riservati');
        modGUI.chiudiIntestazione(2);
    modGUI.chiudiPagina;

    modGUI.apriTabella;
        modGUI.apriRigaTabella;
            modGUI.intestazioneTabella('ID Autorimessa');
            modGUI.intestazioneTabella('Indirizzo');
            modGUI.intestazioneTabella('Abbonamenti');
            modGUI.intestazioneTabella('Dettagli');
        modGUI.chiudiRigaTabella;
        open autorimesse_cursor;
        loop
            fetch autorimesse_cursor into id_autorimessa, indirizzo, abbonamenti;
            exit when autorimesse_cursor%NOTFOUND;
            modGUI.apriRigaTabella;
                modGUI.apriElementoTabella;
                    modGUI.inserisciTesto(id_autorimessa);
                modGUI.chiudiElementoTabella;
                modGUI.apriElementoTabella;
                    modGUI.inserisciTesto(indirizzo);
                modGUI.chiudiElementoTabella;
                modGUI.apriElementoTabella;
                    modGUI.inserisciTesto(abbonamenti);
                modGUI.chiudiElementoTabella;
                modGUI.apriElementoTabella;
                    modGUI.inserisciLente('visualizzaAutorimessa', id_sessione, nome, ruolo, id_autorimessa);
                modGUI.chiudiElementoTabella;
            modGUI.chiudiRigaTabella;
        end loop;
        close autorimesse_cursor;
    modGUI.chiudiTabella;

end maxPostiRiservati;