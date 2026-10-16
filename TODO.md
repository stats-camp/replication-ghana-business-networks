# Missing features and verification TODO

Audit date: October 13, 2026. The list separates observed native engine
failures from acceptance checks that still need a numerical or visual
reference. No deposited do-file, ado-file, or dataset was modified.

## Confirmed blockers, in execution order

- [ ] **Provide a setup path for unchanged `master.do`.** `ssc install`
  stops at master line 14 with `r(199)`; `adopath +` is also unknown. The
  master resets its path to `FOLDER`, so an external path alias or session
  preamble is required. Account for `estout`, `ftools`, `coefplot`, and the
  bundled `zindex.ado`. Test setup without needing to edit deposited code.
- [ ] **Implement `egen rowtotal(varlist), missing`.** Cleaning stops at
  line 139 with `r(198)`. Preserve Stata's rule: return missing if every
  component is missing; otherwise sum nonmissing components. The existing
  version without `missing` executes, but does not meet this requirement.
- [ ] **Execute the bundled `zindex` program faithfully.** The engine
  cannot load `program zindex, rclass` (ado line 3), and calls at cleaning
  lines 266, 277, and 288 return `r(199)`. Supply compatible ado execution
  or an implementation matching this exact program, including returned
  results and missing-value semantics. Do not substitute a generic
  average of z scores.
- [ ] **Implement `estpost summarize` and `estpost ttest ..., by(female)`**
  for Table 1. All four posting calls at output lines 38–47 are unknown
  (`r(199)`). Post per-variable summaries and differences with the result
  fields needed by `cells()`, and preserve model A/B/C/D ordering.
- [ ] **Implement `estadd scalar mean ..., replace` and `estadd local
  industry "Yes/No", replace`.** These are unknown at output lines
  175–248. Store numeric and string results on the intended active/stored
  estimation results, without altering existing coefficients or samples.
- [ ] **Extend `esttab` LaTeX export and the actual table options.**
  `using` is rejected at output lines 52, 203, and 256 (`r(198)`).
  Independent probes also reject `cells()`, `collabels()`, `booktabs`,
  `wide`, `refcat(..., nolabel)`, `r2`, the `s()` abbreviation with nested
  `label()`/`fmt()`, `nomtitles`, fragment abbreviation `f`, and
  `nobaselevel`. Table 1 needs different cells per model via `pattern()`,
  per-cell `fmt()`, stars, and parenthesized p-values. Tables 2/3 need
  mixed string/numeric footer results and LaTeX fragments. Existing
  `star()`, `label`, `nonum`, `keep()`, `se`, and `noomitted` execute in
  console probes. `mtitles()` is recognized; exact four-model headings
  still need validation.
- [ ] **Extend the matrix commands used to build plot data.**
  `matrix coln ... = mean ll95 ul95` and row-slice assignment such as
  `matrix M[1,1] = expression, expression, expression` return `r(198)`.
  `matrix M=J(1,3,.)` and single-cell assignments execute. Support names
  and filling a contiguous row from its starting cell, not just the
  individual cells in a rewritten script.
- [ ] **Support `coefplot` matrix sources and explicit CI matrices.**
  `matrix(M[,1])` is interpreted as a missing estimation result despite
  an existing matrix. Per-series `ci((M[,2] M[,3]))`, `rename()`, `color()`,
  `mcolor()`, `nokey`, and `mlabsize()` are rejected in independent probes.
  Preserve the script's supplied 1.96-based intervals and offsets rather
  than recomputing intervals from stored regression coefficients.
- [ ] **Complete the coefficient plot presentation options.** Independent
  probes reject `barwidth()`, `fcolor()`, `citop`, `base`, `mlabel`,
  `mlabcolor()`, `mlabp()`, `mlabg()`, `mlabf()`, `bgcolor()`,
  `legend(rows())`, and `grid()`. `ciopts(color(...))` is rejected;
  `ciopts(recast(rcap) color(gs8))` executes, but source inspection shows
  that the recast is returned before later styling options are applied,
  so color fidelity is not established. `recast(bar)`,
  `legend(position())`, region settings, and `xline()` execute separately.
  Verify both whole plot commands after their data and option blockers
  are resolved; acceptance of a subset is not figure reproduction.
- [ ] **Export EPS figures.** An independent export after a valid basic
  plot rejects `.eps` with “supports only .svg, .png, and .pdf”. The
  authors require `Figure1a.eps` and `Figure1b.eps`; changing their
  do-files to another format is outside this package's scope.

## Required acceptance checks, not yet established

- [ ] **Verify all three indices against the exact bundled program.**
  The seven-component business-network index, three-component
  friends/relatives index, and four-component female-network index each
  need comparison to a Stata reference on the deposited data.
- [ ] **Test `zindex` sample and reference semantics.** `marksample,
  novarlist` retains rows with partially missing inputs. `if`/`in` define
  the output sample; `condition()` further restricts the reference sample
  used for means and sample standard deviations. Optional `mean()` uses
  corresponding reference variables in order. Standardize each input,
  take `rowmean()` over nonmissing z scores, then standardize that row
  mean again over the reference sample. All-missing row means and
  zero-variance reference components must follow Stata missing behavior.
