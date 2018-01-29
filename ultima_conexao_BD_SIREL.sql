select username, max(conexao)
from logon_sirel
group by username;