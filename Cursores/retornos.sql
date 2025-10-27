DECLARE
  CURSOR retornos IS
    
    select 
        a.nr_sequencia, 
        a.cd_motivo_glosa,
        b.nr_seq_retorno
    from CONVENIO_RETORNO_GLOSA a
    
    inner join CONVENIO_RETORNO_ITEM b on
        a.nr_seq_ret_item = b.nr_sequencia
    
    where 0 = 0
        and a.ie_acao_glosa is null
        and b.nr_seq_retorno in (65923, 65929, 65931, 65935, 65941, 65942, 65944, 65947, 65950, 65952);

BEGIN
  for retorno in retornos
  loop
    atualiza_motivo_conv_ret_glosa(	retorno.cd_motivo_glosa, null, null, retorno.nr_sequencia, 'GabrielAlves', 'S');
  end loop;
  commit;
END;
/