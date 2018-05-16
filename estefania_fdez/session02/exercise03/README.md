## Exercise III: Add postgres chart as dependency

- Add the postgresql chart as a dependency to the LEMP chart as an optional requirement.
- The postgresUser, postgresDatabase and postgresPassword variables from the dependency should not use the default value used in the postgres chart.

## Tips

Use the stable/postgres chart from the official catalog: https://github.com/kubernetes/charts/tree/master/stable/postgresql
