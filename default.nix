{ lib
, fetchzip
, stdenv
, packagekit
, pkgconfig
, intltool
, perl
, perlPackages
, gobject-introspection
, json-glib
, glib-networking
, xmlto
, networkmanager
, libxslt
, gtk-doc
, systemd
, libssh
, krb5
, pam_krb5
, linux-pam
, python
, pythonPackages
, nodejs
, nodePackages
, automake
}:
# I am pretty sure that not all these deps are really needed at compile time but these were taken from an AUR script
# nixpkgs is missing pcp which cockpit complains about at the configure step
# atm this does not compile. without pyscss it complains about libpthread not being present, with it it does not compile either 

stdenv.mkDerivation rec {
  pname = "cockpit";
  version = "226";

  src = fetchzip {
    url =
      "https://github.com/cockpit-project/cockpit/releases/download/${version}/cockpit-${version}.tar.xz";
    sha256 = "0yf80k25gdhsrcgnhyg60acfbn3h86c4jqshwsl40cxmpwns5844";
  };

  #  src = fetchFromGitHub { # autoreconfigure complains about not being in a git repo if the source was not pulled from the tgz archive
  #    owner = "cockpit-project";
  #    repo = "cockpit";
  #    rev = "d03cee1c4fde351b76f751d9122a2ab3370afa55";
  #    sha256 = "1ayidnf4fiq1bxzi66cvw80djg7vnyfhnz60rbcnr9b7dfgs8sc9";
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
