# Localization review

KerfPlan bundles English (`en`), Spanish (`es`), German (`de`), French (`fr`),
Brazilian Portuguese (`pt-BR`), Italian (`it`), Polish (`pl`), Russian (`ru`),
Turkish (`tr`), and Ukrainian (`uk`). English is the fallback. System mode follows
the Android locale; `pt-PT` and other Portuguese variants use the Brazilian
translation. Flutter 3.47 requires a base `app_pt.arb` alongside `app_pt_BR.arb`.
Both have the same Brazilian text; the application's selectable locales remain
the ten listed above.

| Language | Stock | Part | Cut plan | Kerf | Scrap | Reusable leftover |
| --- | --- | --- | --- | --- | --- | --- |
| English | Stock | Part | Cut plan | Kerf | Scrap | Reusable leftover |
| Spanish | Material disponible | Pieza | Plan de corte | Ancho de corte | Descarte | Retal reutilizable |
| German | Rohmaterial | Teil | Schnittplan | Schnittfuge | Ausschuss | Wiederverwendbares Reststück |
| French | Barres disponibles | Pièce | Plan de coupe | Trait de scie | Déchets | Chute réutilisable |
| Brazilian Portuguese | Material disponível | Peça | Plano de corte | Largura de corte | Refugo | Sobra reutilizável |
| Italian | Materiale disponibile | Pezzo | Piano di taglio | Spessore di taglio | Residui da scartare | Rimanenza riutilizzabile |
| Polish | Materiał dostępny | Element | Plan cięcia | Rzaz | Odpad | Pozostałość do ponownego użycia |
| Russian | Заготовки | Деталь | План распила | Ширина пропила | Обрезки | Пригодный остаток |
| Turkish | Stok malzeme | Parça | Kesim planı | Kesim payı | Hurda | Yeniden kullanılabilir artık |
| Ukrainian | Заготовки | Деталь | План розкрою | Ширина пропилу | Обрізки | Придатний залишок |

Translations use workshop terms rather than literal word substitution. Technical
unit symbols (`mm`, `cm`, `m`, `in`, `ft`) and the user's project names, material,
labels and notes stay unchanged. Google Play supplies localized prices; the app
inserts them without altering currency formatting. The shared localized report
snapshot supplies both Share Text and PDF labels. Bundled Noto fonts cover the
tested glyphs, and PDF creation makes no font network request.

Russian and Ukrainian count messages use ICU one/few/many forms; Polish does too.
Other languages use their appropriate one/other forms. Flutter's generator emits
`#` literally in these messages, so count variables are written explicitly as
`{count}` or `{requested}` inside each plural branch.

These are production-oriented initial translations and should receive
native-speaker review before large-scale marketing campaigns. In particular,
review local trade preferences for Spanish stock wording, German cut terminology,
French *éboutage*, Brazilian Portuguese *desbaste das pontas*, and Polish/Russian/
Ukrainian inflection around compact counts and spoken accessibility text.

To add a locale, translate every message in `app_en.arb`, preserve placeholder
names/types and ICU arguments, add a resource coverage case, run `flutter gen-l10n`,
and test UI, Share Text, PDF glyphs, plurals and narrow layouts. For locales with a
country code, provide any base ARB required by Flutter's generator and keep the
app's supported locale list intentional. Do not edit generated Dart files.
