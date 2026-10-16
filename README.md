# Replication: Gender Gaps in Entrepreneurship in Ghana

Monica Lambon-Quayefio, Edward Asiedu, Francesca Truffa, and Ashley Wong,
*AEA Papers and Proceedings* 115 (2025): 495–99.

This stats-camp repository preserves package **228101, version V1**, for
inspection and capability testing in [stats.camp](https://stats.camp).
The cleaning and output do-files, the bundled ado-file, the dataset, and the
original `README.pdf` retain their original bytes and locations; `code/master.do`
carries the one path edit the authors ask every replicator to make (see
[Local modification](#local-modification)).

**Open in stats.camp:**
[code/master.do](https://stats.camp/app?open=https%3A%2F%2Fgithub.com%2Fstats-camp%2Freplication-ghana-business-networks.git&file=code%2Fmaster.do)

**Status: the complete analysis replicates.** The unchanged master, cleaning
and output scripts run in stats.camp, and a Stata 19.5 comparison on
2026-10-15 found all three LaTeX tables byte-identical and the cleaned dataset
equal up to float rounding. [TODO.md](TODO.md) records the audit history and
the remaining figure-rendering differences. No analysis command was changed.

## Study and deposited material

The study examines gender differences in business networks and profits
among young agribusiness owners in Ghana. The deposit contains one survey
dataset with **1,487 observations and 146 variables**. Its original files
occupy **1,292,196 bytes** (about 1.3 MB); the largest is the raw dataset,
1,179,331 bytes. The deposited ZIP is 378,030 bytes.

| Path | Purpose |
| --- | --- |
| `code/master.do` | Dependency installation, paths, logging, and calls to the two analysis scripts |
| `code/clean.do` | Cleaning, product categories, networking variables, three standardized indices, and analysis dataset |
| `code/output.do` | Summary table, robust OLS, regression tables, and coefficient plots |
| `data/raw/gender_gaps_ghana.dta` | Original survey data |
| `zindex.ado` | Caton Brewster's bundled z-score index program, version 1.0.0, January 26, 2017 |
| `README.pdf` | Authors' original requirements, data provenance, and instructions |
| `validation/source-manifest.json` | Archive hash and the size and SHA-256 of each original file |
| `validation/audit.json` | Tested capabilities, confirmed gaps, limitations, and individual option probes |

The scripts write `Table1.tex`, `Table2.tex`, and `Table3.tex`, plus
`Figure1a.eps` and `Figure1b.eps`, the cleaned dataset and a code log. These
outputs are **not included in the deposit**; a run regenerates them. Empty
output directories are retained using `.gitkeep` files.

## What runs

Everything. On 2026-10-15 the unchanged `code/master.do` was run in Stata 19.5
(with `estout`, `ftools` and `coefplot` from SSC) and in the native stats.camp
engine from scratch copies of this repository, launched from the package root.
Neither run reports an error. The engine accepts `ssc install`
(it prints a note that packages are not downloaded because the commands are
built in) and `adopath +`, runs the bundled `zindex.ado`, `egen rowtotal(),
missing`, `estpost summarize`/`ttest`, `estadd`, `esttab using ... .tex` with
`cells()`, `booktabs` and `refcat()`, the matrix construction, and both
`coefplot` calls.

Results:

- `Table1.tex`, `Table2.tex` and `Table3.tex` are byte-identical to Stata's.
- `data/analysis/gender_gaps_ghana_clean.dta` equals Stata's file except
  float rounding (about 1e-7) in the three z-score indices (`cf _all`).
- `Figure1a.eps` and `Figure1b.eps` are written by both programs with the
  same bars, points and confidence intervals. The engine's EPS writer used to
  place text and reference lines off their SVG positions (labels ran into the
  plot, the `6.71` value label was clipped, `xline(0)` sat beside the `0`
  tick); since 2026-10-15 the EPS matches the engine's SVG and PNG, with
  Stata's `-.2`-style tick labels. Only the font size and the s2color legend
  box still differ. Side-by-side renderings are in the main repository's
  `aea_replication/figure_comparison.html`.

Earlier audit transcripts under `validation/` (October 13, 2026) predate the
engine features listed above and are kept as history. The browser build has
not been tested separately.

## Local modification

The deposited master sets `local path "FOLDER"` and instructs replicators to
change that line to their own directory. On 2026-10-15 the line was replaced by

```stata
local path "`c(pwd)'"
```

(plus a three-line comment), so the master resolves `code/`, `data/`, `log/`
and `output/` under the directory it is run from. Run `code/master.do` from the
package root, in Stata or in stats.camp, and no `FOLDER` alias or session
preamble is needed. Everything else in `master.do`, and all of `clean.do`,
`output.do` and `zindex.ado`, is byte-identical to the deposit.
[validation/source-manifest.json](validation/source-manifest.json) still records
the deposited SHA-256 of `code/master.do`
(`db175fd70633be9cd20001f03caffaf195192555dc4c43612f461dc733e088a7`), so a
manifest check reports that file as changed; its current SHA-256 is
`a54c9a2013a46ed78ad6756e45f8598e06038e037cbd34c9ac84f686bc8b4f9f`.

All validation runs were made in separate scratch copies, so neither the
original dataset nor the deposited scripts were overwritten.

## Attribution and source integrity

Lambon-Quayefio, Monica, Edward Asiedu, Francesca Truffa, and Ashley Wong.
2025. “Gender Gaps in Entrepreneurship: Business Networks and
Collaborations in Ghana.” *AEA Papers and Proceedings* 115: 495–99.
[Paper and article metadata](https://www.aeaweb.org/articles?id=10.1257/pandp.20251069).

The same authors deposited *Data and Code for: Gender Gaps in
Entrepreneurship: Business Networks and Collaborations in Ghana*.
American Economic Association [publisher], ICPSR [distributor], V1,
June 5, 2025. [Deposit DOI](https://doi.org/10.3886/E228101V1) and
[official package page](https://www.openicpsr.org/openicpsr/project/228101/version/V1/view).

The original `README.pdf` describes the survey data as available under a
Creative Commons Non-commercial license. The archive contains no
separate license file; retain the original attribution and consult the
deposit's terms before reuse. stats-camp maintains this mirror and its
audit documentation; the research and source code remain credited to
their authors, including Caton Brewster for `zindex.ado`.

Archive SHA-256:
`dfeb8acc03099b33cdf8940a4151997b9fb232f13c355dddfc267c00ccc8064f`.
All six original file hashes were verified after extraction and audit.
