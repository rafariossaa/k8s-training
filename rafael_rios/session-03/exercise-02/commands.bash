#!/bin/bash

# Create wordpress from session01-ex01
kubectl create -f wordpress

# Create networkpolicy
kubectl create -f networkpolicy.yaml

