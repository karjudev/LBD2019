create or replace procedure introiti(id_Sessione varchar2, nome varchar2, ruolo varchar2) is 

begin
    modGUI.apriPagina('HoC | Visualizza Introiti', id_Sessione, nome, ruolo);

    modgui.acapo;

modgui.apriForm('introitiparziali');
        modgui.apriparagrafo('rela');
        modgui.inseriscitesto('VISUALIZZA INTROITI ');
        modgui.chiudiparagrafo;
        modgui.inserisciinputhidden('id_Sessione',id_Sessione);
        modgui.inserisciinputhidden('nome',nome);
        modgui.inserisciinputhidden('ruolo',ruolo);

                modGUI.apriSelect('idSedeCorrente', 'Seleziona Sede: ', false, 'defSelect');
        modGUI.inserisciOpzioneSelect('0','Tutte le Sedi',false);

        for sede in (select * from sedi)
        loop
        modGUI.inserisciOpzioneSelect(sede.idsede,sede.indirizzo,false);
        end loop;

        modGUI.chiudiSelect;
                    modgui.inserisciradiobutton('Ricerca totale','periodo','0',true);
                    modgui.inserisciradiobutton('Ricerca per periodo','periodo','1',false);

        modGUI.inserisciinput('Data inizio', 'date','datainiziale',false,'','defInput');


        modGUI.inserisciinput('Data fine', 'date','datafinale',false,'','defInput');


        modGUI.inserisciBottoneReset('RESET');
        modGUI.inserisciBottoneForm('Submit','defFormButton');

        modgui.chiudiForm;

        modGUI.chiudiPagina;


null;
end introiti;
