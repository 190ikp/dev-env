#!/bin/sh

vagrant up
vagrant ssh-config --host vagrant >> ~/.ssh/config