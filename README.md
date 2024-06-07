# cs_to_ts_interface_converter

A Neovim plugin for converting selected C# class to TypeScript interface, with the ability to import and use as a Lua module.

## Installation and Usage

1. Import the plugin as a Lua module in your Neovim configuration file.
2. Call the function `convert(csharp)` with the selected text as an argument to convert it to a TypeScript interface.

### Sample Configuration using Lazy.nvim

```lua
return {
  {
    "markchristianlacap/cs_to_ts.nvim",
    keys = {
      {
        "<leader>lt",
        function()
          -- Use the plugin
          local converter = require "cs_to_ts"

          -- get text from clipboard
          local clipboard = vim.fn.getreg "+"

          -- Convert the text to TypeScript
          local ts, error = converter.convert(clipboard)

          -- Handle the result
          if ts then
            vim.fn.setreg("+", ts) -- Copy to system clipboard
          else
            print("Error:", error)
          end
        end,
        desc = "Convert C# class from clipboard to TypeScript.",
        mode = { "n" },
      },
      {
        "<leader>lt",
        function()
          -- Use the plugin
          local converter = require "cs_to_ts"

          -- Get the selected text in visual mode
          local selectedText = converter.getSelectedText()
          print("selected:", selectedText)
          -- Convert the selected text to TypeScript
          local ts, error = converter.convert(selectedText)

          -- Handle the result
          if ts then
            vim.fn.setreg("+", ts) -- Copy to system clipboard
          else
            print("Error:", error)
          end
        end,
        desc = "Convert C# class from selected to TypeScript.",
        mode = { "v" },
      },
    },
  },
}
```

## Contributing

Contributions are welcome! If you find any issues or have suggestions for improvements, feel free to open an issue or submit a pull request.

## License

This plugin is licensed under the [MIT License](LICENSE).
