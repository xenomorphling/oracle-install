#!/usr/bin/env bash

# Download software
# Install packages:
sudo apt update
sudo apt install libc6-i386
sudo apt install gcc-multilib g++-multilib libc6-dev-i386 libstdc++6:i386
sudo apt install alien autoconf automake autotools-dev elfutils rpm rpm-common
sudo apt install build-essential debhelper expat gawk gsfonts-x11 html2text sysstat
sudo apt install unixodbc unixodbc-dev doxygen ksh openssh-server pax perl-doc rlwrap
sudo apt install lsb lsb-core zlibc
sudo apt install lib32z1-dev lib32ncurses5 libaio1 libaio-dev
sudo apt install libelf-dev libodbcinstq4-1 libpth-dev libpthread-stubs0-dev libpthread-workqueue0 libpthread-workqueue-dev
sudo apt-get install libtiff5-dev libzthread-dev libqt4-opengl:i386 libodbcinstq4-1:i386 libglu1-mesa:i386
sudo apt-get install -s cabextract
sudo add-apt-repository ppa:nilarimogard/webupd8
sudo apt update
sudo apt install wimtools libwim-dev
sudo apt install -s libbz2-dev:i386

# Create soft links:
sudo ln -s /usr/bin/basename /bin/basename
sudo ln -s bin/bash /usr/bin/bash
sudo ln -sf /bin/bash /bin/sh
sudo ln -s /usr/bin/rpm /bin/rpm
sudo ln -s /usr/bin/awk /bin/awk
sudo ln -s /usr/lib/x86_64-linux-gnu /usr/lib64
sudo ln -s /usr/lib/x86_64-linux-gnu/libstdc++.so.6 /lib64/libstdc++.so.6
sudo ln -s /lib/x86_64-linux-gnu/libgcc_s.so.1 /lib64/libgcc_s.so.1
sudo ln -s /usr/lib/i386-linux-gnu/libpthread_nonshared.a /usr/lib/libpthread_nonshared.a
sudo ln -s /lib/lsb/init-functions /etc/init.d/functions

# And some more for programs:
if [ -z "$BASH_VERSION" -o -n "$ORALD_USE_GCC" ] ; then
  exec gcc "$@"
  exit 1
fi

# Change the link options in bin/orald:
# add the -no-pie option to gcc in here:

if [ -z "$BASH_VERSION" -o -n "$ORALD_USE_GCC" ] ; then
  exec gcc -no-pie "$@"
  exit 1
fi


# Now start the installer and run it WITHOUT creating a database.

# After a while you will get link errors. At that time edit then execute the following script:

# Change the path below to point to your installation
export $ORACLE_HOME=/opt/oracle/12cr2
 
sudo ln -s $ORACLE_HOME/lib/libclntshcore.so.12.1 /usr/lib
sudo ln -s $ORACLE_HOME/lib/libclntsh.so.12.1 /usr/lib
 
cp $ORACLE_HOME/rdbms/lib/ins_rdbms.mk $ORACLE_HOME/rdbms/lib/ins_rdbms.bkp
cp $ORACLE_HOME/rdbms/lib/env_rdbms.mk $ORACLE_HOME/rdbms/lib/env_rdbms.bkp
 
