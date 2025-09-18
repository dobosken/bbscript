# BBScript - Broscar

A fork of Pangaea's original ( [super-continent/bbscript](https://github.com/super-continent/bbscript) ), built specifically to cater to my personal workflow.

Not implicitly incompatible with other Arcsys titles, but this fork has not been tested with anything other than DBFZ.

## How to install

I highly recommend just getting the [DBFZ BBS editing pack](https://drive.google.com/file/d/1bReg3u3IOu6Kc0zUP2Bx2iaPULsNV3aS/view?usp=sharing). It's easier to use, and contains (nearly) everything you need to get going straight away.

If you wish to use my variant of BBS with other tools:

1. Get the latest version of the executable from [Releases](https://github.com/dobosken/bbscript/releases).

2. It includes a dbfz.ron, but you'll want to manually download [the most recent one](https://github.com/dobosken/bbscript/blob/dbfz/static_db/dbfz.ron).

3. Replace the existing BBScript executable and dbfz.ron in your current workflow.

**Warning: You cannot use my custom dbfz.ron with vanilla BBScript. You'll have to copy over the new BBScript executable as well.**

## Moar stuff

Documentation can be found at ( [DBFZ BBS lookup](https://dobosken.github.io/dbfz_bbs_lookup/) ).

Also check out ( [dobosken/dbfz_npp](https://github.com/dobosken/dbfz_npp) ) for better BBS editing with Notepad++.

## Changes from Pangaea's BBScript

- Indentation is now done with tabs, and is less likely to break due to vanilla Arcsys errors

- Support for opening and closing braces. Enables somewhat decent code folding, theme styling etc.

- Tweaks to automatically correct vanilla Arcsys errors in JNNEF and BRS (FRN still has to be fixed manually)

- A heavily tweaked DBFZ database. Breaks conventions with legacy BBS terminology, which was often cryptic or incorrect.
