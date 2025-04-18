
For information on how to use the mod head to the [official homepage](https://github.com/Aelto/tw3-wild-monster-hunt)

# Development
- The mod depends on other script utilities like tw3-sharedutils
- REDkit doesn't officially support script utilities

For this reason:

- the `make-redkit-depot.bat` can be used to generate a `scripts`
folder that is meant to replace the vanilla `scripts` of the depot. This new
folder includes all of the dependendies merged into a single folder. Allowing the
mod to be compiled by script-studio, and tested inside the editor itself.
Running the scripts will tell it to replace the `scripts` folder directly. No manual
step needed.

- the `install-workspace` compiles the cahirc `.wss` scripts and copies the release into the workspace so they can be compiled by the game.
