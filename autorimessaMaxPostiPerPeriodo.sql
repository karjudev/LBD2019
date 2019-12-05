create or replace procedure autorimessaMaxPostiPeriodo(id_sessione varchar2, nome varchar2, ruolo varchar2, x_datainiziale varchar2, y_datafinale varchar2) is
idautorimessacorrente integer;
maxboxoccupati integer;
periodononvalido exception;

begin 

if(to_date(x_datainiziale,'yyyy-mm-dd')>to_date(y_datafinale,'yyyy-mm-dd')) then raise periodononvalido; end if;
select ris1,ris2 into idautorimessacorrente, maxboxoccupati from(
 select idau as ris1, sum(tot) as ris2
    from
    (select aree.idautorimessa as idau,count(box.idbox) as tot from box, aree, abbonamenti ab where 
        (box.idarea=aree.idarea and box.idabbonamento=ab.idabbonamento and 
        ((ab.datainizio<to_date(x_datainiziale,'yyyy-mm-dd') and ab.datafine>to_date(x_datainiziale,'yyyy-mm-dd')) or (ab.datainizio>to_date(x_datainiziale,'yyyy-mm-dd') and ab.datainizio<to_date(y_datafinale,'yyyy-mm-dd'))))
    group by aree.idautorimessa

    union 

    select aree.idautorimessa as idau,count(box.idbox) as tot from box, aree, ingressiorari io  where 
        (box.idarea=aree.idarea and io.idbox=box.idbox and
        ((io.oraentrata<to_timestamp(x_datainiziale,'yyyy-mm-dd') and io.orauscita>to_timestamp(x_datainiziale,'yyyy-mm-dd')) or (io.oraentrata>to_timestamp(x_datainiziale,'yyyy-mm-dd') and io.oraentrata<to_timestamp(y_datafinale||' 23:59:00','yyyy-mm-dd hh24:mi:ss')))) 
    group by aree.idautorimessa)

    group by idau
    order by sum(tot) desc)
    where rownum=1;



    visualizzaautorimessa(id_sessione,nome,ruolo,idautorimessacorrente);
    modGUI.chiudiPagina();

    exception
when no_data_found then 
    modGUI.apripagina('HoC | Visualizza Autorimessa ', id_Sessione, nome, ruolo);
    modgui.acapo;
    modgui.apriform('#');
    modGUI.apriIntestazione(2);
    modgui.inseriscitesto('Nessun box riservato è stato trovato nel periodo selezionato');
    modgui.chiudiintestazione(2);
    modgui.chiudiform;
    modGUI.chiudiPagina();

when periodononvalido then
      modGUI.apripagina('HoC | Eccezione ', id_Sessione, nome, ruolo);
    modgui.acapo;
    modgui.apriform('#');
    modGUI.apriIntestazione(2);
    modgui.inseriscitesto('Periodo non valido');
    modgui.chiudiintestazione(2);
    modgui.chiudiform;
    modGUI.chiudiPagina();
end autorimessaMaxPostiPeriodo;