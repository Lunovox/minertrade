# TRANSLATES

To generate file '**template.pot**', did use terminal command:

````xgettext -n *.lua -L Lua --force-po --keyword=modMinerTrade.translate --from-code=UTF-8 -o template.pot````

To translate '**template.pot**' to your language use app poedit.:

````sudo apt-get inatall poedit````

* Locales used: ca;cs;da;de;dv;eo;es;et;fr;hu;id;it;ja;jbo;kn;lt;ms;nb;nl;pl;pt;pt_BR;ro;ru;sl;sr_Cyrl;sv;sw;tr;uk

* Translate Sample: "locale/pt.po" to portuguese language.

* To enable the translate to portuguese language, write "language = pt" in file "minetest.conf". Or write the command "```/set -n language pt```" in game chat, and run again the minetest game.

> See more: 
* https://forum.minetest.net/viewtopic.php?f=47&t=21974
* https://github.com/minetest/minetest/issues/8158
