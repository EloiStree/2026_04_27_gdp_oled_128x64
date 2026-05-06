🚧 USABLE BUT UNDER CONSTRUCTION TOOL 🚧

---------------------

# SSD1306 OLED 128×64

> A drag-and-drop SSD1306 OLED 128×64 display for use in your projects.

---

## 🍻📖 Purpose

This asset was created with three main goals in mind:

* Learn GDScript through hands-on, code-focused experimentation
* Integrate a display into an XR IoT simulation game
* Build something practical and reusable

It also turned out to be useful for:

* Creating a debug console in Godot while working in XR
* Building simple projects like a Tamagotchi-style system
* Exporting bitmap drawings for use on a real SSD1306 display

---

## Setup

### Option 1: Clone into an empty project

```bash
git clone https://github.com/EloiStree/2026_04_27_gdp_oled_128x64.git addons/2026_04_27_gdp_oled_128x64
```

### Option 2: Add as a Git submodule

```bash
git submodule add https://github.com/EloiStree/2026_04_27_gdp_oled_128x64.git addons/2026_04_27_gdp_oled_128x64
```

### Option 3: Manual download

Download the latest release here:
[https://github.com/EloiStree/2026_04_27_gdp_oled_128x64/releases](https://github.com/EloiStree/2026_04_27_gdp_oled_128x64/releases)

Older versions may also be available on:

* Asset Library: [https://godotengine.org/asset-library/asset](https://godotengine.org/asset-library/asset)
* Store: [https://store.godotengine.org](https://store.godotengine.org)

---

## License

This project uses a Beerware license:
[https://github.com/EloiStree/2026_04_27_gdp_oled_128x64/edit/main/LICENSE](https://github.com/EloiStree/2026_04_27_gdp_oled_128x64/edit/main/LICENSE)

---

## How to Use

1. Add `Display128x64` to your scene
2. Use the provided facade for simple interaction
3. Enable **Edit Local** and explore the node for advanced features

If you're focused on learning code, these are the main methods:

```gdscript
# Set / get pixel values
func set_value_at_index_1d(index_0_8191: int, is_on: bool)
func get_value_at_index_1d(index_0_8191: int) -> bool
func set_value_with_1d_array(array: Array[bool])
func get_value_as_1d_array_reference() -> Array[bool]
func get_value_as_1d_array_copy() -> Array[bool]

# Apply changes
func draw()

# Modding utilities
func push_code_to_execute(text: String)
func remove_code_to_execute()
```

---

## Documentation

* [https://github.com/EloiStree/2026_03_23_doc_micro_bit_sensor/issues/3](https://github.com/EloiStree/2026_03_23_doc_micro_bit_sensor/issues/3)
* [https://github.com/EloiStree/HelloGodot128x64](https://github.com/EloiStree/HelloGodot128x64)

---

## Related Projects

* Main project:
  [https://github.com/EloiStree/2026_04_27_gdp_oled_128x64](https://github.com/EloiStree/2026_04_27_gdp_oled_128x64)

* Usage examples:
  [https://github.com/EloiStree/2026_04_27_gdp_oled_128x64_sample](https://github.com/EloiStree/2026_04_27_gdp_oled_128x64_sample)

* Learning tutorial:
  [https://github.com/EloiStree/HelloGodot128x64](https://github.com/EloiStree/HelloGodot128x64)

* ESP32 integration (connect virtual display to real hardware):
  [https://github.com/EloiStree/2026_04_27_esp32_oled_128x64_udp_i2c](https://github.com/EloiStree/2026_04_27_esp32_oled_128x64_udp_i2c)
