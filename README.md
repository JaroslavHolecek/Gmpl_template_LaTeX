# LaTeX šablona pro Středoškolskou odbornou činnost a pro Seminární práce na Gymnáziu Kladno
Šablona slouží pro tvorbu seminárních prací (především na Gymnáziu Kladno) a také pro práci v rámci Středoškolské odborné činnosti (SOČ).

Šablona umožňuje dva typy práce
- Seminární připravenou pro požadavky Gymnázia Kladno
- SOČ připravenou pro požadavky Středoškolské odborné činnosti

Šablona umožňuje dva stavy dokumentu
- pracovní s červeným upozorněním a datem vytvoření PDF
- finální v čisté podobě

## Použití
- Stáhni šablonu (složku/projekt se všemi soubory) zde [GitHub](https://github.com/JaroslavHolecek/Gmpl_template_LaTeX) (Zelené tlačítko Code -> Download .zip) nebo ji rovnou použij na [Overleaf](https://www.overleaf.com/read/wxscbbtqfjpd#863c9f)
- **Nezasahuj** do ničeho ve složce `sablona`, pokud si nejsi jistá co děláš.
- Přečti si jeden z PDF souborů, nebo ten, který se vygeneruje automaticky (všechny jsou stejné až na titulní stranu) - v textu najdeš užitečné informace a ukázky jak se používá LaTeX
- V souboru `userdata.tex` vyplň na jakém typu práce pracuješ (`soc` nebo `seminar`) a zda je to zatím pracovní verze nebo verze k odevzdání (`work` nebo `final`)
- V souboru `userdata.tex` vyplň informace o práci, jako její název, název v anglickém jazyku, tvé jméno atd.
- Ve složce `parts/` si vytvoř soubory s příponou `.tex` ve kterých budeš mít jednotlivé části tvé práce (kapitoly, sekce, ...) 
- V souboru `main.tex` pomocí příkazu `\input{parts/...}` vkládej soubory, které máš připravené ve složce `parts/`.
- Je možné mít veškerou práci v jednom souboru, ale důrazně to nedoporučuji. Při trochu rozsáhlejší práci je již jeden soubor extrémně nepřehledný.
- Pokud pracuješ offline, budeš "spouštět" soubor `main.tex`, pokud pracuješ v Overleaf, nemusíš dělat nic speciálního

