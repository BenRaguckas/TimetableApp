# 0.3
Finalized basic skeletal structure for table view. Querries table and shows slidable view for each day (currently a text dump).
Cleaned up some of the messy behaviour to have a more streamlined structure for further changes.
Passing some information used to querry in the Table itself.
Subjects are in a List<List> format to allow overlapping timeslots (multiple columns).

Next to work on visual display of all subjects.

# 0.2
Some work towards tidying up the filestructure.
Primarily moved all classes to their own files. Will need to re-assess views and if they would benefit from minor dividing.

## 0.1.1
Minor tidying
**NOTE:** look into certain exception handling for easy feedback. Perhaps implement timeouts too for certain elements too.
Basic skeleton implementation of PageView for TimeTable display

# 0.1
**First point of refference for progression**
Updated README.md + implemented this CHANGELOG.md

Implemented a basic Form with searchable dropdowns for selecting desired subject.
> Subject selections functions favorite (hardcoded placeholder atm)
> All other options are auto selected to their first value (same as web)
> Submit pushes a new widget that prints details of subject
*Currently it only works on default options and is untested for any others.*
*With functionality priority most of items are rudimentary*

### Plan for next
Tidy up some of the code for easier work
Get rid of redudant imports, etc.
Adjust the timetable display window to be more "easy to use".
Work on options menu as well as saving of TimeTable object.
