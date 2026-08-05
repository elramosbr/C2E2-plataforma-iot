DELETE FROM sensores;

INSERT INTO sensores (

    id,

    gateway_id,

    nome,

    ambiente,

    tensao_nominal,

    ativo

)

VALUES

(

    1,

    1,

    'SCT013-001',

    'Banheiro',

    220,

    1

),

(

    2,

    1,

    'SCT013-002',

    'Sala',

    220,

    1

),

(

    3,

    1,

    'SCT013-003',

    'Boiler',

    220,

    1

);