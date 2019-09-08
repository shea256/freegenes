#!/bin/bash

# **Important** run this command from inside the container, where you have
# Django and dependencies installed. This is typically run automatically 
# (nightly) via a cron job. See the Dockerfile, or shell into the uwsgi container:
# > service cron status
# > crontab -l
# > crontab -e

for db in "users" "main" "orders"
  do
    echo "Backing up $db"
    python /code/manage.py dumpdata $db > /code/backup/$db.json
done

# All models in one file, for loading with loaddata
python /code/manage.py dumpdata main users orders > /code/backup/models.json

# Everything
python /code/manage.py dumpdata > /code/backup/db.json
