{
  sources ? import ./nix/sources.nix,
}:
let
  pkgs = import sources.nixpkgs {
    overlays = [
      (
        self: super:
        let
          erl = pkgs.beam.packages.erlang_26;
        in
        {
          erlang = erl.erlang;
          elixir = erl.elixir_1_18;
          livebook = self.callPackage (import ./nix/livebook.nix) { };
        }
      )
    ];
    config = {
      allowUnfree = true;
    };
  };
in
{
  inherit pkgs;
  deps =
    [
    ];

  shell = pkgs.mkShell {
    buildInputs = with pkgs; [
      livebook
      elixir
      erlang
    ];

    shellHook = '''';
  };
}
