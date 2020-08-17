{ fetchFromGitHub, lib, fetchzip, stdenv, packagekit, pkgconfig, intltool, perl
, perlPackages, gobject-introspection, json-glib, glib-networking, xmlto
, networkmanager, libxslt, gtk-doc, systemd, libssh, krb5, pam_krb5, linux-pam
, python, pythonPackages, nodejs, nodePackages, automake }:
# I am pretty sure that not all these deps are really needed at compile time but these were taken from an AUR script
# nixpkgs is missing pcp which cockpit complains about at the configure step
# atm this does not compile. without pyscss it complains about libpthread not being present, with it it does not compile either 

stdenv.mkDerivation rec {
  pname = "cockpit";
  version = "225";

  src = fetchzip {
    url =
      "https://github.com/cockpit-project/cockpit/releases/download/${version}/cockpit-${version}.tar.xz";
    sha256 = "1irwnl876ryzfqp6vwnfl2amffy80df50k1z5ih1ar9225p5paf3";
  };

  #  src = fetchFromGitHub { # autoreconfigure complains about not being in a git repo if the source was not pulled from the tgz archive
  #    owner = "catern";
  #    repo = "cockpit";
  #    rev = "e0e747d4ffc24ce90ac218c0f944bbf73f3830d1";
  #    sha256 = "1lqd99waxw2b572hnqjmg9ai6hyjk8kab4ja7im3aw86cd41nvsa";
  #  };

  nativeBuildInputs = [ nodejs automake pkgconfig python ];
  buildInputs = [
    systemd
    gtk-doc
    json-glib
    krb5
    pam_krb5
    linux-pam
    libxslt
    libssh
    intltool
    gobject-introspection
    networkmanager
    xmlto
    #pythonPackages.pyscss
    #pythonPackages.enum-compat
    #nodejs # node and the node packages are only needed for the dev environment, I'm not sure if it will compile without them tho
    nodePackages.npm
    nodePackages.webpack
    perl
    perlPackages.JavaScriptMinifierXS
    perlPackages.FileShareDir
    perlPackages.JSON
  ];

  #  preConfigure = ''
  #    sed -i '/npm prune/,+14d' /source/autogen.sh
  #  '';

  #  configureScript = ''
  #    ./configure
  #  '';

  # again nixpkgs is missing pcp, so I had to disable pcp support
  configureFlags = [
    "--disable-pcp"
    # "--disable-dependecy-tracking" 
  ];

  meta = with stdenv.lib; {
    description = "A sysadmin login session in a web browser";
    homepage = "https://www.cockpit-project.org";
    license = stdenv.lib.licenses.lgpl2;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers;
      [
        thefenriswolf
      ]; # I would love to not be the only maintainer for this package
  };
}
