# follow_up works

    Code
      fu <- follow_up(survey1, survey2, size_subset = 50, iterations = 10)
    Condition
      Warning:
      There are some problems with the data.
      Warning:
      There are some problems with the new samples and the batches.
      Warning:
      There are some problems with the new data.
      Warning:
      There are some problems with the old data.

# valid_followup works

    Code
      out <- valid_followup(survey1, survey2)
    Condition
      Warning:
      There are some problems with the data.
      Warning:
      There are some problems with the new samples and the batches.
      Warning:
      There are some problems with the new data.
      Warning:
      There are some problems with the old data.

---

    Code
      out <- valid_followup(all_data = survey)
    Condition
      Warning:
      There are some problems with the data.
      Warning:
      There are some problems with the new samples and the batches.
      Warning:
      There are some problems with the new data.
      Warning:
      There are some problems with the old data.

