# BBScript - Broscar

A fork of Pangaea's original ( [super-continent/bbscript](https://github.com/super-continent/bbscript) ), built specifically to cater to my personal workflow.

Not implicitly incompatible with other Arcsys titles, but this fork has not been tested with anything other than DBFZ.

## How to install

1. Get the latest version from [Releases](https://github.com/dobosken/bbscript/releases). It includes an up-to-date dbfz.ron

2. Shove the archive next to an existing bbscript

3. Extract it.

4. it's a drop-in replacement. You're done. Congrats.

**Note: You cannot use my custom dbfz.ron with vanilla BBScript. You'll have to copy over the new BBScript executable as well.**

## Moar stuff

Documentation can be found at ( [DBFZ BBS lookup](https://dobosken.github.io/dbfz_bbs_lookup/) ), but the website is not yet fully up-to-date, so make sure to keep dbfz.ron open and cross-reference the id numbers.

Also check out ( [dobosken/dbfz_npp](https://github.com/dobosken/dbfz_npp) ) for better BBS editing with Notepad++.

## Changes from vanilla BBScript

- Indentation is now done with tabs, and is less likely to break due to vanilla Arcsys errors

- Support for opening and closing braces. Enables somewhat decent code folding, theme styling etc.

- Tweaks to automatically correct vanilla Arcsys errors in JNNEF and BRS (FRN still has to be fixed manually)

- A heavily tweaked DBFZ database. Breaks conventions with legacy BBS terminology in favour of correctness/ease of use.
