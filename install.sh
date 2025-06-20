#!/bin/bash

. /home/oracle/.bash_profile

ARQUIVO="$ORACLE_HOME/apex/apex_rest_config_nocdb.sql"
SENHA_LISTENER="SenhaListener#2024"
SENHA_REST="SenhaRest#2024"

# Ajusta scripts para modo silent
sed -i.bkp '/^accept PASSWD1/d' "$ARQUIVO"
sed -i '/^accept PASSWD2/d' "$ARQUIVO"
sed -i "/@\\^PREFIX.apex_rest_config_core.sql/c\\@^PREFIX.apex_rest_config_core.sql ^PREFIX. $SENHA_LISTENER $SENHA_REST" "$ARQUIVO"
sed -i.bkp '/^accept /d' $ORACLE_HOME/apex/apxchpwd.sql



export ORACLE_PDB_SID=xepdb1


# Instala APEX
cd $ORACLE_HOME/apex/
sqlplus sys/Oracle#21#XE as sysdba <<EOF

-- Mostra PDB
show pdbs

-- Criar Tablespace
create tablespace apex datafile '/opt/oracle/oradata/XE/XEPDB1/apex01.dbf' size 200m autoextend on maxsize 32000m;

-- Instala Apex
@apexins APEX APEX TEMP /i/

-- Altera senha ADMIN
define USERNAME = ADMIN
define EMAIL = admin@example.com
define PASSWORD = Oracle#21#XE

@apxchpwd

-- Configura senha usuarios APEX_LISTENER 
@apex_rest_config_nocdb.sql

exit
EOF

# Instala PT-BR
export NLS_LANG=AMERICAN_AMERICA.AL32UTF8
cd $ORACLE_HOME/apex/builder/pt-br

sqlplus sys/Oracle#21#XE as sysdba <<EOF
@load_pt-br.sql
exit
EOF



