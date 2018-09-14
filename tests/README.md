Tests and Coverage
================
02 agosto, 2018 11:40:57

-   [Coverage](#coverage)
-   [Unit Tests](#unit-tests)

This output is created by [covrpage](https://github.com/yonicd/covrpage).

Coverage
--------

Coverage summary is created using the [covr](https://github.com/r-lib/covr) package.

| Object                                             | Coverage (%) |
|:---------------------------------------------------|:------------:|
| experDesign                                        |     82.87    |
| [R/reporting.R](../R/reporting.R)                  |     0.00     |
| [R/evaluate\_category.R](../R/evaluate_category.R) |     36.84    |
| [R/designer.R](../R/designer.R)                    |     93.75    |
| [R/indexing.R](../R/indexing.R)                    |     95.45    |
| [R/entropy.R](../R/entropy.R)                      |    100.00    |
| [R/evaluate\_num.R](../R/evaluate_num.R)           |    100.00    |
| [R/evaluate.R](../R/evaluate.R)                    |    100.00    |
| [R/utils.R](../R/utils.R)                          |    100.00    |

<br>

Unit Tests
----------

Unit Test summary is created using the [testthat](https://github.com/r-lib/testthat) package.

|                         | file                                                       |    n|   time|  error|  failed|  skipped|  warning|
|-------------------------|:-----------------------------------------------------------|----:|------:|------:|-------:|--------:|--------:|
| test\_batch-names.R     | [test\_batch-names.R](testthat/test_batch-names.R)         |    1|  0.001|      0|       0|        0|        0|
| test\_create-subset.R   | [test\_create-subset.R](testthat/test_create-subset.R)     |    2|  0.008|      0|       0|        0|        0|
| test\_design.R          | [test\_design.R](testthat/test_design.R)                   |    2|  0.094|      0|       0|        0|        0|
| test\_entropy.R         | [test\_entropy.R](testthat/test_entropy.R)                 |    3|  0.004|      0|       0|        0|        0|
| test\_evaluate-helper.R | [test\_evaluate-helper.R](testthat/test_evaluate-helper.R) |    2|  0.002|      0|       0|        0|        0|
| test\_evaluate-index.R  | [test\_evaluate-index.R](testthat/test_evaluate-index.R)   |    1|  0.010|      0|       0|        0|        0|
| test\_evaluate-mad.R    | [test\_evaluate-mad.R](testthat/test_evaluate-mad.R)       |    1|  0.002|      0|       0|        0|        0|
| test\_evaluate-mean.R   | [test\_evaluate-mean.R](testthat/test_evaluate-mean.R)     |    1|  0.001|      0|       0|        0|        0|
| test\_evaluate-na.R     | [test\_evaluate-na.R](testthat/test_evaluate-na.R)         |    1|  0.001|      0|       0|        0|        0|
| test\_evaluate-orig.R   | [test\_evaluate-orig.R](testthat/test_evaluate-orig.R)     |    6|  0.017|      0|       0|        0|        0|
| test\_evaluate-sd.R     | [test\_evaluate-sd.R](testthat/test_evaluate-sd.R)         |    1|  0.002|      0|       0|        0|        0|
| test\_insert.R          | [test\_insert.R](testthat/test_insert.R)                   |    3|  0.002|      0|       0|        0|        0|
| test\_replicates.R      | [test\_replicates.R](testthat/test_replicates.R)           |    1|  0.217|      0|       0|        0|        0|
| test\_simplify2matrix.R | [test\_simplify2matrix.R](testthat/test_simplify2matrix.R) |    1|  0.001|      0|       0|        0|        0|

| file                                                            | context          | test       | status |    n|   time|
|:----------------------------------------------------------------|:-----------------|:-----------|:-------|----:|------:|
| [test\_batch-names.R](testthat/test_batch-names.R#L6)           | batch\_names     | works      | PASS   |    1|  0.001|
| [test\_create-subset.R](testthat/test_create-subset.R#L5)       | create\_subset   | works      | PASS   |    2|  0.008|
| [test\_design.R](testthat/test_design.R#L8)                     | design           | works      | PASS   |    2|  0.094|
| [test\_entropy.R](testthat/test_entropy.R#L5)                   | entropy          | Extremes   | PASS   |    2|  0.002|
| [test\_entropy.R](testthat/test_entropy.R#L12)                  | entropy          | Ignores NA | PASS   |    1|  0.002|
| [test\_evaluate-helper.R](testthat/test_evaluate-helper.R#L7)   | evaluate\_helper | works      | PASS   |    1|  0.001|
| [test\_evaluate-helper.R](testthat/test_evaluate-helper.R#L15)  | evaluate\_helper | mean       | PASS   |    1|  0.001|
| [test\_evaluate-index.R](testthat/test_evaluate-index.R#L9_L13) | evaluate\_index  | works      | PASS   |    1|  0.010|
| [test\_evaluate-mad.R](testthat/test_evaluate-mad.R#L9)         | evaluate\_mad    | works      | PASS   |    1|  0.002|
| [test\_evaluate-mean.R](testthat/test_evaluate-mean.R#L9)       | evaluate\_mean   | works      | PASS   |    1|  0.001|
| [test\_evaluate-na.R](testthat/test_evaluate-na.R#L10)          | evaluate\_na     | works      | PASS   |    1|  0.001|
| [test\_evaluate-orig.R](testthat/test_evaluate-orig.R#L8)       | evaluate\_orig   | works      | PASS   |    6|  0.017|
| [test\_evaluate-sd.R](testthat/test_evaluate-sd.R#L9)           | evaluate\_sd     | works      | PASS   |    1|  0.002|
| [test\_insert.R](testthat/test_insert.R#L8)                     | insert           | works      | PASS   |    3|  0.002|
| [test\_replicates.R](testthat/test_replicates.R#L7)             | replicates       | works      | PASS   |    1|  0.217|
| [test\_simplify2matrix.R](testthat/test_simplify2matrix.R#L5)   | simplify2matrix  | works      | PASS   |    1|  0.001|

<!--- Final Status : pass --->
