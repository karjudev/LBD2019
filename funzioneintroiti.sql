create or replace procedure introitiparziali(id_Sessione varchar2, nome varchar2, ruolo varchar2, idsedecorrente varchar2, periodo varchar2, datainiziale varchar2, datafinale varchar2) is 
totaleabb integer :=0;
totalebigl integer :=0;
indirizzo varchar2 (100);
idsededapassare integer :=0;
--datafinevar varchar2(100);
--datafinets timestamp;

begin

    modGUI.apriPagina('HoC | Introiti', id_Sessione, nome, ruolo);
    modgui.acapo;

    if(datainiziale is not null and datafinale is not null and periodo=1)
        then
            if(idsedecorrente=0) --tutte le sedi con il periodo
                then
                --datafinevar:=datafinale||' 23:59:00';
                --datafinets:=TO_TIMESTAMP(datafinevar, 'yyyy-mm-dd hh24:mi:ss');
                modGUI.apriTabella;
                modGUI.ApriRigaTabella;
                modGUI.intestazioneTabella('Sede');
                modGUI.intestazioneTabella('Introiti Abbonamenti');
                modGUI.intestazioneTabella('Introiti Biglietti');
                modGUI.intestazioneTabella('Dettagli');
                modgui.chiudirigatabella;
                for i in (select * from sedi)
                    loop
                        select sum(abb.costoeffettivo) into totaleabb from box, abbonamenti abb, aree, autorimesse aut where box.idabbonamento=abb.idabbonamento and box.idarea=aree.idarea and aree.idautorimessa=aut.idautorimessa and aut.idsede=i.idsede and ((abb.datainizio<to_date('2019-12-19','yyyy-mm-dd') and abb.datafine>to_date('2019-12-19','yyyy-mm-dd')) or (abb.datainizio>to_date('2019-12-19','yyyy-mm-dd') and abb.datainizio<to_date('2021-12-19','yyyy-mm-dd')));
                        select sum(ingora.costo) into totalebigl from ingressiorari ingora,box, aree, autorimesse aut where ingora.idbox=box.idbox and box.idarea=aree.idarea and aree.idautorimessa=aut.idautorimessa and aut.idsede=i.idsede  and ((ingora.oraentrata<to_timestamp(datainiziale,'yyyy-mm-dd') and ingora.orauscita>to_timestamp(datainiziale,'yyyy-mm-dd')) or (ingora.oraentrata>to_timestamp(datainiziale,'yyyy-mm-dd') and ingora.oraentrata<to_timestamp(datafinale||' 23:59:00','yyyy-mm-dd hh24:mi:ss'))) and ingora.orauscita is not null;
                        select sedi.indirizzo,sedi.idsede into indirizzo,idsededapassare from sedi where sedi.idsede=i.idsede;
                        if(totaleabb is null) then totaleabb:=0; end if;
                        if(totalebigl is null) then totalebigl:=0; end if;
                        modGUI.ApriElementoTabella;
                        modGUI.ElementoTabella(indirizzo);
                        modGUI.ChiudiElementoTabella;
                        modGUI.ApriElementoTabella;
                        modGUI.ElementoTabella(totaleabb);
                        modGUI.ChiudiElementoTabella;
                        modGUI.ApriElementoTabella;
                        modGUI.ElementoTabella(totalebigl);
                        modGUI.ChiudiElementoTabella;
                        modGUI.ApriElementoTabella;
                        modGUI.InserisciLente('visualizzaintroitiparzialiabb', id_sessione, nome, ruolo, idsededapassare||'&periodo='||periodo||'&datainiziale='||datainiziale||'&datafinale='||datafinale);
                        modgui.chiudielementotabella;
                        modgui.chiudirigatabella;

                        end loop;         
                    modgui.chiuditabella;

                else --sede specifica con periodo

                    select sum(abb.costoeffettivo) into totaleabb from box, abbonamenti abb, aree, autorimesse aut where box.idabbonamento=abb.idabbonamento and box.idarea=aree.idarea and aree.idautorimessa=aut.idautorimessa and aut.idsede=idsededapassare and ((abb.datainizio<to_date('2019-12-19','yyyy-mm-dd') and abb.datafine>to_date('2019-12-19','yyyy-mm-dd')) or (abb.datainizio>to_date('2019-12-19','yyyy-mm-dd') and abb.datainizio<to_date('2021-12-19','yyyy-mm-dd')));
                    select sum(ingora.costo) into totalebigl from ingressiorari ingora,box, aree, autorimesse aut where ingora.idbox=box.idbox and box.idarea=aree.idarea and aree.idautorimessa=aut.idautorimessa and aut.idsede=idsedecorrente  and ((ingora.oraentrata<to_timestamp(datainiziale,'yyyy-mm-dd') and ingora.orauscita>to_timestamp(datainiziale,'yyyy-mm-dd')) or (ingora.oraentrata>to_timestamp(datainiziale,'yyyy-mm-dd') and ingora.oraentrata<to_timestamp(datafinale||' 23:59:00','yyyy-mm-dd hh24:mi:ss'))) and ingora.orauscita is not null;
                    select sedi.indirizzo,sedi.idsede into indirizzo,idsededapassare from sedi where sedi.idsede=idsedecorrente;
                    if(totaleabb is null) then totaleabb:=0; end if;
                    if(totalebigl is null) then totalebigl:=0; end if;
                    modGUI.apriTabella;
                    modGUI.ApriRigaTabella;
                    modGUI.intestazioneTabella('Sede');
                    modGUI.intestazioneTabella('Introiti Abbonamenti');
                    modGUI.intestazioneTabella('Introiti Biglietti');
                    modGUI.intestazioneTabella('Dettagli');
                    modgui.chiudirigatabella;
                    modGUI.ApriElementoTabella;
                    modGUI.ElementoTabella(indirizzo);
                    modGUI.ChiudiElementoTabella;
                    modGUI.ApriElementoTabella;
                    modGUI.ElementoTabella(totaleabb);
                    modGUI.ChiudiElementoTabella;
                    modGUI.ApriElementoTabella;
                    modGUI.ElementoTabella(totalebigl);
                    modGUI.ChiudiElementoTabella;
                    modGUI.ApriElementoTabella;
                    modGUI.InserisciLente('visualizzaintroitiparzialiabb', id_sessione, nome, ruolo,idsededapassare||'&periodo='||periodo||'&datainiziale='||datainiziale||'&datafinale='||datafinale);
                    modgui.chiudielementotabella;
                    modgui.chiudirigatabella;        
                    modgui.chiuditabella;
                end if;                
        else
        
        if((datainiziale is null or datafinale is null) and periodo=1) then
            modGUI.apriIntestazione(2);
            modGUI.inserisciTesto('Periodo non valido. Introiti totali');
            modGUI.chiudiIntestazione(2);
        end if;

        if(idsedecorrente=0) 
            then --tutte le sedi senza periodo
                modgui.apritabella;
                modGUI.ApriRigaTabella;
                modGUI.intestazioneTabella('Sede');
                modGUI.intestazioneTabella('Introiti Abbonamenti');
                modGUI.intestazioneTabella('Introiti Biglietti');
                modGUI.intestazioneTabella('Dettagli');
                modgui.chiudirigatabella;
                for i in (select * from sedi)
                    loop
                        select sum(abb.costoeffettivo) into totaleabb from box, abbonamenti abb, aree, autorimesse aut where box.idabbonamento=abb.idabbonamento and box.idarea=aree.idarea and aree.idautorimessa=aut.idautorimessa and aut.idsede=i.idsede;
                        select sum(ingora.costo) into totalebigl from ingressiorari ingora,box, aree, autorimesse aut where ingora.idbox=box.idbox and box.idarea=aree.idarea and aree.idautorimessa=aut.idautorimessa and aut.idsede=i.idsede and ingora.orauscita is not null; 
                        select sedi.indirizzo,sedi.idsede into indirizzo,idsededapassare from sedi where sedi.idsede=i.idsede;
                        if(totaleabb is null) then totaleabb:=0; end if;
                        if(totalebigl is null) then totalebigl:=0; end if;
                        modGUI.ApriElementoTabella;
                        modGUI.ElementoTabella(indirizzo);
                        modGUI.ChiudiElementoTabella;
                        modGUI.ApriElementoTabella;
                        modGUI.ElementoTabella(totaleabb);
                        modGUI.ChiudiElementoTabella;
                        modGUI.ApriElementoTabella;
                        modGUI.ElementoTabella(totalebigl);
                        modGUI.ChiudiElementoTabella;
                        modGUI.ApriElementoTabella;
                        modGUI.InserisciLente('visualizzaintroitiparzialiabb', id_sessione, nome, ruolo, idsededapassare||'&periodo='||periodo||'&datainiziale='||'&datafinale=');
                        modgui.chiudielementotabella;
                        modgui.chiudirigatabella;---------
                    end loop;         
                modgui.chiuditabella;
            else --sede specifica senza periodo
                select sum(abb.costoeffettivo) into totaleabb from box, abbonamenti abb, aree, autorimesse aut where box.idabbonamento=abb.idabbonamento and box.idarea=aree.idarea and aree.idautorimessa=aut.idautorimessa and aut.idsede=idsedecorrente;
                select sum(ingora.costo) into totalebigl from ingressiorari ingora,box, aree, autorimesse aut where ingora.idbox=box.idbox and box.idarea=aree.idarea and aree.idautorimessa=aut.idautorimessa and aut.idsede=idsedecorrente and ingora.orauscita is not null; 
                select sedi.indirizzo,sedi.idsede into indirizzo,idsededapassare from sedi where sedi.idsede=idsedecorrente;
                if(totaleabb is null) then totaleabb:=0; end if;
                if(totalebigl is null) then totalebigl:=0; end if;
                modGUI.apriTabella;
                modGUI.ApriRigaTabella;
                modGUI.intestazioneTabella('Sede');
                modGUI.intestazioneTabella('Introiti Abbonamenti');
                modGUI.intestazioneTabella('Introiti Biglietti');
                modGUI.intestazioneTabella('Dettagli');
                modgui.chiudirigatabella;
                modGUI.ApriElementoTabella; 
                modGUI.ElementoTabella(indirizzo);
                modGUI.ChiudiElementoTabella;
                modGUI.ApriElementoTabella;
                modGUI.ElementoTabella(totaleabb);
                modGUI.ChiudiElementoTabella;
                modGUI.ApriElementoTabella;
                modGUI.ElementoTabella(totalebigl);
                modGUI.ChiudiElementoTabella;
                modGUI.ApriElementoTabella;
                modGUI.InserisciLente('visualizzaintroitiparzialiabb', id_sessione, nome, ruolo, idsededapassare||'&periodo='||periodo||'&datainiziale='||'&datafinale=');
                modgui.chiudielementotabella;
                modgui.chiudirigatabella;        
                modgui.chiuditabella;
            end if;                

        end if;

end introitiparziali;
