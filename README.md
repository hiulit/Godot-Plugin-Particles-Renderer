# Godot Plugin Particles Renderer

![Godot v3.x](https://img.shields.io/badge/Godot-v3.x-478cbf?logo=godot-engine&logoColor=white&style=flat-square) ![release v1.0.0](https://img.shields.io/badge/release-v1.0.0-478cbf?style=flat-square) ![MIT license](https://img.shields.io/badge/license-MIT-478cbf?style=flat-square)

Create sprite sheets from particles ✨.

![Godot Plugin Particles Renderer Banner](/example_images/godot_plugin_particles_renderer_banner.jpg)

## 🎦 Demo

![Godot Plugin Particles Renderer Demo](example_images/godot_plugin_particles_renderer_demo.gif)

## 🛠️ Installation

- Clone the repository or [download](](https://github.com/hiulit/Godot-Plugin-Particles-Renderer/archive/refs/heads/main.zip)) it in a ZIP file.
- Copy the `addons/particles_renderer` folder to the `addons` folders in your project.
- Enable the plugin by going to `Project > Project Settings > Plugins > Particles Renderer > Enable`.

## 🚀 Usage

To open the plugin, go to: `Project > Tools > Particles Renderer`.

Once the plugin window is open, go to: `File > Open` to select a scene.

## ⚙️ Options

### Base sprite size

The size that will used for the particles viewport and as base for scaling.

If `keep proportions` is checked, when changing one value, the other value will be updated with the same value.

### Max frames

The number of frames that will be rendered.

The renderer will remove in-between frames from the total frames to match the number set.

If `contiguous` is checked, the frames will be rendered one after another, without skipping any in-betweens.

If left unset (`0`), all the frames set in [FPS](#fps) will be rendered.

### FPS

The maximum number of frames per second which the particles will be rendered on.

### Time

The seconds the render process will take.

Not relevant if the particles are set to `one_shot`.

### Scale

The scaling factor applied to [Base sprite size](#base-sprite-size).

### Output path

The path where the sprite sheet will be stored.

If no path is set when a file is opened, the path will automatically be the same as the opened file.

### File name

The name of the sprite sheet.

If no name is set when a file is opened, the name will automatically be the same as the opened file.

## 🗒️ Changelog

See [CHANGELOG](/CHANGELOG.md).

## 👤 Author

- hiulit

## 🤝 Contributing

Feel free to:

- [Open an issue](https://github.com/hiulit/Godot-Plugin-Particles-Renderer/issues) if you find a bug.
- [Create a pull request](https://github.com/hiulit/Godot-Plugin-Particles-Renderer/pulls) if you have a new cool feature to add to the project.

## 🙌 Supporting this project

If you find this project helpful, please consider supporting it through any size donations to help make it better.

[![Become a patron](https://img.shields.io/badge/Become_a_patron-ff424d?logo=Patreon&style=for-the-badge&logoColor=white)](https://www.patreon.com/hiulit)

[![Suppor me on Ko-Fi](https://img.shields.io/badge/Support_me_on_Ko--fi-F16061?logo=Ko-fi&style=for-the-badge&logoColor=white)](https://ko-fi.com/F2F7136ND)

[![Buy me a coffee](https://img.shields.io/badge/Buy_me_a_coffee-FFDD00?logo=buy-me-a-coffee&style=for-the-badge&logoColor=black)](https://www.buymeacoffee.com/hiulit)

[![Donate Paypal](https://img.shields.io/badge/PayPal-00457C?logo=PayPal&style=for-the-badge&label=Donate)](https://www.paypal.com/paypalme/hiulit)

If you can't, consider sharing it with the world...

[![Share on Twitter](https://img.shields.io/badge/Share_on_Twitter-1DA1F2?style=for-the-badge&logo=twitter&logoColor=white)](https://twitter.com/intent/tweet?url=https://github.com/hiulit/Godot-Plugin-Particles-Renderer&text=%22Godot+Plugin+Particles+Renderer%22%0D%0ACreate+sprite+sheets+from+particles+%E2%9C%A8.%0A%0ABy%20@hiulit%0A%0A)

... or giving it a [star](https://github.com/hiulit/Godot-Plugin-Particles-Renderer/stargazers).

Thank you very much!

## 📝 Licenses

- Source code: [MIT License](/LICENSE).
