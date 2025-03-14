{
  lib,
  beamPackages,
  makeWrapper,
  rebar3,
  elixir,
  erlang,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
}:
beamPackages.mixRelease rec {
  pname = "livebook";
  version = "0.15.4";

  inherit elixir;

  buildInputs = [ erlang ];

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "livebook-dev";
    repo = "livebook";
    rev = "v${version}";
    hash = "sha256-voH9EFSNrRm69UW5RhdKT2U4Q08RfXNPq2oq3iW/HSw=";
  };

  mixFodDeps = beamPackages.fetchMixDeps {
    pname = "mix-deps-${pname}";
    inherit src version;
    hash = "sha256-J65CEKJmG9+KoXEsz1sDPV/OdwnS12KSXTAhamzvzFE=";
  };

  postInstall = ''
    wrapProgram $out/bin/livebook \
      --prefix PATH : ${
        lib.makeBinPath [
          elixir
          erlang
        ]
      } \
      --set MIX_REBAR3 ${rebar3}/bin/rebar3
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      livebook-service = nixosTests.livebook-service;
    };
  };

  meta = {
    license = lib.licenses.asl20;
    homepage = "https://livebook.dev/";
    description = "Automate code & data workflows with interactive Elixir notebooks";
    maintainers = with lib.maintainers; [
      munksgaard
      scvalex
    ];
    platforms = lib.platforms.unix;
  };
}
