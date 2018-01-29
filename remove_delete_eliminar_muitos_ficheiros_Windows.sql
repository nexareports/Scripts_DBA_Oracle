Para eliminar ficheiros em barda num servidor Windows (sim, já perdi muito tempo para tentar eliminar directorias com mais de 100mil ficheiros).

Na directoria correcta:
forfiles /S /D -120 /M *.trc /C "cmd /C Echo del @Path" >olderthan120days.bat

E depois executamos o .bat gerado. ?
