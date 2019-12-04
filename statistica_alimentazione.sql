create or replace procedure statisticaalimentazione(id_sessione varchar2,nome varchar2, ruolo varchar2)is 
maxbox integer :=0;
var_indirizzo varchar2(100);
var_gas varchar2(1);
var_risp varchar2(100);
var_1 varchar2 (100);
var_2 varchar2 (100);

begin
    modGUI.apriPagina('HoC |  Statistica alimentazione', id_Sessione, nome, ruolo);
    modgui.acapo;
    modgui.apriform('#');
    modgui.apriintestazione(2);

select tmp.count_box,tmp.indirizzo,tmp.gas into maxbox,var_indirizzo,var_gas from(
select count(box.idbox) as count_box,ar.indirizzo,aree.gas from box, aree,autorimesse ar where box.idarea=aree.idarea and aree.idautorimessa=ar.idautorimessa and box.occupato='T' group by ar.indirizzo,aree.gas order by count_box desc) tmp
where rownum=1;
    --if(var_gas='T') then var_risp:='a gas'; else var_risp:='a benzina'; end if;
    select DECODE(var_gas, 'T','a gas','a benzina'), DECODE(maxbox, '1','C''è ','Ci sono ') ,DECODE(maxbox, '1',' veicolo ', ' veicoli ') into var_risp, var_1, var_2 from dual;

    modgui.inseriscitesto(var_1|| maxbox|| var_2 || 'con alimentazione '||var_risp || ' nel parcheggio di '||var_indirizzo );
modgui.chiudiintestazione(2);
modgui.chiudiform;
modgui.chiudipagina;
exception
when no_data_found then 
    modgui.inseriscitesto('Non ci sono veicoli attualmente parcheggiati');
    modgui.chiudiintestazione(2);
    modgui.chiudiform;


end statisticaalimentazione;