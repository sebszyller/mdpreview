# mdpreview

Simple script for previewing rendered _markdown_ files from the terminal. __Requires__ `pandoc`.

## Usage

The script creates a temporary pdf file that is rendered and then removed.

- `preview.sh /path/to/file.md` - show the preview of the specified file
- `preview.sh /path/to/dir` - search for the first markdown file in the directory and show its preview (shallow search)
- `preview.sh` - like above but with `.` as directory argument 

## Linux vs macOS

There are some differences between these two when it comes to the version and availability of certain commands. `xdg-open` is not installed by default on _macOS_ (but you can get it with `brew`). However, it is not needed since the built-in `open` is just as good if not better. Worth noting that by default `xdg-open` is blocking while `open` is not, hence `--wait-apps` needs to be added.

On top of that, `readlink` available in _macOS_ is outdated compared to _Linux_. As a workaround, you can just find a way to use the built-in, or install `gnu-utils` which adds most gnu commands and makes them availalable with __g__ prefix, e.g. `gwc` or `greadlink`.

Imo, the best way here is to just edit the script and change function calls depending on the platform (`getlink` and `openpdf`):

- _Linux_: `readlink -f` and `xdg-open`
- _macOS_: `greadlink -f` and `open --wait-apps`