sed -i 's/\$(ORAPWD_LINKLINE)/\$(ORAPWD_LINKLINE) -lnnz12/' $ORACLE_HOME/rdbms/lib/ins_rdbms.mk
sed -i 's/\$(HSOTS_LINKLINE)/\$(HSOTS_LINKLINE) -lagtsh/' $ORACLE_HOME/rdbms/lib/ins_rdbms.mk
sed -i 's/\$(EXTPROC_LINKLINE)/\$(EXTPROC_LINKLINE) -lagtsh/' $ORACLE_HOME/rdbms/lib/ins_rdbms.mk
sed -i 's/\$(OPT) \$(HSOTSMAI)/\$(OPT) -Wl,--no-as-needed \$(HSOTSMAI)/' $ORACLE_HOME/rdbms/lib/env_rdbms.mk
sed -i 's/\$(OPT) \$(HSDEPMAI)/\$(OPT) -Wl,--no-as-needed \$(HSDEPMAI)/' $ORACLE_HOME/rdbms/lib/env_rdbms.mk
sed -i 's/\$(OPT) \$(EXTPMAI)/\$(OPT) -Wl,--no-as-needed \$(EXTPMAI)/' $ORACLE_HOME/rdbms/lib/env_rdbms.mk
sed -i 's/^\(TNSLSNR_LINKLINE.*\$(TNSLSNR_OFILES)\) \(\$(LINKTTLIBS)\)/\1 -Wl,--no-as-needed \2/g' $ORACLE_HOME/network/lib/env_network.mk
sed -i 's/\$(SPOBJS) \$(LLIBSERVER)/\$(SPOBJS) -Wl,--no-as-needed \$(LLIBSERVER)/' $ORACLE_HOME/rdbms/lib/env_rdbms.mk
sed -i 's/\$(S0MAIN) \$(SSKFEDED)/\$(S0MAIN) -Wl,--no-as-needed \$(SSKFEDED)/' $ORACLE_HOME/rdbms/lib/env_rdbms.mk
sed -i 's/\$(S0MAIN) \$(SSKFODED)/\$(S0MAIN) -Wl,--no-as-needed \$(SSKFODED)/' $ORACLE_HOME/rdbms/lib/env_rdbms.mk
sed -i 's/\$(S0MAIN) \$(SSKFNDGED)/\$(S0MAIN) -Wl,--no-as-needed \$(SSKFNDGED)/' $ORACLE_HOME/rdbms/lib/env_rdbms.mk
sed -i 's/\$(S0MAIN) \$(SSKFMUED)/\$(S0MAIN) -Wl,--no-as-needed \$(SSKFMUED)/' $ORACLE_HOME/rdbms/lib/env_rdbms.mk
sed -i 's/^\(ORACLE_LINKLINE.*\$(ORACLE_LINKER)\) \($(PL_FLAGS)\)/\1 -Wl,--no-as-needed \2/g' $ORACLE_HOME/rdbms/lib/env_rdbms.mk
sed -i 's/\$LD \$LD_RUNTIME/$LD -Wl,--no-as-needed \$LD_RUNTIME/' $ORACLE_HOME/bin/genorasdksh
sed -i 's/\$(GETCRSHOME_OBJ1) \$(OCRLIBS_DEFAULT)/\$(GETCRSHOME_OBJ1) -Wl,--no-as-needed \$(OCRLIBS_DEFAULT)/' $ORACLE_HOME/srvm/lib/env_srvm.mk
 
sed -i 's/LDDISABLENEWDTAGS=-Wl,--disable-new-dtags/LDDISABLENEWDTAGS=-Wl,--no-as-needed,--disable-new-dtags/' $ORACLE_HOME/rdbms/lib/env_rdbms.mk
sed -i 's/LDDISABLENEWDTAGS=-Wl,--disable-new-dtags/LDDISABLENEWDTAGS=-Wl,--no-as-needed,--disable-new-dtags/' $ORACLE_HOME/crs/lib/env_has.mk;
sed -i 's/LDDISABLENEWDTAGS=-Wl,--disable-new-dtags/LDDISABLENEWDTAGS=-Wl,--no-as-needed,--disable-new-dtags/' $ORACLE_HOME/odbc/lib/env_odbc.mk;
sed -i 's/LDDISABLENEWDTAGS=-Wl,--disable-new-dtags/LDDISABLENEWDTAGS=-Wl,--no-as-needed,--disable-new-dtags/' $ORACLE_HOME/precomp/lib/env_precomp.mk;
sed -i 's/LDDISABLENEWDTAGS=-Wl,--disable-new-dtags/LDDISABLENEWDTAGS=-Wl,--no-as-needed,--disable-new-dtags/' $ORACLE_HOME/srvm/lib/env_srvm.mk;
sed -i 's/LDDISABLENEWDTAGS=-Wl,--disable-new-dtags/LDDISABLENEWDTAGS=-Wl,--no-as-needed,--disable-new-dtags/' $ORACLE_HOME/network/lib/env_network.mk;
sed -i 's/LDDISABLENEWDTAGS=-Wl,--disable-new-dtags/LDDISABLENEWDTAGS=-Wl,--no-as-needed,--disable-new-dtags/' $ORACLE_HOME/ldap/lib/env_ldap.mk;
sed -i 's/LDDISABLENEWDTAGS=-Wl,--disable-new-dtags/LDDISABLENEWDTAGS=-Wl,--no-as-needed,--disable-new-dtags/' $ORACLE_HOME/ord/im/lib/env_ordim.mk;
sed -i 's/LDDISABLENEWDTAGS=-Wl,--disable-new-dtags/LDDISABLENEWDTAGS=-Wl,--no-as-needed,--disable-new-dtags/' $ORACLE_HOME/plsql/lib/env_plsql.mk;
sed -i 's/LDDISABLENEWDTAGS=-Wl,--disable-new-dtags/LDDISABLENEWDTAGS=-Wl,--no-as-needed,--disable-new-dtags/' $ORACLE_HOME/ctx/lib/env_ctx.mk;
sed -i 's/LDDISABLENEWDTAGS=-Wl,--disable-new-dtags/LDDISABLENEWDTAGS=-Wl,--no-as-needed,--disable-new-dtags/' $ORACLE_HOME/sqlplus/lib/env_sqlplus.mk;

# Press the "retry" button on the installer which should at least let the installation complete.
# But the resulting Oracle installation will not be able to start an instance: startup nomount will hang with a deadlocked Oracle BEQ process which shows a stack trace similar to this:

