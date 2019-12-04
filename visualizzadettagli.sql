create or replace procedure visualizzaintroitiparzialiabb(id_Sessione varchar2, nome varchar2, ruolo varchar2, idriga varchar2, periodo varchar2, datainiziale varchar2 default null, datafinale varchar2 default null) as 
    x_datainiziale varchar2(100) :=NVL(datainiziale, '1900-01-01');
    y_datafinale varchar2(100) := NVL(datafinale, to_char(sysdate+interval '10' year,'yyyy-mm-dd'));
begin 
    modGUI.apriPagina('HoC | Introiti ', id_Sessione, nome, ruolo);

    for i in (select * from autorimesse aut where aut.idsede=idriga)
    loop
    modGUI.apriIntestazione(2);
        modGUI.inserisciTesto('Autorimessa ' || i.indirizzo);
    modGUI.chiudiIntestazione(2);

    modGUI.apriTabella;

                modGUI.ApriRigaTabella;
                    modGUI.intestazioneTabella('ID Abbonamento');
                    modGUI.intestazioneTabella('Costo effettivo');
                    modGUI.intestazioneTabella('Data inizio');
                    modGUI.intestazioneTabella('Data fine');
                    modGUI.ChiudiRigaTabella;
    
    for n in (select abb.* from box, abbonamenti abb, aree where box.idabbonamento=abb.idabbonamento and box.idarea=aree.idarea and aree.idautorimessa=i.idautorimessa and ((abb.datainizio<to_date(x_datainiziale,'yyyy-mm-dd') and abb.datafine>to_date(x_datainiziale,'yyyy-mm-dd')) or (abb.datainizio>to_date(x_datainiziale,'yyyy-mm-dd') and abb.datainizio<to_date(y_datafinale,'yyyy-mm-dd'))) order by abb.idabbonamento)
    --for n in (select abb.* from box, abbonamenti abb, aree where box.idabbonamento=abb.idabbonamento and box.idarea=aree.idarea and aree.idautorimessa=i.idautorimessa order by abb.idabbonamento)
    loop
                        modGUI.ApriRigaTabella;
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(n.idabbonamento);
                        modGUI.ChiudiElementoTabella;
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(n.costoeffettivo);
                        modGUI.ChiudiElementoTabella;
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(n.datainizio);
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(n.datafine);
                        modGUI.ChiudiElementoTabella;
                        modGUI.ChiudiRigaTabella;           
    end loop;
    modGUI.ChiudiTabella;
    
    modGUI.apriTabella;

                modGUI.ApriRigaTabella;
                    modGUI.intestazioneTabella('ID Ingresso Orario');
                    modGUI.intestazioneTabella('Costo effettivo');
                    modGUI.intestazioneTabella('Data inizio');
                    modGUI.intestazioneTabella('Data fine');
                    modGUI.ChiudiRigaTabella;

    for n in (select io.* from box, ingressiorari io, aree where box.idbox=io.idbox and box.idarea=aree.idarea and aree.idautorimessa=i.idautorimessa and ((io.oraentrata<to_timestamp(x_datainiziale,'yyyy-mm-dd') and io.orauscita>to_timestamp(x_datainiziale,'yyyy-mm-dd')) or (io.oraentrata>to_timestamp(x_datainiziale,'yyyy-mm-dd') and io.oraentrata<to_timestamp(y_datafinale||' 23:59:00','yyyy-mm-dd hh24:mi:ss'))) order by io.idingressoorario)
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
