# Dynamic-Spotify-Theme

This is my personal setup for making Spotify look **clean and dynamic**, using the [Retroblur](https://github.com/Motschen/Retroblur) Spicetify theme. The goal is to have Spotify match my system colors and use a blurred version of my desktop wallpaper, updating automatically whenever my wallpaper or colors change.

I’m writing this down so anyone can follow the steps, understand why each piece exists, and tweak it for their own setup.

![demo](./wallpaper.gif)


---

## What you need

* [Spicetify](https://spicetify.app/) — this lets you customize Spotify with themes, extensions, and custom CSS.
* The [Retroblur theme](https://github.com/Motschen/Retroblur) — this is the theme I built my setup on.
* `python3` (or any simple HTTP server) — used to host the wallpaper locally.
* `ImageMagick` — optional, if you want to tweak the blur or scale your wallpaper images.
* `rofi` (or any theme/colors generator) — for pulling system colors automatically.

---

## How it works

### 1. Blurred Wallpaper

Spotify caches background images when you pick a file. That means:

* If you just overwrite the file in the folder, Spotify **doesn’t see the change**.
* It seems to create its own internal copy, so the old image stays visible.

To fix this, I run a **small local HTTP server** that serves my blurred wallpaper:

```
http://localhost:24832/blurred_wallpaper.jpg
```

This way, Spotify fetches the image over HTTP every time, bypassing its internal caching. It’s a simple solution but works reliably.
I also made a script that automatically:

* Takes my current desktop wallpaper
* Creates a slightly blurred JPG copy
* Places it in the Retroblur assets folder
* Serves it via the localhost server

Running this script ensures that Spotify’s background **always matches my wallpaper**.

You do however still have to delete a specific cache file. if you delete the entire cache you also delete the localhost input of the img, so you need to delete aver specific part of the cache
```
$HOME/.cache/spotify/Default/Cache/

```

I run my localhost server using a systemd .service to run the localhsot server for that specific folder `/assets`


---

### 2. Dynamic Colors

Spotify themes only accept **hex color codes**. RGB, RGBA, or any other format will break it. My colors are pulled from:

```
~/.config/rofi/colors.rasi
```

I use a script that converts those colors into hex and writes them into the `[current]` section of `color.ini` in Retroblur:

```
~/.config/spicetify/Themes/Retroblur/color.ini
```

This ensures that:

* The theme’s text, buttons, and UI elements **always match my system colors**
* Spotify automatically adapts when I change my system colors

Because Spicetify only reads `[current]` when applying a theme, my script **overwrites that section** every time.

make sure ur Theme on Spicetify is set to `[current]`

---

### 3. Automation

I combined everything into a single script:

```bash
update_spotify.sh
```

It does the following:

1. Updates the blurred wallpaper and serves it over localhost
2. Updates the `[current]` section of `color.ini` from `rofi/colors.rasi`
3. Clears Spotify’s cache (otherwise the wallpaper won’t update)
4. Applies the Retroblur theme using Spicetify

This means I can just run one command and my Spotify **always looks perfect**.

---

### 4. Optional Nice-to-Haves

* **Workspace rules:** I made Spotify always open on workspace 8 and set it to `noinitialfocus`. That way, it always opens in the same spot **without stealing focus** from what I’m doing.
* **Wallpaper tweaks:** You can slightly zoom or adjust the blur using ImageMagick before serving the wallpaper.

---

### TL;DR

* Retroblur + Spicetify = customizable Spotify theme
* Blurred wallpaper served via localhost = always updated background
* `[current]` section of `color.ini` updated from Rofi colors = dynamic theme matching system colors
* `update_spotify.sh` = run it once to do everything automatically
