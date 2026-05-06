
# SSD1306 OLED 128×64

> A drag-and-drop SSD1306 OLED 128×64 display for use in your projects.

---

## 🍻📖 Purpose

This asset was created with three main goals:

* Learn GDScript through hands-on, code-focused experimentation
* Add a display to an XR IoT simulation game
* Build a practical and reusable tool

It also turned out to be useful for:

* Running a debug console in Godot while in XR
* Creating small projects like a Tamagotchi-style system
* Exporting bitmap drawings for real SSD1306 hardware

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

[https://github.com/EloiStree/2026_04_27_gdp_oled_128x64/releases](https://github.com/EloiStree/2026_04_27_gdp_oled_128x64/releases)

Older versions may also be available on:

* [https://godotengine.org/asset-library/asset](https://godotengine.org/asset-library/asset)
* [https://store.godotengine.org](https://store.godotengine.org)

---

## License

Beerware license:
[https://github.com/EloiStree/2026_04_27_gdp_oled_128x64/edit/main/LICENSE](https://github.com/EloiStree/2026_04_27_gdp_oled_128x64/edit/main/LICENSE)

---

## How to Use

1. Add `Display128x64` to your scene
2. Use the facade for simple interaction
3. Enable **Edit Local** to explore advanced features

Core methods:

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

<img width="128" height="64" alt="godot_gear_128x64" src="https://github.com/user-attachments/assets/d682b1cf-4854-4cca-9860-830e4f80ddde" />  
<img width="1136" height="639" alt="image" src="https://github.com/user-attachments/assets/e3051e73-4816-4542-823c-d616dbe068c6" />  

---

## Related Projects

* Main project:
  [https://github.com/EloiStree/2026_04_27_gdp_oled_128x64](https://github.com/EloiStree/2026_04_27_gdp_oled_128x64)

* Examples:
  [https://github.com/EloiStree/2026_04_27_gdp_oled_128x64_sample](https://github.com/EloiStree/2026_04_27_gdp_oled_128x64_sample)

* Tutorial:
  [https://github.com/EloiStree/HelloGodot128x64](https://github.com/EloiStree/HelloGodot128x64)

* ESP32 integration:
  [https://github.com/EloiStree/2026_04_27_esp32_oled_128x64_udp_i2c](https://github.com/EloiStree/2026_04_27_esp32_oled_128x64_udp_i2c)

---

# Screenshot

<p>
  <img src="https://github.com/user-attachments/assets/1c72d440-f9fa-4544-a624-17ef8f0cd689" width="256" />
  <img src="https://github.com/user-attachments/assets/25ad9c21-c00b-4bfb-a7cc-dec10f3d1a06" width="256" />
  <img src="https://github.com/user-attachments/assets/2e44dd5e-798c-47b0-9a9b-024b1c8857a3" width="256" />
  <img src="https://github.com/user-attachments/assets/cb14c083-2e30-4e29-846b-41f5b57a5661" width="256" />
  <img src="https://github.com/user-attachments/assets/e3051e73-4816-4542-823c-d616dbe068c6" width="256" />
</p>