- [ ] **Test the remaining program contract rather than assuming its
  primitives work.** Requirements include `syntax`, temporary variables,
  nested macro names, extended local word functions, `return scalar`,
  error branches (102/103/119), `rowmiss()`, `tabulate` with `matcell()`
  and `matrow()`, `rowsof()`, matrix subscripts/drop, and missing-value
  reports. The current audit establishes the initial program-loading
  failure; it does not individually reject or validate all later
  primitives. `r(m_variable)` counts missing standardized components
  inside the marked sample, not just raw missing values.
- [ ] **Compare all intended regression samples and estimates.** Fifteen
  robust OLS fits executed in a diagnostic run, including the baseline
  profit specification. Index-based fits could not run because their
  input variables were never created. Those downstream failures do not
  establish a further missing regression feature. Check the full
  specifications once cleaning succeeds, including the script's missing
  indicators and `-9` replacements.
- [ ] **Compare all three tables and both figure panels to a reference.**
  Check content, labels, significance thresholds, footer formatting,
  category headers, confidence intervals, colors, legend layout, and
  output files. `xlabel()` syntax is recognized, but the standalone
  probe with an unrelated stored model hit a canvas-size limit; the
  paper's intended chart after matrix support remains untested.
- [ ] **Obtain a valid Stata reference and verify the browser build.** The
  installed Stata license is expired, and the package has no numerical
  reference transcript. Native execution does not establish numerical
  parity, visual parity, or separately tested WASM/browser behavior.
- [ ] **Run the unmodified scripts in a fresh workspace and recheck
  source hashes.** A `do, nostop` exit or generated dataset does not prove
  completion when earlier commands failed. Require no unhandled errors,
  complete expected outputs, and byte-identical originals.

Evidence: [audit.json](validation/audit.json),
[master.log](validation/master.log), [clean.log](validation/clean.log),
[clean-nostop.log](validation/clean-nostop.log),
[output-nostop.log](validation/output-nostop.log), and
[options.log](validation/options.log).

## Validation against Stata (2026-10-14)

Stata 19.5 (csdid-era license, `ssc install coefplot` added) and the engine
both ran the unchanged `master.do` on scratch copies without errors. Findings:

- [x] **Fixed — `eststo` numbering and order.** `eststo clear` did not restart
  the `est#` counter and stored sets were listed alphabetically, so Table 2's
  columns came out as models 4, 5, 6, 1, 2, 3. Sets are now kept in storage
  order and the counter restarts when the store is cleared or emptied.
- [x] **Fixed — variable `export` saved as `_export`.** The DTA writer treated
  Mata keywords as reserved names; only Stata's reserved words are renamed now.
- [x] **Fixed — `if mi(z) & touse`.** A bare numeric operand of `&`/`|`
  evaluated to missing, so `zindex`'s `count if mi(...) & touse` returned 0 and
  its "missing values for" messages were absent.
- [x] **Fixed — extended missing values.** The raw data hold `.r`/`.d` codes
  (`b28a`, `b32b2`, `hours_childcare`, ...), which the engine read as `.`, so
  Stata's `replace suppliers_impt_women = . if b32b2==. & b32b2_2==. & b32b2_3==.`
  (which keeps rows with `.r`, as `.r == .` is false) set them missing and
  Table 3's columns 3, 5 and 6 differed in the third digit (Female −857.8 vs
  Stata's −856.2). The dataset layer now keeps `.a`–`.z` through `use`/`save`,
  expressions, `reshape` (the cleaning's `reshape long products`), `merge`,
  `append`, `sort` and the other commands; `Table3.tex` is now byte-identical
  to Stata's.
- [x] **Verified — cleaned dataset.** `cf _all` against Stata's
  `gender_gaps_ghana_clean.dta`: the only differences are float rounding of
  z-score intermediates (about 1e-7) in the three index variables.
- [x] **Verified — Tables 1 and 2.** Every value equals Stata's.
- [x] **Fixed — LaTeX layout of `esttab using ... .tex`.** The engine now
  pads cells to the model width with estout's star field, writes
  `\begin{tabular}{l*{4}{ccc}}` (one `c` per cell element), plain right-aligned
  `collabels()`, `\addlinespace` between coefficient blocks under `booktabs`
  and no star legend when `cells()` is given; `Table1.tex`, `Table2.tex` and
  `Table3.tex` are byte-identical to Stata's.
- [ ] **Not compared — figures.** `graph export` output was not checked.

## Re-validation (2026-10-15)

Stata 19.5 and the engine ran the unchanged `master.do` again on fresh scratch
copies; numerical parity holds.

- [x] `Table1.tex`, `Table2.tex`, `Table3.tex` byte-identical to Stata's.
- [x] Cleaned dataset equal to Stata's up to 1e-7 float rounding in the three
  indices.
- [x] **Figures.** `Figure1a.eps`/`Figure1b.eps` show the same estimates; the
  engine's EPS writer lost the ancestor transforms of flattened text, so labels
  overflowed into the plot and `xline(0)` sat beside the `0` tick. Fixed on
  2026-10-15 (EPS now equals the SVG/PNG output); axis labels use Stata's
  `-.2` style. Fonts remain larger than Stata's. See
  `aea_replication/figure_comparison.html` in the main repository.
- [ ] Verify the browser build separately.
- [x] **Browser path.** The web UI has no `FOLDER` directory alias, so the
  unchanged master failed at `log using "FOLDER/log/..."` and
  `do "FOLDER/code/clean.do"`. Fixed on 2026-10-15 by making the one edit the
  authors ask for: `local path "`c(pwd)'"` (see the README's Local
  modification section); the master now runs from the package root.
