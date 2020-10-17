## Key Remapping
To create custom keyboard shortcuts, the Caps Lock key can be overwritten to be used as
the `Mode_switch` key. `Mode_switch` is modifier key normally reserved for special
characters in non-English alphabets; in an English keyboard layout it is unused
entirely. See the Arch Linux wiki page on
[keymap tables](https://wiki.archlinux.org/index.php/Xmodmap#Keymap_table) for an
overview of how keysyms are used.

To make the changes themselves, edit `~/.Xmodmap` to do the following:
* Clear the current Caps Lock and Mode Switch modifier keys
* Reset the Caps Lock key to Mode Switch (Note: use `xev` to determine the keycode
for any given key)
* Update the `keycode` for a given key to take the preferred action when pressed
in tandem with the Mode Switch. The four columns associated with a given `keycode` represent
the action to perform when 
  * `Key`
  * `Shift + Key`
  * `Mode_switch + Key`
  * `Mode_switch + Shift + Key`

By changing the value of the third column for a given key, it will now update the behavior
for pressing `Caps Lock + Key`.



