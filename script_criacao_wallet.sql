WALLET_LOCATION =
(SOURCE =
(METHOD = FILE)
(METHOD_DATA = (DIRECTORY = <WALLET_LOCATION>))
)
SQLNET.WALLET_OVERRIDE = TRUE



WALLET_LOCATION =
  (SOURCE =
     (METHOD = FILE)
     (METHOD_DATA = (DIRECTORY = /home/oracle10/wallet/PRD))
  )

SQLNET.WALLET_OVERRIDE = TRUE



mkstore -wrl "/home/oracle10/wallet/CQ" -create
dimensions_2012#CQ

mkstore -wrl "/home/oracle10/wallet/CQ" -createCredential BDOQRHU_BD_RHU BD_RHU quemtemmedocompraumcao
mkstore -wrl "/home/oracle10/wallet/PRD" -createCredential BDOPRHU_BD_RHU BD_RHU quemtemmedocompraumcao

mkstore -wrl "/home/oracle10/wallet/PRD" -create
dimensions_2012#PRD

mkstore -wrl "/home/oracle10/wallet/PRD" -createCredential BDIM10_SYSTEM system system\$dim\%10

mkstore –wrl "/home/oracle10/wallet/PRD" -deleteCredential BDIM10_SYSTEM


mkstore -wrl "/home/oracle10/wallet/<ambiente>" -createCredential <nome_da_entrada_TNSNAMES_criada> <user/schema> <password_do_user>