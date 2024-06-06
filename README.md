# cs_to_ts_interface_converter

A Neovim plugin for converting selected C# class to TypeScript interface, with the ability to import and use as a Lua module.

## Installation
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

          -- Get the selected text in visual mode
          local selectedText = converter.getVisualSelection()

          -- Convert the selected text to TypeScript interface
          local tsInterface, error = converter.convertToTypeScriptInterface(selectedText)

          -- Handle the result
          if not tsInterface then
            print("Error:", error)
          else
            vim.fn.setreg("+", tsInterface) -- Copy to system clipboard
          end
        end,
        desc = "Convert C# class from clipboard to TypeScript Interface.",
      },
    },
  },
}
```

## Usage

### Lua Module Usage

1. Import the plugin as a Lua module in your Neovim configuration file.
2. Call the function `convertToTypeScriptInterface(selectedText)` with the selected text as an argument to convert it to a TypeScript interface.

#### Lua Configuration Example

```lua
-- Use the plugin
local  converter= require('cs_to_ts_interface_converter')

-- Get the selected text in visual mode
local selectedText = converter.getVisualSelection()

-- Convert the selected text to TypeScript interface
local tsInterface, error = converter.convertToTypeScriptInterface(selectedText)

-- Handle the result
if not tsInterface then
    print("Error:", error)
else
    vim.fn.setreg('+', tsInterface) -- Copy to system clipboard
    print("Converted interface copied to clipboard")
end
```

## Contributing

Contributions are welcome! If you find any issues or have suggestions for improvements, feel free to open an issue or submit a pull request.

## License

This plugin is licensed under the [MIT License](LICENSE).
