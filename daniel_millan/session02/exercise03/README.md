## Exercise 3: Create a LEMP chart

- Add the postgresql chart as a dependency to the LEMP chart as an optional requirement.

- The postgresUser, postgresDatabase and postgresPassword variables from the dependency should not use the default value used in the postgres chart.

# What I did

##### Copy lemp chart from previous exercise

####  Add dependency to postgres chart

Add dependency in requirements.yaml under lemp folder

Make dependency optional via condition postgres.enabled

### Set values for postgresUser,Database and Password

Add postgres options in values.yaml


##### Commands
```
# Clean everything for this chart
helm delete --purge exercise03

# Install lemp chart
helm install lemp -n exercise03
```



