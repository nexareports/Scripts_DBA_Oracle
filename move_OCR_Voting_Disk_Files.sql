OCR Files (move como root e o novo Diskgroup tem de ter compatibility superior a 11.1 -> recomendado 11.2):
ocrconfig 

ocrconfig -showbackup
ocrcheck
ocrconfig -replace ocr +OCR_NORMAL
ocrcheck

ou 
ocrconfig -add +OCR_NORMAL
ocrconfig -delete +OCR



Voting Files (move como oracle):
crsctl query css votedisk
crsctl replace votedisk +OCR_NORMAL
crsctl query css votedisk

alter diskgroup OCR_NORMAL SET ATTRIBUTE 'compatible.asm'='11.2';