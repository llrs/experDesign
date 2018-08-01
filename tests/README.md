Tests and Coverage
================
01 agosto, 2018 17:39:45

-   [Coverage](#coverage)
-   [Unit Tests](#unit-tests)

This output is created by [covrpage](https://github.com/yonicd/covrpage).

Coverage
--------

Coverage summary is created using the [covr](https://github.com/r-lib/covr) package.

| Object                                             | Coverage (%) |
|:---------------------------------------------------|:------------:|
| experDesign                                        |     25.67    |
| [R/designer.R](../R/designer.R)                    |     0.00     |
| [R/evaluate\_category.R](../R/evaluate_category.R) |     0.00     |
| [R/evaluate\_num.R](../R/evaluate_num.R)           |     0.00     |
| [R/reporting.R](../R/reporting.R)                  |     0.00     |
| [R/evaluate.R](../R/evaluate.R)                    |     14.81    |
| [R/entropy.R](../R/entropy.R)                      |     95.00    |
| [R/indexing.R](../R/indexing.R)                    |     95.45    |

<br>

Unit Tests
----------

Unit Test summary is created using the [testthat](https://github.com/r-lib/testthat) package.

|                         | file                                                       |    n|   time|  error|  failed|  skipped|  warning|
|-------------------------|:-----------------------------------------------------------|----:|------:|------:|-------:|--------:|--------:|
| test\_batch-names.R     | [test\_batch-names.R](testthat/test_batch-names.R)         |    1|  0.001|      0|       0|        0|        0|
| test\_create-subset.R   | [test\_create-subset.R](testthat/test_create-subset.R)     |    2|  0.002|      0|       0|        0|        0|
| test\_entropy.R         | [test\_entropy.R](testthat/test_entropy.R)                 |    3|  0.003|      0|       0|        0|        0|
| test\_evaluate-helper.R | [test\_evaluate-helper.R](testthat/test_evaluate-helper.R) |    2|  0.003|      0|       0|        0|        0|
| test\_evaluate-na.R     | [test\_evaluate-na.R](testthat/test_evaluate-na.R)         |    1|  0.002|      0|       0|        0|        0|
| test\_insert.R          | [test\_insert.R](testthat/test_insert.R)                   |    3|  0.003|      0|       0|        0|        0|
| test\_simplify2matrix.R | [test\_simplify2matrix.R](testthat/test_simplify2matrix.R) |    1|  0.001|      0|       0|        0|        0|

| file                                                           | context          | test       | status |    n|   time|
|:---------------------------------------------------------------|:-----------------|:-----------|:-------|----:|------:|
| [test\_batch-names.R](testthat/test_batch-names.R#L6)          | batch\_names     | works      | PASS   |    1|  0.001|
| [test\_create-subset.R](testthat/test_create-subset.R#L5)      | create\_subset   | works      | PASS   |    2|  0.002|
| [test\_entropy.R](testthat/test_entropy.R#L5)                  | entropy          | Extremes   | PASS   |    2|  0.002|
| [test\_entropy.R](testthat/test_entropy.R#L12)                 | entropy          | Ignores NA | PASS   |    1|  0.001|
| [test\_evaluate-helper.R](testthat/test_evaluate-helper.R#L7)  | evaluate\_helper | works      | PASS   |    1|  0.001|
| [test\_evaluate-helper.R](testthat/test_evaluate-helper.R#L15) | evaluate\_helper | mean       | PASS   |    1|  0.002|
| [test\_evaluate-na.R](testthat/test_evaluate-na.R#L10)         | evaluate\_na     | works      | PASS   |    1|  0.002|
| [test\_insert.R](testthat/test_insert.R#L8)                    | insert           | works      | PASS   |    3|  0.003|
| [test\_simplify2matrix.R](testthat/test_simplify2matrix.R#L5)  | simplify2matrix  | works      | PASS   |    1|  0.001|

<!--- Final Status : pass --->
