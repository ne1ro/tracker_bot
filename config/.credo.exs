%{
  #
  # You can have as many configs as you like in the `configs:` field.
  configs: [
    %{
      #
      # Run any exec using `mix credo -C <name>`. If no exec name is given
      # "default" is used.
      name: "default",
      #
      # These are the files included in the analysis:
      files: %{
        #
        # You can give explicit globs or simply directories.
        # In the latter case `**/*.{ex,exs}` will be used.
        included: ~w(config lib),
        excluded: [~r"/_build/", ~r"/deps/", ~r"/priv/"]
      },
      #
      # If you create your own checks, you must specify the source files for
      # them here, so they can be loaded by Credo before running the analysis.
      requires: [],
      #
      # Credo automatically checks for updates, like e.g. Hex does.
      # You can disable this behaviour below:
      check_for_updates: true,
      #
      # If you want to enforce a style guide and need a more traditional linting
      # experience, you can change `strict` to `true` below:
      strict: true,
      #
      # If you want to use uncolored output by default, you can change `color`
      # to `false` below:
      color: true,
      #
      # You can customize the parameters of any check by adding a second element
      # to the tuple.
      #
      # To disable a check put `false` as second element:
      #
      #     {Credo.Check.Design.DuplicatedCode, false}
      #
      checks: [
        {Credo.Check.Readability.MissingTypespecs, :false},
        {Credo.Check.Readability.ModuleDoc, :false},
        {Credo.Check.Readability.Specs, :false},
        {Credo.Check.Readability.MaxLineLength, priority: :low, max_length: 100}
      ]
    }
  ]
}
