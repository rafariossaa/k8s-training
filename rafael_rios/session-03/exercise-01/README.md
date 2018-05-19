Create the following:

namespace "team-vision":
  Max cpu: 80% cores
  Max mem: 80% GB

namespace "team-api":
  Max cpu: 20% cores
  Max mem: 20% GB

Pods cannot have more than 100MB of RAM
Pods cannot have more than 1 core

Users:
  Developer: 
    user: jsalmeron
    group: tech-lead, dev
  Developer:
    user: juan
    group: dev, api
  Administrator:
    user: dbarranco
    group: sre

- devs can se resources in both spaces
- api members can create resources in team-api
- vision members can create/delete/resources in team-vision (except secrets)
- teach-leads members can create/delete/resources in both spaces (except secrets)
- ONLY sres can create/delete/access secrets

