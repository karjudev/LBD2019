create or replace procedure introitiparziali(id_Sessione varchar2, nome varchar2, ruolo varchar2, idsedecorrente varchar2) is 
totaleabb integer :=0;
totalebigl integer :=0;
indirizzo varchar2 (100);
idsededapassare integer :=0;
--datafinevar varchar2(100);
--datafinets timestamp;

begin

    modGUI.apriPagina('HoC | Introiti', id_Sessione, nome, ruolo);
    modgui.acapo;

        if(idsedecorrente=0) 
            then --tutte le sedi senza periodo
                modgui.apritabella;
                modGUI.ApriRigaTabella;
                modGUI.intestazioneTabella('Sede');
                modGUI.intestazioneTabella('Introiti Biglietti');
                modGUI.intestazioneTabella('Dettagli');
                modgui.chiudirigatabella;
                for i in (select * from sedi)
                    loop
                        select sum(ingora.costo) into totalebigl from ingressiorari ingora,box, aree, autorimesse aut where ingora.idbox=box.idbox and box.idarea=aree.idarea and aree.idautorimessa=aut.idautorimessa and aut.idsede=i.idsede and ingora.orauscita is not null; 
                        select sedi.indirizzo,sedi.idsede into indirizzo,idsededapassare from sedi where sedi.idsede=i.idsede;
                        if(totaleabb is null) then totaleabb:=0; end if;
                        if(totalebigl is null) then totalebigl:=0; end if;
                        modGUI.ApriElementoTabella;
                        modGUI.ElementoTabella(indirizzo);
                        modGUI.ChiudiElementoTabella;
                        modGUI.ApriElementoTabella;
                        modGUI.ElementoTabella(totalebigl);
                        modGUI.ChiudiElementoTabella;
                        modGUI.ApriElementoTabella;
                        modGUI.InserisciLente('visualizzaintroitiparzialiabb', id_sessione, nome, ruolo, idsededapassare);
                        modgui.chiudielementotabella;
                        modgui.chiudirigatabella;---------
                    end loop;         
                modgui.chiuditabella;
            else --sede specifica senza periodo
                select sum(ingora.costo) into totalebigl from ingressiorari ingora,box, aree, autorimesse aut where ingora.idbox=box.idbox and box.idarea=aree.idarea and aree.idautorimessa=aut.idautorimessa and aut.idsede=idsedecorrente and ingora.orauscita is not null; 
                select sedi.indirizzo,sedi.idsede into indirizzo,idsededapassare from sedi where sedi.idsede=idsedecorrente;
                if(totaleabb is null) then totaleabb:=0; end if;
                if(totalebigl is null) then totalebigl:=0; end if;
                modGUI.apriTabella;
                modGUI.ApriRigaTabella;
                modGUI.intestazioneTabella('Sede');
                modGUI.intestazioneTabella('Introiti Biglietti');
                modGUI.intestazioneTabella('Dettagli');
                modgui.chiudirigatabella;
                modGUI.ApriElementoTabella; 
                modGUI.ElementoTabella(indirizzo);
                modGUI.ChiudiElementoTabella;
                modGUI.ApriElementoTabella;
                modGUI.ElementoTabella(totalebigl);
                modGUI.ChiudiElementoTabella;
                modGUI.ApriElementoTabella;
                modGUI.InserisciLente('visualizzaintroitiparzialiabb', id_sessione, nome, ruolo, idsededapassare);
                modgui.chiudielementotabella;
                modgui.chiudirigatabella;        
                modgui.chiuditabella;
            end if;                
end introitiparziali;
