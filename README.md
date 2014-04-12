install-python
==============

install-python.bash is a script that may install python and a huge number
of usefull modules


Usage
=====

Launching the script
--------------------

```
./install_python
```

By default everything is installed in /usr/local/python/2.7.3. Modify the
CONF_PREFIX variable in order to change this. Be sure that you have the rights
to write to that destination.

Following the installation process is possible by looking at the file
install-python.log in the TMPDIR location with the following command for
instance :

```
tail -f install-python.log
```

Disclaimer !
------------

Beware the script is not finalized. It will not terminate correctly. Everythings
looks good until VTK installation. Then VTK and wxpython compilation is known to
fail. Consider this script as an alpha version !

In case of bugs
---------------

Please, if you are using this script (even for testing purposes) tell me about
bugs or problems you encounter.


Requirements
============

Before launching the script, make sure that you have the following installed :

* bash
* GNU coreutils (I do not know if busybox works)
* make and gmake
* gcc
* wget
* tar
* blas-devel and lapack-devel to compile scipy for instance
* graphviz
* gstreamer-plugins-base-devel
