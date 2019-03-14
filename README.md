# Feature Learning for Finding Outstanding Users


## Summary
This project is part of a scientific research. We are interested in knowing how to find experts in online community.
It is an evolution of the paper "Learning in Communities: How Do Outstanding Users Differ From Other Users?" published at the 17th IEEE International Conference on Advanced Learning Technologies - ICALT 2018.
Precisely, it is an evolution of: https://github.com/thiagoprocaci/diff-ourstanding-ordinary

## Environment

- R version 3.2.2 (available at https://www.r-project.org/)
- Python 2
- Ubuntu version 16.04.4 LTS
- Install LINE (https://github.com/tangjianpku/LINE)
- Install Node2Vec


## Data Used

The data we used were extracted from this link (https://github.com/thiagoprocaci/qa-communities-analysis/tree/postgres-migration/).
By executing a SQL command, we extracted all user classes as in the csv files in resources folder.


## How do we execute?

- Execute the sh file in scripts/top15/gen.sh
- Execute the sh file in scripts/top20/gen.sh
- Finally, execute the Python file in summary: python --folder top15 --output top15_ and python --folder top20 --output top20_

### Important information

- Change the DIM variable (ranging from 5 to 30) in sh scripts;
- Change the variables FEATURE_LEARNING_NODE_2_VEC, FEATURE_LEARNING_LINE_DIR, EDGE_LIST_BIOLOGY, EDGE_LIST_CHEMISTRY, OUTPUT_DIR according to your machine path.
