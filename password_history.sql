SELECT name, password_date
FROM sys.user$, sys.user_history$
WHERE name='&1' and user$.user# = user_history$.user#
order by 2 desc;