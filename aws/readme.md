# Simple scripts to automate startup/shutdown of standalone EC2 instance

*Only works on linux, and requires the AWS CLI.*

Most cool stuff like Route 53 aliases or SSL certificates only work for ELB, not single VM, so these scripts can be useful especially in combination with crontabs.

There's no magic here, but this is the kind of stuff I've had to do many times so I figured I'd share it and reuse it myself.

## How to use

Simply change the values in config.sh to match your environment, and schedule the scripts as needed. 
