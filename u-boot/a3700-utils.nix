{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  name = "a3700-utils-espressobin";

  phases = [ "unpackPhase" "patchPhase" "installPhase" ];

  src = fetchFromGitHub {
    owner = "MarvellEmbeddedProcessors";
    repo = "A3700-utils-marvell";
    rev = "34ce2160a1521dda9c7c68e06fcde83242dee94a";
    sha256 = "1x026rxknrnzlkaa79a13l26dl5rj1d6aa9dij13ir7pqpznfws6";
  };

  # Patch doesn't seem to create new files, so placeholders are added here first.
  prePatch = ''
    chmod 755 $src/*

    # 0001-Added-tim-img-files-to-build-the-secondary-image.patch
    mkdir -p $src/tim/untrusted/secondary
    touch $src/tim/untrusted/secondary/img-1.txt \
      $src/tim/untrusted/secondary/img-2.txt \
      $src/tim/untrusted/secondary/readme \
      $src/tim/untrusted/secondary/tim.txt

    # 0006-ddr-update-ddr-topology-for-ddr3-ddr4.patch
    touch $src/ddr/tim_ddr/DDR_TOPOLOGY_5.txt \
      $src/ddr/tim_ddr/DDR_TOPOLOGY_6.txt \
      $src/ddr/tim_ddr/DDR_TOPOLOGY_7.txt \
      $src/ddr/tim_ddr/DDR_TOPOLOGY_8.txt \
      $src/ddr/tim_ddr/ddr4-1cs-1g.txt \
      $src/ddr/tim_ddr/ddr4-2cs-2g.txt \
      $src/ddr/tim_ddr/ddr4-800-1cs-512m-issi.txt \
      $src/ddr/tim_ddr/ddr4-800-2cs-1g-issi.txt
  '';

  patches = [
    ./a3700-utils-patches/0001-Added-tim-img-files-to-build-the-secondary-image.patch
    ./a3700-utils-patches/0002-buildtim-add-argument-for-build-primary-or-secondary.patch
    ./a3700-utils-patches/0003-git-add-clocks_ddr.txt-to-git-ignore-list.patch
    ./a3700-utils-patches/0004-parser-add-preset_ddr_conf-field-for-using-preset-dd.patch
    ./a3700-utils-patches/0005-add-.d-files-to-gitignore.patch
    ./a3700-utils-patches/0006-ddr-update-ddr-topology-for-ddr3-ddr4.patch
  ];

  # We just want the contents of the repo.
  installPhase = ''
    mkdir -p $out
    cp -r $src/* $out
  '';

  meta = with stdenv.lib; {
    maintainers = [ maintainers.mirrexagon ];
    # ?
    license = licenses.unfreeRedistributableFirmware;
  };
}