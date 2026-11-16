# PRG2214 Assignment 2: Food Delivery Profitability Analytics (starter project)

## Build and run
```
cabal build
cabal run food-delivery -- data/food_orders_new_delhi.csv
cabal test --test-show-details=direct
```
Put the Kaggle file `food_orders_new_delhi.csv` (from the Assignment 2 section on eLearn) into `data/`.

## Project layout (do not rename)
| File | What goes in it |
|---|---|
| `food-delivery.cabal` | Build file. You may add your own modules under `other-modules`. |
| `src/Order.hs` | Part A: your `Order` record. `Discount` and `PaymentMethod` constructors are fixed. |
| `src/Toolkit.hs` | Q4: `countBy`, `groupAggregate`, `average` (required) plus your own polymorphic HOFs. |
| `src/Analysis.hs` | Parsing and Q1–Q3. **Names and type signatures are fixed.** |
| `src/ReviewFixed.hs` | Part C: your corrected version of the AI-generated code. |
| `src/Variant.hs` | Q5: **your personal variant**. Put your code (from eLearn, e.g. `X3-Y1`) in `myVariant` and implement only your X and Y tasks. |
| `app/Main.hs` | Prints the clearly labelled report. |
| `test/PublicSpec.hs` | Public tests on `data/sample_orders.csv`. Run them often. |
| `DESIGN.md`, `REVIEW.md` | Part A design and Part C review (create them in the project root). |

## The interface contract
Your code is marked automatically with **hidden tests** on **different datasets**, which call the functions in
`Analysis`, `Toolkit` and `ReviewFixed` by name. If you rename a module or change a type signature, the hidden
tests cannot compile and you lose the marks for correct output. Passing the public tests is a good sign, but it
is **not** a guarantee: the hidden data contains ties, malformed rows and unusual offers.

Rules the tests rely on:
* `myVariant` must be exactly the code your lecturer gave you. Every submission in the class has a different code.
* Ties in "top n" lists are broken by Restaurant ID **ascending**.
* `parseOrders` takes the **whole CSV text, including the header**, finds columns **by header name**, ignores
  blank lines, and returns `(validOrders, numberOfSkippedRows)`.
* A row is skipped if it has the wrong number of fields, a bad number, an unknown payment method or an
  unrecognised discount.
* Functions on an empty list must not crash (`Nothing`, `[]` or `0` as documented).
