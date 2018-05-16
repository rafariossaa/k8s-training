Exercise 3 of session 2: Add postgres chart as dependency
Pedro Ignacio Respaldiza Hidalgo (aka Iñaki Respaldiza) 
K8s Training user: pedro_respaldiza
---

# Add postgres chart as dependency
I have created the dependency of the postgres chart by adding it in the requirements.yaml file.The value "condition" make it optional, as default is disconnected.
The attributes of the user, database name and password of postgres have been added to the values.yaml of the LEMP chart, so it have my values and are modifiable. In the postgres Chart only the password is shared by secrets, so it is the only value that I have put in base64.

