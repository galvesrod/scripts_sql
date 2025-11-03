with procedimentos as (

select 
    pf.nm_pessoa_fisica paciente,
    cp.nr_atendimento,
    cp.nr_interno_conta,
    c.ds_convenio,
    pp.cd_procedimento,
    p.ds_procedimento,
    pp.cd_medico_executor,
    
    case cp.ie_status_acerto
        when 2 then 'Definitivo'
        else 'Provisório'
    end status_conta,
    
    pc.nr_seq_protocolo,
    
    case pc.ie_status_protocolo
        when 2 then 'Definitivo'
        else 'Provisório'
    end status_protocolo,
    
    pp.vl_procedimento,
    pr.nr_repasse_terceiro,
    pr.vl_repasse,
    pr.nr_sequencia seq_repasse
    
from conta_paciente cp

inner join convenio c on
    cp.cd_convenio_parametro = c.cd_convenio

inner join procedimento_paciente pp on
    cp.nr_interno_conta = pp.nr_interno_conta

inner join atendimento_paciente ap on
    cp.nr_atendimento = ap.nr_atendimento
    
inner join pessoa_fisica pf on
    ap.cd_pessoa_fisica = pf.cd_pessoa_fisica 

left join procedimento_repasse pr on
    pp.nr_sequencia = pr.nr_seq_procedimento
    
left join procedimento p on
    pp.ie_origem_proced = p.ie_origem_proced
    and pp.cd_procedimento = p.cd_procedimento

left join protocolo_convenio pc on
    cp.nr_seq_protocolo = pc.nr_seq_protocolo

where 0 = 0
    and c.ie_tipo_convenio = 1
    and trunc(pp.dt_procedimento) >= '01/10/2025'
    and trunc(pp.dt_procedimento) <= '31/10/2025'
    and pp.cd_setor_atendimento = 77
    and pp.cd_procedimento not in ('60000597','99999965','40310418')
    and (pp.cd_medico_executor = 64460 or pp.cd_medico_executor is null)
    and cp.ie_cancelamento is null
    and pr.nr_repasse_terceiro is null
    --and cp.nr_atendimento = 1792137
)

select 
    case 
        when seq_repasse is not null and nr_repasse_terceiro is null then 'Repasse não liberado'
        when cd_medico_executor is null or cd_medico_executor <> 64460 then 'Sem médico'
        when status_protocolo is null or status_protocolo = 'Provisório' then 'Protocolo aberto'
        when status_conta is null or status_conta = 'Provisório' then 'Conta aberta'
        when vl_procedimento <= 0 then 'Valor procedimento zerado'
        
    end motivo,
    paciente,
    ds_convenio,    
    
    nr_atendimento,
    nr_interno_conta,
    cd_procedimento,
    ds_procedimento,
    vl_procedimento,
    nr_repasse_terceiro,
    vl_repasse
    
from procedimentos
order by paciente, motivo