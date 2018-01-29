prompt Script para alterar password de user no Harvest
conn daa/ptsi1002@eccc1.ptsi
@my_script
exec altera_pwd_harvest('&1','&2','&3');