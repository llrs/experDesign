# experDesign 0.4.0

* Check that index used in `inspect()` has a valid length, positions and 
  replications matching the data provided.
  
* `check_data()` gains a new omit argument (#49). 
   If you relied on positional arguments it will break your scripts. 

* Omitting non existing columns now creates a warning. 

* Now it is possible to remove full rows or columns from `spatial()`: like `remove_positions = "A"` (#52).

* Fix a bug in `spatial()` that in some cases assigned multiple samples to the same position (#51).

* Spatial indexes are returned in row, column order: A1, A2, A3, ... A10, B1,. 

* Function `position_name()` is now exported to facilitate generating designs. 

# experDesign 0.3.0

* Fixed a bug in `spatial()` where multiple samples could be assigned to the 
  same position in the plate (#45).
  
* Added a warning to `batch_names()` when the index has repeated 
  positions (revealed by #45).

# experDesign 0.2.0

* New `follow_up()` and `follow_up2()` to continue an experiment safely (#22). 

* New `check_data()` to check the input data (#37).

* New `compare_index()` to compare different indexes per batch.

* Use all categories combined (column `mix_cat`) for comparing the batches.

* Increased the internal coherence of checks.

* Added thesis advisers on the description.

* Update documentation.

# experDesign 0.1.0

* Added reference to a new package Omixer on the README. 

* Fixed batches sizes errors.

* Speed increase (5x) on design, spatial and replicates.

* Update Code of Conduct.

* Add online documentation url.

# experDesign 0.0.4

* Remove BiocStyle dependency.
* Gain the ability to name the subsets.
* Add examples to all functions.
* Add function to consider spatial distribution on plates/machines.

# experDesign 0.0.2

* CRAN release

# experDesign 0.0.1

# experDesign 0.0.900

# experDesign 0.0.100

# experDesign 0.0.0.9000

* Added a `NEWS.md` file to track changes to the package.
