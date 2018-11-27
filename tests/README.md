Tests and Coverage
================
27 noviembre, 2018 12:22:53

-   [Coverage](#coverage)
-   [Unit Tests](#unit-tests)

This output is created by [covrpage](https://github.com/yonicd/covrpage).

Coverage
--------

Coverage summary is created using the [covr](https://github.com/r-lib/covr) package.

    ## ⚠️ Not All Tests Passed
    ##   Coverage statistics are approximations of the non-failing tests.
    ##   Use with caution
    ## 
    ##  For further investigation check in testthat summary tables.

| Object                                             | Coverage (%) |
|:---------------------------------------------------|:------------:|
| experDesign                                        |     84.65    |
| [R/reporting.R](../R/reporting.R)                  |     0.00     |
| [R/evaluate\_category.R](../R/evaluate_category.R) |     36.84    |
| [R/utils.R](../R/utils.R)                          |     83.33    |
| [R/QC.R](../R/QC.R)                                |     88.89    |
| [R/indexing.R](../R/indexing.R)                    |     95.24    |
| [R/designer.R](../R/designer.R)                    |     96.67    |
| [R/entropy.R](../R/entropy.R)                      |    100.00    |
| [R/evaluate\_num.R](../R/evaluate_num.R)           |    100.00    |
| [R/evaluate.R](../R/evaluate.R)                    |    100.00    |

<br>

Unit Tests
----------

Unit Test summary is created using the [testthat](https://github.com/r-lib/testthat) package.

| file                                                       |    n|   time|  error|  failed|  skipped|  warning| icon |
|:-----------------------------------------------------------|----:|------:|------:|-------:|--------:|--------:|:-----|
| [test\_batch-names.R](testthat/test_batch-names.R)         |    1|  0.009|      0|       0|        0|        0|      |
| [test\_create-subset.R](testthat/test_create-subset.R)     |    4|  0.012|      0|       0|        0|        0|      |
| [test\_design.R](testthat/test_design.R)                   |    2|  0.071|      0|       0|        0|        0|      |
| [test\_entropy.R](testthat/test_entropy.R)                 |    3|  0.003|      0|       0|        0|        0|      |
| [test\_evaluate-helper.R](testthat/test_evaluate-helper.R) |    2|  0.003|      0|       0|        0|        0|      |
| [test\_evaluate-index.R](testthat/test_evaluate-index.R)   |    1|  0.007|      0|       0|        0|        0|      |
| [test\_evaluate-mad.R](testthat/test_evaluate-mad.R)       |    1|  0.002|      0|       0|        0|        0|      |
| [test\_evaluate-mean.R](testthat/test_evaluate-mean.R)     |    1|  0.001|      0|       0|        0|        0|      |
| [test\_evaluate-na.R](testthat/test_evaluate-na.R)         |    1|  0.002|      0|       0|        0|        0|      |
| [test\_evaluate-orig.R](testthat/test_evaluate-orig.R)     |    6|  0.007|      0|       0|        0|        0|      |
| [test\_evaluate-sd.R](testthat/test_evaluate-sd.R)         |    1|  0.001|      0|       0|        0|        0|      |
| [test-extreme\_cases.R](testthat/test-extreme_cases.R)     |    1|  2.115|      0|       1|        0|        0| 🛑    |
| [test\_insert.R](testthat/test_insert.R)                   |    3|  0.003|      0|       0|        0|        0|      |
| [test-qc.R](testthat/test-qc.R)                            |    3|  0.003|      0|       0|        0|        0|      |
| [test\_replicates.R](testthat/test_replicates.R)           |    1|  0.123|      0|       0|        0|        0|      |
| [test\_simplify2matrix.R](testthat/test_simplify2matrix.R) |    1|  0.001|      0|       0|        0|        0|      |

<details open> <summary> Show Detailed Test Results </summary>

| file                                                            | context             | test                 | status |    n|   time| icon |
|:----------------------------------------------------------------|:--------------------|:---------------------|:-------|----:|------:|:-----|
| [test\_batch-names.R](testthat/test_batch-names.R#L6)           | batch\_names        | works                | PASS   |    1|  0.009|      |
| [test\_create-subset.R](testthat/test_create-subset.R#L5)       | create\_subset      | works                | PASS   |    2|  0.009|      |
| [test\_create-subset.R](testthat/test_create-subset.R#L12)      | create\_subset      | use\_index           | PASS   |    2|  0.003|      |
| [test\_design.R](testthat/test_design.R#L8)                     | design              | works                | PASS   |    2|  0.071|      |
| [test\_entropy.R](testthat/test_entropy.R#L5)                   | entropy             | Extremes             | PASS   |    2|  0.002|      |
| [test\_entropy.R](testthat/test_entropy.R#L12)                  | entropy             | Ignores NA           | PASS   |    1|  0.001|      |
| [test\_evaluate-helper.R](testthat/test_evaluate-helper.R#L7)   | evaluate\_helper    | works                | PASS   |    1|  0.002|      |
| [test\_evaluate-helper.R](testthat/test_evaluate-helper.R#L15)  | evaluate\_helper    | mean                 | PASS   |    1|  0.001|      |
| [test\_evaluate-index.R](testthat/test_evaluate-index.R#L9_L13) | evaluate\_index     | works                | PASS   |    1|  0.007|      |
| [test\_evaluate-mad.R](testthat/test_evaluate-mad.R#L9)         | evaluate\_mad       | works                | PASS   |    1|  0.002|      |
| [test\_evaluate-mean.R](testthat/test_evaluate-mean.R#L9)       | evaluate\_mean      | works                | PASS   |    1|  0.001|      |
| [test\_evaluate-na.R](testthat/test_evaluate-na.R#L10)          | evaluate\_na        | works                | PASS   |    1|  0.002|      |
| [test\_evaluate-orig.R](testthat/test_evaluate-orig.R#L8)       | evaluate\_orig      | works                | PASS   |    6|  0.007|      |
| [test\_evaluate-sd.R](testthat/test_evaluate-sd.R#L9)           | evaluate\_sd        | works                | PASS   |    1|  0.001|      |
| [test-extreme\_cases.R](testthat/test-extreme_cases.R#L7)       | test-extreme\_cases | extreme\_cases works | FAILED |    1|  2.115| 🛑    |
| [test\_insert.R](testthat/test_insert.R#L8)                     | insert              | works                | PASS   |    3|  0.003|      |
| [test-qc.R](testthat/test-qc.R#L6)                              | qcSubset            | all                  | PASS   |    1|  0.001|      |
| [test-qc.R](testthat/test-qc.R#L12)                             | qcSubset            | by batch             | PASS   |    2|  0.002|      |
| [test\_replicates.R](testthat/test_replicates.R#L7)             | replicates          | works                | PASS   |    1|  0.123|      |
| [test\_simplify2matrix.R](testthat/test_simplify2matrix.R#L5)   | simplify2matrix     | works                | PASS   |    1|  0.001|      |

| Failed | Warning | Skipped |
|:-------|:--------|:--------|
| 🛑      | ⚠️      | 🔶       |

</details>

<details> <summary> Session Info </summary>

| Field    | Value                        |
|:---------|:-----------------------------|
| Version  | R version 3.5.1 (2018-07-02) |
| Platform | i686-pc-linux-gnu (32-bit)   |
| Running  | Ubuntu 16.04.5 LTS           |
| Language | en\_US                       |
| Timezone | Europe/Madrid                |

| Package  | Version |
|:---------|:--------|
| testthat | 2.0.1   |
| covr     | 3.2.1   |
| covrpage | 0.0.62  |

</details>

<!--- Final Status : error/failed --->
