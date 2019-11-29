create or replace PROCEDURE resSediSovrappopolate(id_Sessione varchar2, nome varchar2, ruolo varchar2, var_giorno varchar2, var_soglia number) AS

  Sede number:=0;
  NumeroAttuale number:=0;
  NumeroNuovo number:=0;
  indirizzo varchar2(40);
      begin

           modGUI.apriPagina('HoC | Sedi sovrappopolate', id_Sessione, nome, ruolo);

    modGUI.aCapo;
    modGUI.apriIntestazione(3);
    modGUI.inserisciTesto('SEDI SOVRAPPOPOLATE');
    modGUI.aCapo;
    modGUI.inserisciTesto('Giorno: ' || to_date(var_giorno, 'yyyy/mm/dd'));
    modGUI.chiudiIntestazione(3);

    modGUI.apriTabella;
        modGUI.apriRigaTabella;
            modGUI.intestazioneTabella('SEDE');
            modGUI.intestazioneTabella('INGRESSI TOTALI');
        modGUI.chiudiRigaTabella;

      for scorriCursoreAbbonamenti in( with
TotIngressiOrari as (
    select Sedi.idSede, Sedi.Indirizzo, count(IngressiOrari.idIngressoOrario) as NumOrari
    from IngressiOrari
        join Box on Box.idBox = IngressiOrari.idBox
        join Aree on Aree.idArea = Box.idArea
        join Autorimesse on Autorimesse.idAutorimessa = Aree.idAutorimessa
        join Sedi on Sedi.idSede = Autorimesse.idSede
        where IngressiOrari.OraEntrata >= TO_TIMESTAMP(var_giorno, 'yyyy-mm-dd')
        and IngressiOrari.OraUscita <= TO_TIMESTAMP(var_giorno || ' 23:59:00', 'yyyy-mm-dd hh24:mi:ss')
    group by Sedi.idSede, Sedi.Indirizzo
),
TotIngressiAbbonamenti as (
    select Sedi.idSede, Sedi.Indirizzo, count(IngressiAbbonamenti.idIngressoAbbonamento) as NumAbb
    from IngressiAbbonamenti
        join Box on Box.idBox = IngressiAbbonamenti.idBox
        join Aree on Aree.idArea = Box.idArea
        join Autorimesse on Autorimesse.idAutorimessa = Aree.idAutorimessa
        join Sedi on Sedi.idSede = Autorimesse.idSede
        where IngressiAbbonamenti.OraEntrata >= TO_TIMESTAMP(var_giorno, 'yyyy-mm-dd')
        and IngressiAbbonamenti.OraUscita <= TO_TIMESTAMP(var_giorno || ' 23:59:00', 'yyyy-mm-dd hh24:mi:ss')
    group by Sedi.idSede, Sedi.Indirizzo
)
select TotIngressiOrari.idSede as IDSede, TotIngressiOrari.Indirizzo as Indirizzo, coalesce(TotIngressiAbbonamenti.NumAbb, 0) + coalesce(TotIngressiOrari.NumOrari, 0) as TotIngressi
from TotIngressiAbbonamenti
full outer join TotIngressiOrari on TotIngressiAbbonamenti.idSede = TotIngressiOrari.idSede
order by TotIngressiOrari.idSede)


      loop
      Sede:=scorriCursoreAbbonamenti.idsede;
      NumeroAttuale:=scorriCursoreAbbonamenti.TotIngressi;
      indirizzo:=scorriCursoreAbbonamenti.indirizzo;
      if(NumeroAttuale>var_soglia)then
        modGUI.apriRigaTabella;
            modGUI.apriElementoTabella;
                modGUI.elementoTabella(indirizzo);
            modGUI.chiudiElementoTabella;
            modGUI.apriElementoTabella;
                modGUI.elementoTabella(scorriCursoreAbbonamenti.TotIngressi);
            modGUI.chiudiElementoTabella;
        modGUI.chiudiRigaTabella;
      end if;
      end loop;



END resSediSovrappopolate;