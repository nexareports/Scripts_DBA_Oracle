mkstore -wrl "/home/oracle10/wallet/TI" -create

mkstore -wrl "/home/oracle10/wallet/PRD" -createCredential BDOPBMFX_AGILE AGILE 123456
mkstore -wrl "/home/oracle10/wallet/CQ" -createCredential BDOQBMFX_AGILE AGILE 123456
mkstore -wrl "/home/oracle10/wallet/TI" -createCredential BDOTBMFX_AGILE AGILE 123456

dimensions_2012#PRD
dimensions_2012#CQ
dimensions_2012#TI
dimensions_2012#DEV



mkstore -wrl "/home/oracle10/wallet/TI" -listCredential

mkstore -wrl "/home/oracle10/wallet/TI" -help


#listar credenciais numa wallet:
mkstore -wrl "/home/oracle10/wallet/<ambiente>" -listCredential

Exemplo:
mkstore -wrl "/home/oracle10/wallet/TI" -listCredential

Output:
List credential (index: connect_string username)
2: BDOTPTSM_SPDITABLES SPDITABLES
1: BDOTBMFX_AGILE AGILE
4: BDOTPTSM_PTSMTABLES PTSMTABLES
3: BDOTPTSM_LOGTABLES LOGTABLES



#Adicionar credencial:
1) Criar entrada TNSNAMES (tipo: <bd>_<user>
Exemplo: BDOTBMFX_AGIL
2) criar credencial:
mkstore -wrl "/home/oracle10/wallet/<ambiente>" -createCredential <entrada_tns_em_1)> <user> <password_do_user>
Exemplo:
mkstore -wrl "/home/oracle10/wallet/TI" -createCredential BDOTPTSM_PCRTABLES PCRTABLES PCRTABLES_0



#Eliminar credencial
mkstore -wrl "/home/oracle10/wallet/<ambiente>" -deleteCredential <entrada_tns_em_1)>
Exemplo:
mktore -wrl "/home/oracle10/wallet/TI" -deleteCredential BDOTBMFX_AGILE
