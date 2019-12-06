create or replace procedure visualizzaintroitiparzialiabb(id_Sessione varchar2, nome varchar2, ruolo varchar2, idriga varchar2) as 
begin 
    modGUI.apriPagina('HoC | Introiti ', id_Sessione, nome, ruolo);

    for i in (select * from autorimesse aut where aut.idsede=idriga)
    loop
    modGUI.apriIntestazione(2);
        modGUI.inserisciTesto('Autorimessa ' || i.indirizzo);
    modGUI.chiudiIntestazione(2);

   
    
    modGUI.apriTabella;

                modGUI.ApriRigaTabella;
                    modGUI.intestazioneTabella('ID Ingresso Orario');
                    modGUI.intestazioneTabella('Costo effettivo');
                    modGUI.intestazioneTabella('Data inizio');
                    modGUI.intestazioneTabella('Data fine');
                    modGUI.ChiudiRigaTabella;

    for n in (select io.* from box, ingressiorari io, aree where box.idbox=io.idbox and box.idarea=aree.idarea and aree.idautorimessa=i.idautorimessa and (io.oraentrata is not null or io.orauscita is not null) and io.costo is not null order by io.idingressoorario)
    --for n in (select io.* from box, ingressiorari io, aree where box.idbox=io.idbox and box.idarea=aree.idarea and aree.idautorimessa=i.idautorimessa and io.oraentrata is not null order by io.idingressoorario)
    loop
                        modGUI.ApriRigaTabella;
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(n.idingressoorario);
                        modGUI.ChiudiElementoTabella;
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(n.costo);
                        modGUI.ChiudiElementoTabella;
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(to_char(n.oraentrata,'dd-MON-yy hh24:mi:ss'));
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(to_char(n.orauscita,'dd-MON-yy hh24:mi:ss'));
                        modGUI.ChiudiElementoTabella;
                        modGUI.ChiudiRigaTabella;           
    end loop;
    modGUI.ChiudiTabella;

    end loop;


    modgui.chiudipagina;
end visualizzaintroitiparzialiabb;
