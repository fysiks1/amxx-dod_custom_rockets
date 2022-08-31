# Overview

This plugin sets a custom model to be used in place of rockets.

# Configuration

## Config File

Location:  \<AMXX configs dir\>/custom_rockets.ini

Configures model files and the corresponding probability (used when custom_rocket_model is set to -1).

### Example Config File
```
"models/mapmodels/cow.mdl" 10
"models/chicken.mdl" 60
"models/mapmodels/bunny.mdl" 30
```
These probability values are relative to the sum of all the values (i.e. it's not necessarily percent)

## CVARS
### custom_rocket_mode

0. Custom model is disabled
1. Custom model is enabled

### custom_rocket_chance

The probability that a custom rocket model will be used.

### custom_rocket_model

Selection for which model will be used for the custom rockets.  Models are zero-based indexed (0 is the first model) and a value of -1 will randomly choose one of the rocket models based on the probabily values defined in the config file.
