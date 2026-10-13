# Replication: Gender Gaps in Entrepreneurship in Ghana

Monica Lambon-Quayefio, Edward Asiedu, Francesca Truffa, and Ashley Wong,
*AEA Papers and Proceedings* 115 (2025): 495–99.

This stats-camp repository preserves package **228101, version V1**, for
inspection and capability testing in [stats.camp](https://stats.camp).
All three deposited do-files, the bundled ado-file, the dataset, and the
original `README.pdf` retain their original bytes and locations.

**Open in stats.camp:**
[code/master.do](https://stats.camp/app?open=https%3A%2F%2Fgithub.com%2Fstats-camp%2Freplication-ghana-business-networks.git&file=code%2Fmaster.do)

**Status: partial analysis runs; full replication is pending.** The native
audit on October 13, 2026 found confirmed setup, index, table, and figure
gaps. [TODO.md](TODO.md) records them. The do-files were not changed to
work around these gaps, and no statistical engine feature was implemented
as part of packaging.

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

The scripts target `Table1.tex`, `Table2.tex`, and `Table3.tex`, plus
`Figure1a.eps` and `Figure1b.eps`. They also create the cleaned dataset and
a code log. These outputs are **not included in the deposit**, and this
audit did not reproduce the complete tables or figures. Empty output
directories are retained using `.gitkeep` files.

## What runs

The unchanged master stops at line 14, `ssc install estout`, with
`r(199)`. It has the literal path placeholder `FOLDER`, and later uses
`adopath` to find the bundled program. Both setup commands are presently
unavailable in stats.camp.

Running the unchanged cleaning script with an externally supplied `data`
global successfully loads the DTA and labels, renames variables, generates
and replaces values, splits product codes, reshapes 1,487 records into
62,454 product records, destrings, computes grouped maxima, and returns to
1,487 records. It first stops at **clean.do line 139**:

```stata
egen total_collab = rowtotal(b30a-b30g), missing
```

The `missing` option is rejected with `r(198)`. A diagnostic `do, nostop`
run also confirms that all three `zindex` calls are unavailable.
`rowtotal()` without this option, the later cleaning commands, and the
save command execute. The resulting diagnostic dataset lacks the
collaboration total and all three indices; it is not a valid completed
analysis dataset and is not distributed here.

An unchanged `output.do, nostop` diagnostic run on that scratch dataset
executes **15 robust OLS fits** on variables unaffected by the failed
indices: 14 gender comparisons and the baseline profit regression. For
example, `reg business_help_n female,r` uses 1,436 observations, and
the baseline `eststo: reg profit female age years_operation
business_primary_inc,r` uses 1,398. Estimate storage works. Independent
option probes also execute basic console `esttab` and stored-model
`coefplot` commands. These results demonstrate execution, not numerical
agreement with Stata or completion of the paper's outputs.

Confirmed failures include `estpost`, `estadd`, LaTeX file export through
`esttab using`, matrix column names and multi-cell row assignment, matrix
sources and several options in `coefplot`, and EPS export. The
[cleaning diagnostic](validation/clean-nostop.log),
[output diagnostic](validation/output-nostop.log), and
[individual option probes](validation/options.log) preserve the evidence.
Downstream errors for missing indices are consequences of the cleaning
failures, not additional evidence of missing regression features.

The installed Stata license has expired, and the deposit provides no
numerical reference transcript. Fresh Stata comparisons, the three
indices' numerical values, complete tables, final figure appearance, and
browser versus native parity remain unverified.

## Paths without changing do-files

The original master instructs replicators to edit `local path "FOLDER"`.
This repository leaves that line untouched. On a native filesystem,
launching from the package root with a directory alias named `FOLDER`
pointing to that root satisfies the literal path. For example, on Unix,
`ln -s . FOLDER` creates such an alias. Dependency and ado support would
still be required to run the master successfully.

Alternatively, set paths in the session and call the two unchanged
scripts directly. In Stata, with the required `estout`, `ftools`, and
`coefplot` packages installed, a session preamble can be:

```stata
global replication "/absolute/path/to/replication-ghana-business-networks"
adopath + "${replication}"
global data "${replication}/data"
global output_tables "${replication}/output/tables"
global output_figures "${replication}/output/figures"
capture mkdir "${data}/analysis"
capture mkdir "${output_tables}"
capture mkdir "${output_figures}"
do "${replication}/code/clean.do"
do "${replication}/code/output.do"
```

For a stats.camp capability check, set `global data "data"` from the
package root, then `do "code/clean.do"`. The current engine stops at the
`rowtotal(), missing` command above. `do ..., nostop` is useful for
diagnostics only: it continues after errors and may save incomplete
derived data. All audit runs were made in a separate scratch copy, so
neither the original dataset nor deposited scripts were overwritten.

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
